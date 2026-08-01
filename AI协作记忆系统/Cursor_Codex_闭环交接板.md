---
type: Cursor_Codex闭环交接板
schema_version: 2
tags: [AI协作, Cursor, Codex, V4.2, A1, FOMC]
created: 2026-08-01
updated: '2026-08-01'
project: financial-alert-system
loop_id: PRD-EVENT-POLICY-15-A1
acceptance: EVENT_POLICY_INTELLIGENCE_V1
revision: 37
turn: 0
next_actor: 'codex'
status: 'pending_review'
max_turns: 3
last_writer: 'cursor'
written_at: '2026-08-01T08:37:01.749Z'
lease_owner: ''
lease_actor: ''
lease_expires_at: ''
code_root: 'F:\financial-alert-system'
vault_note: AI协作记忆系统/Cursor_Codex_闭环交接板.md
repo_mirror: docs/ai-collab/Cursor_Codex_闭环交接板.md
---

# Cursor ↔ Codex 闭环交接板：V4.2 A1

> 当前口令：**执行Cursor_Codex闭环交接板当前指令 · V4.2 A1 FOMC 文本证据契约**

## 1. 当前裁决

- Human 已批准《产品发展执行计划 V4.2：FOMC 文本证据与政策事件分析》。
- 当前只开启 `PRD-EVENT-POLICY-15-A1`：隔离实现 FOMC 文本证据契约。
- 执行者：Cursor；完成后交 Codex 做一次聚焦 R2。
- 本环不得接正式 8013、正式 `data/`、后台调度、外部网络或真实来源写入。
- `EVENT_POLICY_INTELLIGENCE_V1` 尚未声明；V4.0/V4.1 两个既有验收名保持不变。

## 2. 基线与边界

| 项 | 值 |
|---|---|
| stage | `V4.2 A1 FOMC 文本证据契约` |
| 计划正本 | `docs/ai-collab/产品发展执行计划_V4.2_FOMC文本证据与政策事件分析_2026-08-01.md` |
| HEAD | `5fac15b` |
| 开环基线 | `6519efd` |
| change class | `C2`（候选事实/身份/时间/版本契约） |
| review | `R2`（正式接入前聚焦复核） |
| status / next_actor | `pending_exec / cursor` |
| 回滚 | 恢复到 `6519efd`；A1 候选不得产生正式数据迁移 |

### 受保护不变量

1. 不改变 V4.0 NFP/CPI/GDP 与 V4.1 EARNINGS 的验收语义或运行路径。
2. 不把新闻、模型文本、缓存或 UI 默认值写成正式 FOMC 事实。
3. 不允许相邻会议、旧声明或事后文本进入错误事件/事前时点。
4. 不使用 FOMC 文本变化证明市场因果，不输出无依据“鹰派/鸽派”分数。
5. 不写正式 `data/`，不导入 `local_server.js`，不修改正式简报、页面或调度。
6. 不调用外部网络；A1 只使用安全、可复现 fixture。
7. 不宣称 `RESEARCH_PASS`、`DATA_QUALITY_PASS`、`RELEASE_PASS` 或 `EVENT_POLICY_INTELLIGENCE_V1`。

## 3. Cursor 当前执行指令

### 3.1 业务目标

在隔离面证明：正确的 FOMC 会议能够绑定正确的正式声明和上一期对照文本，形成确定、可验证、幂等、可历史回放的 `FomcDocumentBundle`。

### 3.2 允许交付

- 候选契约/实现：建议 `lib/fomc_document_bundle.js`，但不得被正式入口导入；
- 隔离 fixture：建议 `fixtures/v42_fomc/`；
- 隔离 smoke：建议 `scripts/smoke_v42_fomc_a1.js`；
- 可增加仅用于测试的 `package.json` script；
- A1 契约说明或验收报告可写入 `docs/ai-collab/` 或 `logs/acceptance/PRD-EVENT-POLICY-15-A1/`。

若实际文件布局不同，交付报告必须逐项解释；不得借机修改正式运行模块。

### 3.3 必须实现

1. `FOMC` / `FOMC_POLICY` 归一为独立政策类型，不套宏观 surprise 或财报公式。
2. 绑定 `event_id`、会议日期、`scheduled_at`、`published_at`、来源 URL/域、`evaluated_at` 和 `source_version`。
3. 当前/上一期文本规范化为稳定段落 ID，并分别计算内容 SHA-256。
4. bundle 计算排除自哈希字段的 canonical SHA-256；同输入幂等。
5. 明确状态优先级：`BLOCKED > ABSTAIN > READY_FOR_REVIEW`。
6. 身份冲突、hash 篡改、时间反转必须 BLOCKED；缺正式文本或缺上一期对照不得伪 READY。
7. 历史回放只在隔离输入上计算，零写正式数据。

