#!/usr/bin/env node
/** Sync canonical project status into byte-identical repo/vault mirrors and note AUTO blocks. */
const fs = require("fs");
const path = require("path");

const MARK_BEGIN = "<!-- AUTO:STATUS:BEGIN -->";
const MARK_END = "<!-- AUTO:STATUS:END -->";

function parseArgs(argv) {
  const out = { dryRun: false, codeRoot: null, vault: null, help: false };
  for (let i = 0; i < argv.length; i += 1) {
    const arg = argv[i];
    const next = argv[i + 1];
    if (arg === "--dry-run") out.dryRun = true;
    else if (arg === "--help" || arg === "-h") out.help = true;
    else if ((arg === "--code-root" || arg === "-c") && next) { out.codeRoot = next; i += 1; }
    else if ((arg === "--vault" || arg === "-v") && next) { out.vault = next; i += 1; }
    else throw new Error("Unknown option: " + arg);
  }
  return out;
}

function firstExisting(candidates) {
  for (const candidate of candidates) {
    if (candidate && fs.existsSync(candidate)) return path.resolve(candidate);
  }
  return null;
}

function readJson(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function loadCodeModules(codeRoot) {
  const acceptancePath = path.join(codeRoot, "scripts", "lib", "acceptance_status.js");
  const builderPath = path.join(codeRoot, "scripts", "lib", "project_status_builder.js");
  if (!fs.existsSync(acceptancePath)) throw new Error("missing shared module: " + acceptancePath);
  if (!fs.existsSync(builderPath)) throw new Error("missing shared module: " + builderPath);
  delete require.cache[require.resolve(acceptancePath)];
  delete require.cache[require.resolve(builderPath)];
  return { Acc: require(acceptancePath), Builder: require(builderPath) };
}

function renderAutoBlock(live, Acc) {
  const lines = [
    MARK_BEGIN,
    "",
    "> [!important] 自动状态（勿手改本区块）",
    `> 生成时间：${live.generated_at}`,
    `> 代码根：\`${live.paths.code_root}\``,
    `> Git：\`${live.git.short || "n/a"}\` / \`${live.git.branch || "n/a"}\`${live.git.dirty ? "（dirty）" : ""}`,
    `> 统一口径：${live.verdict}`,
    `> release_gate：\`${live.release_gate}\` · cloud_gate：\`${live.cloud_gate}\` · research：\`${live.research_validity}\``,
    `> 状态构建器：\`${live.builder_version}\`（file_exists 仅限结构；手工标签不得授予研究信用）`,
    "",
    "| 验收项 | 状态 | 证据摘要 |",
    "|---|---|---|",
  ];
  for (const item of live.acceptance || []) {
    const summary = (item.evidence || []).map((evidence) =>
      `${evidence.ok ? "✓" : "✗"} ${evidence.path} — ${evidence.detail}`
    ).join("<br>");
    lines.push(`| ${item.title} | ${Acc.badgeForVerdict(item.verdict)} | ${summary || "—"} |`);
  }
  lines.push(
    "",
    "同步命令：",
    "```bat",
    "powershell -NoProfile -ExecutionPolicy Bypass -File \"AI项目控制台\\financial-alert-system\\_sync\\sync_vault_status.ps1\"",
    "```",
    "",
    MARK_END
  );
  return lines.join("\n");
}

function upsertAutoBlock(markdown, block) {
  const begin = markdown.indexOf(MARK_BEGIN);
  const end = markdown.indexOf(MARK_END);
  if (begin !== -1 && end !== -1 && end > begin) {
    return markdown.slice(0, begin) + block + markdown.slice(end + MARK_END.length).replace(/^\r?\n/, "\n");
  }
  const frontmatterStart = markdown.charCodeAt(0) === 0xfeff ? 1 : 0;
  if (markdown.slice(frontmatterStart, frontmatterStart + 3) === "---") {
    const close = markdown.indexOf("\n---", frontmatterStart + 3);
    if (close !== -1) {
      const insertAt = close + 4;
      return markdown.slice(0, insertAt) + "\n\n" + block + "\n" + markdown.slice(insertAt).replace(/^\r?\n/, "\n");
    }
  }
  return block + "\n\n" + markdown;
}

function frontmatterDate(now = new Date(), timeZone = process.env.VAULT_TIME_ZONE || "Asia/Shanghai") {
  const parts = new Intl.DateTimeFormat("en-US", {
    timeZone,
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
  }).formatToParts(now);
  const values = Object.fromEntries(parts.map((part) => [part.type, part.value]));
  return values.year + "-" + values.month + "-" + values.day;
}

function setFrontmatterStatus(markdown, status) {
  const frontmatterStart = markdown.charCodeAt(0) === 0xfeff ? 1 : 0;
  if (markdown.slice(frontmatterStart, frontmatterStart + 3) !== "---") return markdown;
  const close = markdown.indexOf("\n---", frontmatterStart + 3);
  if (close === -1) return markdown;
  let fm = markdown.slice(0, close + 4);
  const body = markdown.slice(close + 4);
  if (/^status:\s*.+$/m.test(fm)) fm = fm.replace(/^status:\s*.+$/m, `status: ${status}`);
  else fm = fm.replace(/\n---\s*$/, `\nstatus: ${status}\n---`);
  if (/^updated:\s*.+$/m.test(fm)) fm = fm.replace(/^updated:\s*.+$/m, `updated: ${frontmatterDate()}`);
  return fm + body;
}

function noteWantsItem(noteRel, item) {
  return (item.notes || []).some((note) => note.replace(/\\/g, "/") === noteRel.replace(/\\/g, "/"));
}

function noteStatus(relatedItems, relatedAcceptance, live) {
  if (relatedItems.length === 1 && relatedAcceptance[0]) return relatedAcceptance[0].status;
  if (live.research_validity === "RESEARCH_PASS" && live.release_gate === "open") return "release_ready";
  return "remediation_in_progress";
}

function main() {
  const args = parseArgs(process.argv.slice(2));
  if (args.help) {
    console.log("Usage: node sync_vault_status.js [--code-root PATH] [--vault PATH] [--dry-run]");
    return;
  }
  const registryPath = path.join(__dirname, "acceptance_registry.json");
  const registry = readJson(registryPath);
  const codeRoot = firstExisting([args.codeRoot].concat(registry.code_root_candidates || []));
  const vaultRoot = firstExisting([args.vault].concat(registry.vault_root_candidates || []));
  if (!codeRoot) throw new Error("No code root found");
  if (!vaultRoot) throw new Error("No vault root found");

  const { Acc, Builder } = loadCodeModules(codeRoot);
  const live = Builder.buildProjectStatus({ root: codeRoot, registry });
  const repoStatusPath = path.join(codeRoot, "project_status.json");
  const mirrorRel = registry.mirror_relpath || "AI项目控制台/financial-alert-system/project_status.json";
  const vaultStatusPath = path.join(vaultRoot, mirrorRel);
  if (!args.dryRun) Builder.writeStatusMirrors(live, [repoStatusPath, vaultStatusPath]);

  const reportPath = path.join(__dirname, "last_sync_report.json");
  if (!args.dryRun) fs.writeFileSync(reportPath, JSON.stringify({ live, vaultRoot, codeRoot }, null, 2) + "\n", "utf8");

  const noteSet = new Set();
  for (const item of registry.items || []) for (const note of item.notes || []) noteSet.add(note);
  let updated = 0;
  for (const noteRel of noteSet) {
    const notePath = path.join(vaultRoot, noteRel);
    if (!fs.existsSync(notePath)) { console.warn("[skip] missing note: " + noteRel); continue; }
    const relatedItems = registry.items.filter((item) => noteWantsItem(noteRel, item));
    const relatedAcceptance = live.acceptance.filter((item) => relatedItems.some((candidate) => candidate.id === item.id));
    const block = renderAutoBlock({ ...live, acceptance: relatedAcceptance }, Acc);
    let markdown = fs.readFileSync(notePath, "utf8");
    markdown = setFrontmatterStatus(upsertAutoBlock(markdown, block), noteStatus(relatedItems, relatedAcceptance, live));
    if (!args.dryRun) fs.writeFileSync(notePath, markdown, "utf8");
    updated += 1;
    console.log("[ok] " + noteRel);
  }

  console.log("");
  console.log("code_root=" + codeRoot);
  console.log("vault_root=" + vaultRoot);
  console.log(`notes_updated=${updated}${args.dryRun ? " (dry-run)" : ""}`);
  console.log("research_validity=" + live.research_validity);
  for (const item of live.acceptance) console.log(`- ${item.id}: ${item.verdict}`);
}

module.exports = { parseArgs, renderAutoBlock, upsertAutoBlock, frontmatterDate, setFrontmatterStatus, noteStatus, main };

if (require.main === module) {
  try { main(); }
  catch (err) { console.error(err && err.stack ? err.stack : err); process.exitCode = 1; }
}
