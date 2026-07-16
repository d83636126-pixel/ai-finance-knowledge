#!/usr/bin/env node
/**
 * sync_vault_status.js
 *
 * Single direction of truth:
 *   code repo evidence  -->  Obsidian note AUTO status blocks (+ optional frontmatter)
 *
 * Graded verdicts via scripts/lib/acceptance_status.js (shared with generate_project_status).
 *
 * Usage:
 *   node sync_vault_status.js
 *   node sync_vault_status.js --code-root "F:\\financial-alert-system" --vault "F:\\AI 金融知识点"
 *   node sync_vault_status.js --dry-run
 */

const fs = require("fs");
const path = require("path");
const { execSync } = require("child_process");

const MARK_BEGIN = "<!-- AUTO:STATUS:BEGIN -->";
const MARK_END = "<!-- AUTO:STATUS:END -->";

function parseArgs(argv) {
  const out = { dryRun: false, codeRoot: null, vault: null, help: false };
  for (let i = 0; i < argv.length; i += 1) {
    const t = argv[i];
    const n = argv[i + 1];
    if (t === "--dry-run") out.dryRun = true;
    else if (t === "--help" || t === "-h") out.help = true;
    else if ((t === "--code-root" || t === "-c") && n) {
      out.codeRoot = n;
      i += 1;
    } else if ((t === "--vault" || t === "-v") && n) {
      out.vault = n;
      i += 1;
    } else {
      throw new Error(`Unknown option: ${t}`);
    }
  }
  return out;
}

function firstExisting(candidates) {
  for (const p of candidates) {
    if (p && fs.existsSync(p)) return path.resolve(p);
  }
  return null;
}