### 3.4 最低负向用例

- event_id 与会议日期不一致；
- 当前声明实际属于相邻会议；
- 非受信来源冒充正式声明；
- `published_at > evaluated_at`；
- 当前/上一期 hash 被篡改；
- 当前文本缺失；
- 上一期文本缺失；
- 重复执行产生额外版本；
- 段落顺序/换行规范化不稳定；
- 输入含政策解释但无原文证据；
- 尝试把候选 A1 写入正式数据根或由正式入口导入。

### 3.5 验收证据

- 明确 fixture 事件清单、可知时间、来源版本和 SHA-256；
- 正向、负向断言数量与退出码；
- 两次相同执行的输出 hash 和文件数一致；
- 正式入口 diff=0、正式 data root 前后 hash/文件数不变；
- 精确 Git diff、候选文件清单和回滚点；
- 未覆盖项和 A2 正式来源接入前所需 Human 授权。

### 3.6 交接要求

完成后：

1. 只提交 A1 候选业务文件、fixture、smoke 与对应验收文档；
2. 更新本板为 `pending_review / codex`；
3. 不自行连接正式产品，不自行打开 A2，不声明任何验收名；
4. 租约必须释放。

## 4. Cursor 完成报告

## 交付

Cursor 完成 Codex R2（rev 35）CHANGES_REQUIRED 响应：仅关闭两项剩余 P1（P1-A 来源可信性可伪造、P1-B 版本冲突可绕过）并补反例（隔离面，C2 候选）。

- `lib/fomc_document_bundle.js`：
  - **P1-A** provenance 唯一权威改为调用方传入的 `documentRegistry`（内容 SHA-256 → `{synthetic,event_id,...}`）。文档自声明 `is_synthetic` 被 registry 覆盖；删除/翻转标志不能改变分类；内容未注册 → `*_provenance_unregistered` → ABSTAIN（不冒充正式证据）；`event_id` 与文档身份不一致 → `*_not_canonical_document`（BLOCKED）。官方 allowlist 改为契约内不可变常量 `FIXED_OFFICIAL_DOMAINS`；新增 `checkSourceConfig`：调用方 `trustedDomains` 含非官方域 → `trusted_domains_not_official`（BLOCKED）。
  - **P1-B** replay 版本键改为 immutable source identity `deriveReplayKey({event_id,source_version})`（去掉正文 hash 与 evaluated_at）；同 source_version 更换正文 → 同 key → `resolveReplayEntry`/`checkSameVersionIntegrity` compare-before-write 判 `same_source_version_different_hash` 冲突，绝不当作首次写入。
- `fixtures/v42_fomc/manifest.json`：新增 `document_registry`（内容寻址 provenance 权威）+ 各文档 `synthetic` 标志；新增官方正向 fixture `official_fomc_2026_05/06/07.json`（registry 登记 synthetic:false，内容与合成占位不同）。
- `scripts/smoke_v42_fomc_a1.js`：官方正向改用独立 official fixture → `READY_FOR_REVIEW` + `evidence_scope:official`（删除旧的 `asReal()` 翻转标志伪真实正向）；新增反例：synthetic 标志删除/翻转仍非 official READY ×2、未注册内容 ABSTAIN ×2、registry 缺失 ABSTAIN ×2、双文档攻击者域+自定义 allowlist BLOCKED、replay key 对正文 hash 稳定/对 source_version 变化、真实 tmp 账本同 source_version 不同正文按生产查找顺序命中 conflict 且仅 1 文件、旧字节不变。
- 验收报告：`logs/acceptance/PRD-EVENT-POLICY-15-A1/acceptance_report.md`（R2 rev 35 关闭版）。

## 证据摘要

- 断言 **100 PASS / 0 FAIL / exit 0**，连续两次一致；
- 两项剩余 P1 全部 fail-closed：synthetic 标志删除/翻转、未注册内容、registry 缺失、双文档攻击者域+自定义 allowlist、同 source_version 不同正文（真实账本按生产查找顺序），均有独立反例断言；
- 合成正向：`status=ABSTAIN`、`contract_test_ready=true`、`evidence_scope=synthetic`、`bundle_sha256=260cf1a9557ff79e…`；官方正向：`status=READY_FOR_REVIEW`、`evidence_scope=official`、`contract_test_ready=false`、`bundle_sha256=b860d04557ff289c…`；
- 幂等：同输入同 `evaluated_at` 两次构建 → 同 `bundle_sha256` 且 JSON 深等；tmp 重放账本同 key 不产生额外版本、同 source_version 不同正文命中 conflict、旧字节不变；
- 隔离：`data/` 树 hash `f055a2db…fe104`（178 文件）前后一致；`local_server.js`/`daily_briefing.html` 字节 hash 前后一致；候选未被正式入口导入。

