#!/usr/bin/env node
/**
 * sync_vault_status.js
 *
 * Single direction of truth:
 *   code repo evidence  -->  Obsidian note AUTO status blocks (+ optional frontmatter)
 *
 * Humans must not hand-edit content between:
 *   <!-- AUTO:STATUS:BEGIN -->
 *   <!-- AUTO:STATUS:END -->
 *
 * Usage:
 *   node sync_vault_status.js
 *   node sync_vault_status.js --code-root "D:\\financial-alert-system" --vault "D:\\AI  金融知识点"
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

function probeEvidence(codeRoot, evidence) {
  const results = [];
  for (const rule of evidence || []) {
    if (rule.type === "file_exists") {
      const full = path.join(codeRoot, rule.path);
      const ok = fs.existsSync(full);
      results.push({
        rule,
        ok,
        detail: ok ? `exists (${countLines(full)} lines)` : "MISSING",
      });
    } else if (rule.type === "artifact_pass") {
      const full = path.join(codeRoot, rule.path);
      let ok = false;
      let detail = "MISSING";
      if (fs.existsSync(full)) {
        try {
          const j = readJson(full);
          const status = String(j.status || j.result || j.pass || "").toLowerCase();
          ok = status === "pass" || status === "passed" || j.ok === true || j.passed === true;
          detail = ok ? `artifact PASS (${rule.path})` : `artifact present but not PASS (${status || "unknown"})`;
        } catch (e) {
          detail = `artifact unreadable: ${e.message}`;
        }
      }
      results.push({ rule, ok, detail });
    } else {
      results.push({ rule, ok: false, detail: `unknown evidence type: ${rule.type}` });
    }
  }
  return results;
}

function itemPassed(item, evidenceResults) {
  const req = item.pass_requires || "all";
  if (req === "all") return evidenceResults.every((r) => r.ok);
  if (req === "any") return evidenceResults.some((r) => r.ok);
  return false;
}

function buildLiveStatus(codeRoot, registry) {
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

  const items = registry.items.map((item) => {
    const evidence = probeEvidence(codeRoot, item.evidence);
    const passed = itemPassed(item, evidence);
    return {
      id: item.id,
      title: item.title,
      status: passed ? "accepted" : "not_accepted",
      passed,
      evidence: evidence.map((e) => ({
        path: e.rule.path || e.rule.type,
        ok: e.ok,
        detail: e.detail,
      })),
    };
  });

  return {
    version: "project-status-v1",
    generated_at: new Date().toISOString(),
    product: "financial-alert-system",
    source_of_truth: "acceptance_registry.json + live code probes",
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
    },
  };
}

function renderAutoBlock(live, notePath) {
  const related = (live.acceptance || []).filter((item) => {
    // notes matching is done by caller; here render all for dashboard notes
    return true;
  });

  const lines = [];
  lines.push(MARK_BEGIN);
  lines.push("");
  lines.push("> [!important] 自动状态（勿手改本区块）");
  lines.push(`> 生成时间：${live.generated_at}`);
  lines.push(`> 代码根：\`${live.paths.code_root}\``);
  lines.push(
    `> Git：\`${live.git.short || "n/a"}\` / \`${live.git.branch || "n/a"}\`${live.git.dirty ? "（dirty）" : ""}`
  );
  lines.push("> 事实源：代码仓探针 + `_sync/acceptance_registry.json`（不是聊天记忆）");
  lines.push("");
  lines.push("| 验收项 | 状态 | 证据摘要 |");
  lines.push("|---|---|---|");
  for (const item of related) {
    const badge = item.passed ? "✅ 已验收" : "❌ 未验收";
    const summary = item.evidence
      .map((e) => `${e.ok ? "✓" : "✗"} ${e.path}`)
      .join("<br>");
    lines.push(`| ${item.title} | ${badge} | ${summary} |`);
  }
  lines.push("");
  lines.push("同步命令：");
  lines.push("```bat");
  lines.push("node \"AI项目控制台\\financial-alert-system\\_sync\\sync_vault_status.js\"");
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
  // insert after frontmatter if present
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

  const live = buildLiveStatus(codeRoot, registry);

  // write machine-readable mirror into vault
  const mirrorRel = registry.mirror_relpath || "AI项目控制台/financial-alert-system/project_status.json";
  const mirrorPath = path.join(vaultRoot, mirrorRel);
  if (!args.dryRun) {
    fs.mkdirSync(path.dirname(mirrorPath), { recursive: true });
    fs.writeFileSync(mirrorPath, JSON.stringify(live, null, 2) + "\n", "utf8");
  }

  // also write report next to script
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
    const block = renderAutoBlock(relatedLive, noteRel);
    let md = fs.readFileSync(notePath, "utf8");
    md = upsertAutoBlock(md, block);

    // If note maps to exactly one item with frontmatter policy, set status
    if (relatedItems.length === 1) {
      const item = relatedItems[0];
      const liveItem = live.acceptance.find((a) => a.id === item.id);
      if (liveItem) {
        const st = liveItem.passed
          ? item.frontmatter_status_on_pass || "done"
          : item.frontmatter_status_on_fail || "acceptance_failed";
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
  for (const a of live.acceptance) {
    console.log(`- ${a.id}: ${a.passed ? "ACCEPTED" : "NOT_ACCEPTED"}`);
  }
}

try {
  main();
} catch (err) {
  console.error(err.message || err);
  process.exitCode = 1;
}