function readJson(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function safeGit(codeRoot, args) {
  try {
    return execSync(`git ${args}`, {
      cwd: codeRoot,
      encoding: "utf8",
      stdio: ["ignore", "pipe", "ignore"],
    }).trim();
  } catch {
    return null;
  }
}

function countLines(filePath) {
  try {
    const text = fs.readFileSync(filePath, "utf8");
    if (!text) return 0;
    return text.split(/\r?\n/).length;
  } catch {
    return null;
  }
}

function loadAcceptanceStatus(codeRoot) {
  const modPath = path.join(codeRoot, "scripts", "lib", "acceptance_status.js");
  if (!fs.existsSync(modPath)) {
    throw new Error("missing shared module: " + modPath);
  }
  delete require.cache[require.resolve(modPath)];
  return require(modPath);
}

function buildLiveStatus(codeRoot, registry, Acc) {
  const commit = safeGit(codeRoot, "rev-parse HEAD");
  const short = safeGit(codeRoot, "rev-parse --short HEAD");
  const branch = safeGit(codeRoot, "rev-parse --abbrev-ref HEAD");
  const dirty = (() => {
    const s = safeGit(codeRoot, "status --porcelain");
    return s !== null && s.length > 0;
  })();

  const watched = [
    "static/propagation_app.js",
    "static/research_workbench.js",
    "static/propagation_engine.js",
    "static/data.js",
    "index.html",
    "package.json",
  ];
  const files = {};
  for (const rel of watched) {
    const full = path.join(codeRoot, rel);
    if (fs.existsSync(full)) files[rel] = countLines(full);
  }

  const items = Acc.evaluateRegistryItems(codeRoot, registry);
  const remediation = registry.remediation || null;

  const researchPass = items.some((i) => i.verdict === Acc.VERDICTS.RESEARCH_PASS);
  const anyBlock = items.some((i) => i.verdict === Acc.VERDICTS.BLOCK);

  return {
    version: "project-status-v2",
    generated_at: new Date().toISOString(),
    product: "financial-alert-system",
    source_of_truth: "acceptance_registry.json + acceptance_status.js graded probes",
    verdict: (remediation && remediation.project_status_verdict)
      || "整改中，未发布，研究有效性未证明",
    release_gate: (remediation && remediation.release_gate) || "blocked",
    cloud_gate: (remediation && remediation.cloud_gate) || "blocked",
    research_validity: researchPass ? "RESEARCH_PASS" : "BLOCK",
    remediation,
    git: {
      commit: commit || null,
      short: short || null,
      branch: branch || null,
      dirty,
      remote: "https://github.com/d83636126-pixel/financial-alert-system.git",
    },
    paths: {
      code_root: codeRoot,
    },
    files,
    acceptance: items,
    meta: {
      run_at: new Date().toISOString(),
      node: process.version,
      platform: process.platform,
      suite: "sync_vault_status",
      grader: "acceptance_status.js",
      any_block: anyBlock,
    },
  };
}

function renderAutoBlock(live, Acc) {
  const related = live.acceptance || [];
  const lines = [];
  lines.push(MARK_BEGIN);
  lines.push("");
  lines.push("> [!important] 自动状态（勿手改本区块）");
  lines.push(`> 生成时间：${live.generated_at}`);
  lines.push(`> 代码根：\`${live.paths.code_root}\``);
  lines.push(
    `> Git：\`${live.git.short || "n/a"}\` / \`${live.git.branch || "n/a"}\`${live.git.dirty ? "（dirty）" : ""}`
  );
  lines.push(`> 统一口径：${live.verdict || "整改中，未发布，研究有效性未证明"}`);
  lines.push(
    `> release_gate：\`${live.release_gate || "blocked"}\` · cloud_gate：\`${live.cloud_gate || "blocked"}\` · research：\`${live.research_validity || "BLOCK"}\``
  );
  lines.push("> 事实源：`acceptance_status.js` 分级探针（SCAFFOLD ≠ RESEARCH，file_exists ≠ ACCEPTED）");
  lines.push("");
  lines.push("| 验收项 | 状态 | 证据摘要 |");
  lines.push("|---|---|---|");
  for (const item of related) {
    const badge = Acc.badgeForVerdict(item.verdict);
    const summary = (item.evidence || [])
      .map((e) => `${e.ok ? "✓" : "✗"} ${e.path}`)
      .join("<br>");
    lines.push(`| ${item.title} | ${badge} | ${summary || "—"} |`);
  }
  lines.push("");
  lines.push("同步命令：");
  lines.push("```bat");
  lines.push("powershell -NoProfile -ExecutionPolicy Bypass -File \"AI项目控制台\\financial-alert-system\\_sync\\sync_vault_status.ps1\"");
  lines.push("```");
  lines.push("");
  lines.push(MARK_END);
  return lines.join("\n");
}

function upsertAutoBlock(markdown, block) {
  const begin = markdown.indexOf(MARK_BEGIN);
  const end = markdown.indexOf(MARK_END);
  if (begin !== -1 && end !== -1 && end > begin) {
    const before = markdown.slice(0, begin);
    const after = markdown.slice(end + MARK_END.length);
    return before + block + after.replace(/^\r?\n/, "\n");
  }
  if (markdown.startsWith("---")) {
    const close = markdown.indexOf("\n---", 3);
    if (close !== -1) {
      const insertAt = close + 4;
      return markdown.slice(0, insertAt) + "\n\n" + block + "\n" + markdown.slice(insertAt).replace(/^\r?\n/, "\n");
    }
  }
  return block + "\n\n" + markdown;
}

function setFrontmatterStatus(markdown, status) {
  if (!markdown.startsWith("---")) return markdown;
  const close = markdown.indexOf("\n---", 3);
  if (close === -1) return markdown;
  let fm = markdown.slice(0, close + 4);
  const body = markdown.slice(close + 4);
  if (/^status:\s*.+$/m.test(fm)) {
    fm = fm.replace(/^status:\s*.+$/m, `status: ${status}`);
  } else {
    fm = fm.replace(/\n---\s*$/, `\nstatus: ${status}\n---`);
  }
  if (/^updated:\s*.+$/m.test(fm)) {
    fm = fm.replace(/^updated:\s*.+$/m, `updated: ${new Date().toISOString().slice(0, 10)}`);
  }
  return fm + body;
}

function noteWantsItem(noteRel, item) {
  return (item.notes || []).some((n) => n.replace(/\\/g, "/") === noteRel.replace(/\\/g, "/"));
}

function main() {
  const args = parseArgs(process.argv.slice(2));
  if (args.help) {
    console.log(`Usage:
  node sync_vault_status.js [--code-root PATH] [--vault PATH] [--dry-run]`);
    return;
  }

  const registryPath = path.join(__dirname, "acceptance_registry.json");
  const registry = readJson(registryPath);

  const codeRoot = firstExisting(
    [args.codeRoot].concat(registry.code_root_candidates || [])
  );
  const vaultRoot = firstExisting(
    [args.vault].concat(registry.vault_root_candidates || [])
  );

  if (!codeRoot) {
    throw new Error(
      `No code root found. Tried: ${(registry.code_root_candidates || []).join(", ")}`
    );
  }
  if (!vaultRoot) {
    throw new Error(
      `No vault root found. Tried: ${(registry.vault_root_candidates || []).join(", ")}`
    );
  }

  const Acc = loadAcceptanceStatus(codeRoot);
  const live = buildLiveStatus(codeRoot, registry, Acc);

  const mirrorRel = registry.mirror_relpath || "AI项目控制台/financial-alert-system/project_status.json";
  const mirrorPath = path.join(vaultRoot, mirrorRel);
  if (!args.dryRun) {
    fs.mkdirSync(path.dirname(mirrorPath), { recursive: true });
    fs.writeFileSync(mirrorPath, JSON.stringify(live, null, 2) + "\n", "utf8");
  }

  const reportPath = path.join(__dirname, "last_sync_report.json");
  if (!args.dryRun) {
    fs.writeFileSync(reportPath, JSON.stringify({ live, vaultRoot, codeRoot }, null, 2) + "\n", "utf8");
  }

  const noteSet = new Set();
  for (const item of registry.items) {
    for (const n of item.notes || []) noteSet.add(n);
  }

  let updated = 0;
  for (const noteRel of noteSet) {
    const notePath = path.join(vaultRoot, noteRel);
    if (!fs.existsSync(notePath)) {
      console.warn(`[skip] missing note: ${noteRel}`);
      continue;
    }

    const relatedItems = registry.items.filter((item) => noteWantsItem(noteRel, item));
    const relatedLive = {
      ...live,
      acceptance: live.acceptance.filter((a) => relatedItems.some((i) => i.id === a.id)),
    };
    const block = renderAutoBlock(relatedLive, Acc);
    let md = fs.readFileSync(notePath, "utf8");
    md = upsertAutoBlock(md, block);

    if (relatedItems.length === 1) {
      const item = relatedItems[0];
      const liveItem = live.acceptance.find((a) => a.id === item.id);
      if (liveItem) {
        const st = liveItem.passed
          ? item.frontmatter_status_on_pass || liveItem.verdict.toLowerCase()
          : item.frontmatter_status_on_fail || "block";
        md = setFrontmatterStatus(md, st);
      }
    }

    if (!args.dryRun) {
      fs.writeFileSync(notePath, md, "utf8");
    }
    updated += 1;
    console.log(`[ok] ${noteRel}`);
  }

  console.log("");
  console.log(`code_root=${codeRoot}`);
  console.log(`vault_root=${vaultRoot}`);
  console.log(`notes_updated=${updated}${args.dryRun ? " (dry-run)" : ""}`);
  console.log(`research_validity=${live.research_validity}`);
  for (const a of live.acceptance) {
    console.log(`- ${a.id}: ${a.verdict}`);
  }
}

try {
  main();
} catch (err) {
  console.error(err && err.stack ? err.stack : err);
  process.exitCode = 1;
}