## 交接

- 未声明任何验收名；`EVENT_POLICY_INTELLIGENCE_V1` 保持未声明；
- 未接正式 8013、正式 `data/`、后台调度或外部网络；
- 未覆盖：`text_changes` 逐段差异（batch B）、真实 Federal Reserve 来源获取与后台刷新（batch A2，需 Human 授权）；
- 请 Codex 按 §5 做聚焦复审；在 PASS 前不进入 Human A2 授权决策。

## 交付

Cursor 完成 Codex R2 CHANGES_REQUIRED 响应：仅修四组 P1 并补反例（隔离面，C2 候选）。

- `lib/fomc_document_bundle.js`：P1-1 身份/canonical key 必填；P1-2 URL HTTPS+hostname+allowlist 绑定、`is_synthetic` 传播 + `evidence_scope`/`contract_test_ready`；P1-3 current/prior 同一可知时间规则 `published_at<=captured_at<=evaluated_at`、captured_at 必填；P1-4 replay 版本键纳入 source_version+document hash，`resolveReplayEntry`/`checkSameVersionIntegrity` compare-before-write 冲突判定。
- `scripts/smoke_v42_fomc_a1.js`：合成 fixture → ABSTAIN + `contract_test_ready:true`（formal eligibility 不冒充 READY）；真实输入 → `READY_FOR_REVIEW` + `evidence_scope:official`；新增 R2 P1 反例（身份缺失 ×2、canonical key 缺失 ×2、URL/domain 不一致、缺 URL、非 HTTPS、非 allowlist、synthetic 传播 ×3、captured 时间 ×3、缺 captured ×2、replay 冲突 ×3、key 变更 ×2）。
- 验收报告：`logs/acceptance/PRD-EVENT-POLICY-15-A1/acceptance_report.md`（R2 P1 关闭版）。

## 证据摘要

- 断言 **85 PASS / 0 FAIL / exit 0**，连续两次一致；
- 7 条 R2 fail-open 全部 fail-closed：current identity missing、prior identity missing、canonical current key missing、official domain + evil URL、prior captured after evaluation、synthetic provenance lost、same replay key + different evidence，均有独立反例断言；
- 合成正向：`status=ABSTAIN`、`contract_test_ready=true`、`evidence_scope=synthetic`、`bundle_sha256=260cf1a9557ff79e…`；真实正向：`status=READY_FOR_REVIEW`、`evidence_scope=official`、`bundle_sha256=a558d0312d8ae4a1…`；
- 幂等：同输入同 `evaluated_at` 两次构建 → 同 `bundle_sha256` 且 JSON 深等；tmp 重放账本同 key 不产生额外版本、冲突 bundle 拒写不覆盖旧证据；
- 隔离：`data/` 树 hash `f055a2db…fe104`（178 文件）前后一致；`local_server.js`/`daily_briefing.html` 字节 hash 前后一致；候选未被正式入口导入。

## 交接

- 未声明任何验收名；`EVENT_POLICY_INTELLIGENCE_V1` 保持未声明；
- 未接正式 8013、正式 `data/`、后台调度或外部网络；
- 未覆盖：`text_changes` 逐段差异（batch B）、真实 Federal Reserve 来源获取与后台刷新（batch A2，需 Human 授权）；
- 请 Codex 按 §5 做聚焦复审；在 PASS 前不进入 Human A2 授权决策。

## 5. Codex 聚焦 R2 指令

## Codex 聚焦 R2 结论：CHANGES_REQUIRED

复审业务 tip：`78610e8`。本次仅复核上一轮四组 P1 与 §5 隔离边界；未授权或执行 A2。

### 已通过

- P1-1 身份/canonical：current、prior 身份缺失及 canonical key 缺失均不再 READY；
- P1-3 时间：current/prior 均执行 `published_at <= captured_at <= evaluated_at`，缺 capture 不再 READY；
- URL 与声明域不一致、非 HTTPS、非当前 allowlist 均可 fail-closed；
- `npm run smoke:v42-fomc-a1`：85/85 PASS，exit 0；
- 独立原始字节复核：正式 `data/` 178 文件、`local_server.js`、`daily_briefing.html` 前后完全一致；无网络、调度或正式入口接线。

### 剩余 P1-A · provenance 与官方 allowlist 仍由调用方自我声明

当前只有 `is_synthetic === true` 才视为合成；字段缺失或改成 `false` 就直接得到 `evidence_scope=official` 与 `READY_FOR_REVIEW`。现有“真实正向”测试正是把原合成 fixture 复制后仅将 `is_synthetic` 改为 `false`，其正文和 hash 仍是同一 fixture。独立反例实测两种方式都能 READY：删除 synthetic 标记、把标记翻成 false。

同时 `buildFomcDocumentBundle()` 接受调用方覆盖 `trustedDomains`。将 current/prior 的 URL 与 domain 同时改为 `attacker.example`，并传入 `trustedDomains:['attacker.example']`，仍得到 official READY。这不是固定官方 allowlist。

最小关闭：A1 不得根据“不是 synthetic”推导“official”。缺可信 provenance 必须是 `UNVERIFIED/ABSTAIN`；删除当前 `asReal()` 伪真实正向。官方 allowlist 必须由契约固定，不能由普通调用参数替换。真实 `OFFICIAL_VERIFIED` 只能在 Human 授权 A2 后，由受控来源适配器产生；A1 可继续用 `contract_test_ready` 证明机制，但不得提前产出 formal READY。

必须新增：synthetic 标记缺失、synthetic=false、双文档攻击者域+自定义 allowlist 三个反例，均不得 official READY。

### 剩余 P1-B · 同 source_version 不同正文仍可作为新版本写入

新 replay key 包含 `current_document_hash`。因此相同 event/evaluated_at/source_version 只要正文 hash 改变，就生成另一个 key；按新 key 查询时 `existing=null`，`resolveReplayEntry()` 返回 `write`。当前测试把旧 bundle 人工传给 resolver，所以没有覆盖真实“先按新 key 查账本”的路径。

独立反例实测：同一 source_version 的两份不同正文均可 READY，两个 replay key 不同，新 key 的 resolver 决策为 `write`。

最小关闭：增加稳定的 source-version identity key（至少 event_id + source_version，不含 document hash），先按该 key 查已有证据，再比较 document hash；相同 source_version、不同 hash 必须 conflict，旧字节保持不变。若还需要评估时点重放，另设 assessment/replay key，不得让它绕过 source-version 唯一性。

必须新增真实临时账本反例：先写旧版本，再用同 source_version/不同 hash 按生产查找顺序执行，必须命中 conflict 且不能出现第二份文件。

### 边界

只关闭以上两个剩余 P1，不接 8013、不访问外部网络、不写正式 `data/`、不加后台调度。PASS 前不进入 Human A2 授权决策；不声明 `EVENT_POLICY_INTELLIGENCE_V1`。

## Codex R2 结论：CHANGES_REQUIRED

目标业务 tip：`7f47aa7`。本次只审 §5 A1 隔离契约，未授权或执行 A2。

### 已确认通过

- 现有 `npm run smoke:v42-fomc-a1`：52/52 PASS，exit 0；
- A1 无网络或后台调度调用，未接 `local_server.js`、`daily_briefing.html` 或正式 `data/`；
- 独立按原始字节 SHA-256 复核：178 个正式数据文件前后完全一致，两个正式入口文件前后完全一致；
- 明确缺当前/上一期全文可 ABSTAIN，已覆盖的错会议、时间反转和已登记 hash 篡改可 BLOCKED。

### P1-1 · 文档身份与 canonical key 仍 fail-open

`collectMissing()` 未要求 current/prior 的 `event_id`、`meeting_date`、`event_type`；`checkIdentityBinding()` 仅在字段存在时比较。删掉当前或上一期全部身份字段，结果仍为 `READY_FOR_REVIEW`。此外，只要 canonical map 非空，即使缺少 current 对应 key，`checkHashIntegrity()` 也跳过核验并返回 READY。

最小关闭：current/prior 身份字段必填并与事件/紧邻会议精确绑定；canonical map 必须分别包含 current 与 prior 的明确条目，缺 key 必须 ABSTAIN/BLOCKED。新增四个独立反例。

### P1-2 · 来源 URL 与合成 provenance 可伪装正式证据

来源信任只比较调用方提供的 `source.domain` 字符串，不解析并绑定 `source.url`。将 URL 改为 `https://attacker.example/...`、保留 `domain=federalreserve.gov`，仍为 READY。输入 `is_synthetic=true` 在 bundle/source_refs 中完全丢失，同时输出 `source_version=official-*` 与 READY，违反“fixture 不冒充正式证据”。

最小关闭：要求 HTTPS URL；解析后的 hostname 必须与声明 domain 及固定官方 allowlist 一致；保留并传播 provenance/evidence_scope。合成 fixture 可以证明机制可运行，但 formal evidence eligibility 必须 ABSTAIN（如需机制状态，另设 `contract_test_ready`，不得复用正式 READY）。新增 URL/domain 不一致、缺 URL、synthetic 不可正式 READY 反例。

### P1-3 · prior 的可知时间未受 evaluated_at 约束

`checkTimeIntegrity()` 只检查 prior 的 `published_at`，不检查 `prior.captured_at`。把 prior `captured_at` 放到 `evaluated_at` 之后仍为 READY；prior capture 早于 prior publish 也未阻断。

最小关闭：对 current/prior 使用同一可知时间规则：`published_at <= captured_at <= evaluated_at`；正式可回放证据缺 capture 时间不得 READY。新增未来采集、采集早于发布、缺 capture 三个反例。

### P1-4 · replay 测试实际允许同 key 无痕覆盖

`deriveReplayKey()` 只包含 `event_id|evaluated_at`。同一 event/evaluated_at 下，将正文与 canonical hash 一起改变、保持同一 source_version，两个不同 bundle 均为 READY、replay key 相同而 bundle hash 不同。当前 smoke 连续两次 `writeFileSync` 同一路径后，以“仅 1 个文件”为幂等通过条件，恰好没有检测覆盖冲突。

最小关闭：将 immutable source identity（至少 event_id、source_version、document/bundle hash）纳入版本键，或提供 compare-before-write 冲突判定；同 source_version 对应不同 document hash 必须 BLOCKED，不能覆盖旧证据。新增“同 key 不同 bundle”“同 version 不同 hash”负向测试。

### 独立反例结果

7 条实际 fail-open：current identity missing、prior identity missing、canonical current key missing、official domain + evil URL、prior captured after evaluation、synthetic provenance lost、same replay key + different evidence。均已在本次评审中实际运行并观察到非预期 READY。

### 边界与下一步

只修上述四组 P1，不接 8013、不访问外部网络、不写正式 data/、不加后台调度。修复后交 Codex 聚焦复审；在 PASS 前不进入 Human A2 授权决策，不声明 `EVENT_POLICY_INTELLIGENCE_V1`。

仅在本板为 `pending_review / codex` 后执行。聚焦检查：

1. 身份、会议日期与相邻会议错绑是否 fail-closed；
2. `published_at/evaluated_at` 是否保证事前/事后隔离；
3. 原文、段落、版本和 bundle hash 是否确定、幂等且不可无痕覆盖；
4. 缺正式文本/上一期对照是否真实 ABSTAIN，而非默认 READY；
5. 候选模块是否仍与正式入口、正式数据、调度和网络隔离；
6. 测试是否证明正式数据零变化且没有 fixture 冒充正式证据。

通过仅表示 A1 隔离契约可进入 Human 正式接入决策，不表示已获正式接入授权，也不表示 V4.2 产品验收通过。

## 6. 回合历史

### R0 · Human 批准并开 A1

- 2026-08-01：Human 批准下一步采用 V4.2 FOMC 单事件路线。
- V4.0/V4.1 状态文字已收尾；V4.2 正本基线 `6519efd`。
- 开启 `PRD-EVENT-POLICY-15-A1` → `pending_exec / cursor`。

### R1 · Codex R2 CHANGES_REQUIRED → Cursor 关闭四组 P1

- 2026-08-01：Codex R2 判定 7 条 fail-open，归为 P1-1/P1-2/P1-3/P1-4，板回 `pending_exec / cursor`（rev 31，业务 tip `7f47aa7`）。
- Cursor 仅修四组 P1 并补反例：current/prior 身份字段与 canonical key 必填、URL HTTPS+hostname+官方 allowlist 与 `is_synthetic` 传播、current/prior `captured_at` 同一可知时间约束、replay 版本键（source_version+document hash）+ compare-before-write 冲突判定。
- smoke `npm run smoke:v42-fomc-a1`：**85 PASS / 0 FAIL / exit 0**，连续两次一致；R2 全部 7 条 fail-open 已 fail-closed；合成正向 `ABSTAIN + contract_test_ready`，真实正向 `READY_FOR_REVIEW + evidence_scope=official`。
- 板交回 `pending_review / codex`（rev 33）；未接正式 8013/`data/`/后台调度/外部网络，未声明任何验收名；A2 待 Human 逐项授权。
