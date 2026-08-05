---
type: Cursor_Codex闭环交接板
schema_version: 2
tags: [AI协作, Cursor, Codex, V4.2, D1, FOMC]
created: 2026-08-01
updated: '2026-08-05'
project: financial-alert-system
loop_id: PRD-EVENT-POLICY-15-D1
acceptance: POLICY_REAL_USE_D1
umbrella_acceptance: EVENT_POLICY_INTELLIGENCE_V1
revision: 65
turn: 1
next_actor: 'human'
status: 'done'
max_turns: 2
last_writer: 'cursor'
written_at: '2026-08-05T08:05:00.000Z'
lease_owner: ''
lease_actor: ''
lease_expires_at: ''
code_root: 'F:\financial-alert-system'
vault_note: AI协作记忆系统/Cursor_Codex_闭环交接板.md
repo_mirror: docs/ai-collab/Cursor_Codex_闭环交接板.md
---

# Cursor ↔ Codex 闭环交接板：V4.2 Batch D1

> 当前口令：**rev65 · 极小修复 event_id 全链路一致性已定向验证，六机制仍全 PASS，Human 直接验收并归档（done / human，V4.2 正式收尾）**

## 1. 当前裁决

- A1、A2、B1、C1 均已完成 Codex 复审、Human 验收并归档，不在 D1 重开。
- Human（2026-08-04）授权新环 `PRD-EVENT-POLICY-15-D1`，验收名 `POLICY_REAL_USE_D1`。
- Codex 对业务 tip `949b994` 复审后确认三个剩余事实安全反例：官方域 host 判断、A2 错误分类 fail-closed、正式 store 读取时重新验签。
- Cursor（rev58→59）已按最小关闭面执行并关闭这三个反例（业务 tip `9db74dd`）：D1 smoke **PASS 97 / FAIL 0**、浏览器走查 **PASS 35 / FAIL 0**，生产 `data/fomc_documents` 零写入。详见 §4。
- Human（2026-08-05）收紧审核预算：只做一次最终 Codex 聚焦复审（rev59）；仍未通过时不再自动循环，交 Human 决定接受风险、缩小范围、修订目标或停止扩展。
- Human（2026-08-05）在 rev61 最终复审 P1-3 CHANGES_REQUIRED 后授权路径 1（极小修复，rev62 关闭跨目录重放），并正式确认 **`POLICY_REAL_USE_D1`** 验收、**关闭 D1**（done / human，rev63，转入归档）。
- Human（2026-08-05）基于六子机制本轮全部复跑 PASS 与真实使用确认，正式声明 **`EVENT_POLICY_INTELLIGENCE_V1`**（V4.2 总体验收，rev64，转入归档）。
- Human（2026-08-05）指令：`EVENT_POLICY_INTELLIGENCE_V1` 声明归档后做一次极小修复，增加 **event_id 全链路一致性检查**，定向验证后由 Human 直接验收并归档，不再进行新一轮 Codex 复审。Cursor（rev64→65，tip `ca7a0da`）已关闭：写侧拒绝目录键不稳定的 event_id（`write_rejected_event_id_not_stable`）+ `loadVersion` 原始读绑定请求 event_id（`load_version_event_id_mismatch`，跨目录重放更早 fail-closed）；D1 smoke **106/0**、六机制回归全 PASS。见 §5 附录 R27。
- 非阻断问题登记技术债。
- 已声明：`POLICY_REAL_USE_D1`、`EVENT_POLICY_INTELLIGENCE_V1`；未声明：`RESEARCH_PASS`、`DATA_QUALITY_PASS`、`RELEASE_PASS`.

## 2. 基线、授权与边界

| 项 | 值 |
|---|---|
| stage | `V4.2 D1 简报接线与真实使用` |
| D1 计划 | `docs/ai-collab/产品发展执行计划_V4.2_D1_简报接线与真实使用_2026-08-04.md` |
| HEAD | `ca7a0da`（rev65 event_id 全链路一致性极小修复，基于 `9d226a6`） |
| 开环基线 | `66614ed` |
| 已完成 | A1 / A2 / B1 / C1 / D1（`POLICY_REAL_USE_D1` 已验收）；V4.2 总验收 `EVENT_POLICY_INTELLIGENCE_V1` 已声明 |
| change class | `C1` |
| review | `R1_PRODUCT_ONCE` |
| status / next_actor | `done / human` |
| 授权范围 | 现有 8013、每日简报、研究记录、收尾卡的最小接线与真实走查 |
| 回滚 | 关闭 D1 接线并恢复 `66614ed` 的产品路径；不删除正式事件数据 |

### 受保护不变量

1. A1/A2/B1/C1 的正式来源、身份、版本、文本差异与推断可溯语义不变。
2. 事前内容只进入研究记录，事后内容只进入收尾卡，不得相互污染。
3. 自动稿与人工修订隔离，人工内容不得被自动覆盖。
4. 缺来源、身份冲突、hash 损坏或隐藏失败必须可见，不得伪造可用状态。
5. 不新增推断算法、来源类别或市场因果结论。

## 3. Cursor 当前执行指令

### 3.1 产品目标

让用户从每日简报直接进入正确的 FOMC 工作页面，看到可核验的正式来源、事实、文本变化、反证和缺口，并在新证据出现时自动重开任务。

### 3.2 按顺序执行

1. **Top 3 理由**：FOMC 入选时展示由事件阶段和证据状态推导的真实理由。
2. **阶段路由**：未发生事件进入研究记录；已发生事件进入收尾卡。
3. **证据呈现**：显示正式来源、版本、政策事实、文本差异、反证和缺口；不可用状态 fail-loud。
4. **新证据重开**：正式版本或 `bundle_sha256` 变化后重开并标记 `NEW_EVIDENCE`。
5. **真实走查**：使用 `cal_d2h5h` 或另一条身份确认的真实 FOMC 事件，在 8013 完成端到端浏览器走查。

### 3.3 允许影响面

- `daily_briefing.html`、`event_research_record.html`、`event_research_result_v3.html`；
- `local_server.js` 及与 D1 接线直接相关的既有服务；
- D1 专属 smoke、走查清单与验收构件；
- 只允许最小改动，不重写页面、不重构架构。

### 3.4 完成与交接

完成五项自检后提交业务 diff，更新本板第 4 节并切到 `pending_review / codex`。报告必须列出真实事件、页面入口、证据状态、人工动作、数据保护与回滚证据。

不得自行声明 `POLICY_REAL_USE_D1` 或 `EVENT_POLICY_INTELLIGENCE_V1`.

### 3.5 Human 审核预算与退出条件（2026-08-05）

本环从 revision 58 起固定为：

```text
关闭 revision 57 三个已知事实安全反例
→ 一次最终 Codex 聚焦复审
→ Human 产品走查与继续/停止决策
→ 关闭 D1
```

最终复审只判断上述三个反例。不得因命名、样式、更多负向测试、性能、覆盖率、内部结构、文档、交接板或执行指针问题延长技术循环；这些内容登记技术债。若仍发现同级事实安全问题，Codex 记录证据后直接交 Human，不再自动开启下一修复轮。

## 4. Cursor 完成报告（rev58→59）

**D1 R2 三个事实安全反例已全部关闭：官方域 host 判定（P1-1）、A2 错误分类 fail-closed（P1-2）、正式 store 读取重新验签 + 展示层 verified 信号（P1-3）。`scripts/smoke_v42_fomc_d1.js` PASS 97 / FAIL 0，8013 真实浏览器走查（`scripts/walkthrough_v42_d1_p1_browser.js`）PASS 35 / FAIL 0，生产 `data/fomc_documents` 零写入。已置 `pending_review / codex`，交 Codex 本环唯一一次最终聚焦复审。**

### 4.1 P1-1 · 官方域 host 判定（关闭）

- `lib/briefing_intelligence_v4.js`：`isFomcEvent()` 的 Fed 域判断由「正则作用于完整 URL 字符串」改为 `extractUrlHost` + `isFedOfficialHost`（解析 URL hostname，规范化后精确匹配 `federalreserve.gov` / `www.federalreserve.gov` 白名单）。
- 反例（smoke `P1_58_*`）：`https://evil.example/path/.federalreserve.gov`（路径伪装）与 `https://www.federalreserve.gov.evil.example/…?ref=.federalreserve.gov`（查询/子域伪装）均不再判为 FOMC；真实 `federalreserve.gov` / `www.federalreserve.gov` 仍判为 FOMC。

### 4.2 P1-2 · A2 错误分类 fail-closed（关闭）

- `lib/v42_evidence_lookup.js`：`loadA2Evidence` 仅把明确 `no_current_version` / `version_not_found` / `not_found` 归为「无文档」→ 诚实 ABSTAIN；`corrupt_json` / 悬空指针 / hash·identity·proof 等失败一律 fail-closed 显式非 2xx + 原始 `reason`/`sub_error`（`store` 不可用 → 503）；`resolveEvidenceView` 只在 `not_found` 时输出 ABSTAIN，其余非 2xx 直通。`local_server.js` 证据端点透传 `reason`/`sub_error`。
- 反例（smoke `P2_*` + `P3t_dangling_resolve_blocked`）：corrupt_json → 409 + `corrupt_json`，产品路径非 2xx 不降级；store 不可用 → 503；悬空指针 → `current_pointer_dangling`。

### 4.3 P1-3 · 正式 store 读取重新验签 + 展示层 verified 信号（关闭）

- `lib/fomc_document_store.js` 新增 `verifyStoredRead(eventId, loaded, currentPointer)`：读路径复用写侧核心 `validateWriteInput`（canonical bundle hash、官方来源 host、事件身份、正文 hash、时间序、capability proof 公钥验签）并叠加 current 指针与 manifest↔document↔bundle 绑定；manifest 缺失/损坏/删字段亦 fail-closed。`load()` 成功返回 `read_verified:true` + `read_verification`，失败返回 `{ok:false, status:409, reason, sub_error}`。
- `lib/v42_evidence_view.js`：`buildV42EvidenceView(bundle, {read_verified})` 仅在显式 `read_verified === true`（只有 store 读路径重新验签后产生）时授予 `verified`；无信号一律视为未验签候选，`official_facts=[]`。
- `scripts/seed_v42_d1_walkthrough.js`：自检断言读回 `read_verified === true` 并把该信号传入视图。
- 反例（smoke `P3t_*`，磁盘篡改均 fail-closed 且 `official_facts=[]`）：篡改 `bundle.json` 决策事实 → `read_verification_failed` + `write_rejected_bundle_hash` + canonical 复算不一致；篡改 `manifest.bundle_sha256` → `read_manifest_bundle_hash_mismatch`；删除 `manifest.json` → `read_manifest_missing_or_corrupt`（新增，读验签不静默跳过绑定）；`current.json` 指向幽灵版本 → `current_pointer_dangling`；全新伪造 store（无 proof、外站 URL、手写 manifest）→ 409、无 `read_verified`、`official_facts=[]`。

### 4.4 自检与真实走查证据

- Smoke：`scripts/smoke_v42_fomc_d1.js` → **PASS 97 / FAIL 0**（生产诚实 ABSTAIN、ECB 非 FOMC、隔离种子 verified 完整渲染、P1-1 四反例、P1-2 三反例、P1-3 磁盘篡改 15 反例）。
- 回归：A1 **106/106**、A2 **PASS**、A4 **25/25**（store 读写路径变更后复跑通过）。
- 浏览器走查（Playwright headless，8013，`scripts/walkthrough_v42_d1_p1_browser.js`）→ **PASS 35 / FAIL 0**：
  - 生产模式：证据 API `ok:true` / `status=ABSTAIN` / `no_formal_documents=true` / reason `no_a2_formal_documents`；页面渲染「证据不足，弃权」、未验签、无正式事实块；简报 `fed_fomc_2026_07` 保留 `FOMC_TYPE/FOMC_STAGE_POST/FOMC_EVIDENCE_ABSTAIN`，`ecb_rates_2026_07` 无任何 `FOMC_*`。
  - 隔离种子模式（`FAS_FOMC_STORE_ROOT=fixtures/v42_d1_walkthrough`）：证据 API `verified=true` / `evidence_scope=official` / source_version `official-2026-07` / official_facts `target_range=3.75%-4%` + `action=HOLD` / B1 文本差异 / research_note ex_ante+ex_post；页面渲染 `v42-facts-verified`、`v42-tc-0`、ex_ante/ex_post 状态。

### 4.5 数据保护与回滚

- 纯读接线 + 隔离种子：仅 `fixtures/` 隔离目录写入（`FAS_FOMC_WRITE` 门控）；生产 `data/fomc_documents` 零写入（复跑前后 git clean）。
- 回滚：关闭 v42 接线（只读端点、页面渲染区）即恢复；不删除任何正式事件数据。
- 受保护不变量（A1/A2/B1/C1 可溯语义、阶段隔离、自动/人工隔离、fail-visible）均未改变。

## 5. Codex 最终聚焦复审结论与 rev62 极小修复（P1-3 已关闭）

最终聚焦复审结论：**CHANGES_REQUIRED · HUMAN_DECISION**。

这是 D1 本环唯一一次最终 Codex 复审。流程状态转为 `blocked / human`，不再自动开启 Cursor 修复轮。

复审目标：`9db74dd`。规定测试独立复跑：D1 smoke **97/97 PASS**，浏览器走查 **35/35 PASS**；测试后无业务文件或正式数据污染。

**rev62 关闭（Human 授权路径 1 · 极小修复，2026-08-05）**：Human 授权一次极小修复——只增加请求/store/current/manifest/document 的 event_id 一致性检查和一个跨目录重放反例，修完运行定向测试后**直接交 Human 关闭 D1，不再进行新一轮 Codex 复审**。Cursor 在业务 tip `9d226a6` 完成：

- `lib/fomc_document_store.js` `verifyStoredRead` 补齐事件身份绑定：请求/store 目录 event_id 与 document.event_id 不一致 → 409 `read_event_id_mismatch`；current 指针 event_id 必需且与 document 一致 → `read_current_pointer_event_mismatch`；`manifest.event_id` 由「仅存在时比对」改为「必需且比对」→ `read_manifest_binding_field_missing` / `read_manifest_event_mismatch`。`loadA2Evidence`/`resolveEvidenceView` 无需改动：store.load 409 沿 fail-closed 传播。
- 反例（smoke `P3t_replay_*`，篡改 6：跨目录重放）：把已验证 `fomc_2026_07` 版本目录 + current 指针整体复制到 `fomc_2099_99` 事件目录（文件自洽、hash/proof 全真实）→ `store.load("fomc_2099_99")` = 409 `read_event_id_mismatch`、不授予 `read_verified`、产品路径非 2xx 阻断、不暴露 `official_facts`。
- 定向测试：D1 smoke **102/102 PASS**（97 + 5 重放断言）；回归 A1 **106/106**、A2 **PASS**（121）、A4 **25/25**；committed seed store 读路径回归 `read_verified=true`（合法 verified 读取不受影响）；生产 `data/fomc_documents` 零写入。
- 板 revision 61→62，`last_writer=cursor`，status 保持 `blocked`，`next_actor=human` —— **直接交 Human 走查并关闭 D1，不再开启新 Codex 复审轮**。

**rev63 验收（Human，2026-08-05）**：Human 正式确认 **`POLICY_REAL_USE_D1`** 完成并验收，关闭 D1（板转 `done / human`）。验收报告 `logs/acceptance/PRD-EVENT-POLICY-15-D1/acceptance_report.md`；计划置 `accepted` / `acceptance_declared: true`；归档 `docs/ai-collab/闭环归档/V4.2_D1_简报接线与真实使用_PASS_2026-08-05.md`。仅声明 `POLICY_REAL_USE_D1`，未声明 `EVENT_POLICY_INTELLIGENCE_V1` / `RESEARCH_PASS` / `DATA_QUALITY_PASS` / `RELEASE_PASS`。

### P1-1 · 官方域 host 判定：PASS

- URL 已通过 `new URL(...).hostname` 解析，并按固定 Fed 官方 host 精确匹配。
- path/query/伪子域反例均不再获得 FOMC 身份；真实根域与 www 域保持通过。

### P1-2 · A2 错误分类 fail-closed：PASS

- 仅明确的无文档错误进入普通 ABSTAIN。
- `corrupt_json`、store unavailable、悬空指针和读验签失败均保留原始错误并返回非 2xx，不再伪装成“没有正式文档”。

### P1-3 · 正式 store 读取重新验签：CHANGES_REQUIRED（rev62 已关闭）

读路径已经验证 proof、canonical bundle hash、官方来源、时间序、manifest 与 document/bundle 的内部绑定；但仍未把**调用方请求的 event_id / 存储目录 event_id**绑定到已验签文档身份：

- `verifyStoredRead(eventId, loaded, currentPointer)` 接收 `eventId`，但没有比较 `eventId === document.event_id`；
- `currentPointer.event_id` 未与请求 event_id / document.event_id 比较；
- `manifest.event_id` 仅在字段存在时与 document 比较，缺失不会阻断。

独立反例使用现有已验签 fixture，不改其文档、proof、bundle 或 manifest 内容，只把整个 `fomc_2026_07` 版本目录复制到临时 store 的 `fomc_2099_99` 目录：

```text
requested_store_id = fomc_2099_99
stored_document_event_id = fomc_2026_07
store_ok = true
read_verified = true
resolved_verified = true
official_facts = target_range 3.75%-4%, action HOLD
```

临时目录已在同一进程完整清理。该反例意味着一条合法已验签事件的事实可在错误事件 ID 下被展示为正式事实，属于既定 P1-3 的事件身份错误，不是新增审核范围。

**rev62 关闭（2026-08-05）**：Human 授权路径 1 后，Cursor 在 `verifyStoredRead` 补齐三处事件身份绑定（请求/store event_id ↔ document、current 指针 event_id、manifest.event_id 必需且比对），并新增「篡改 6：跨目录重放」反例（`P3t_replay_*` 5 断言）。上述反例复现后 `store_ok=false` / `status=409` / `error=read_event_id_mismatch` / 不授予 `read_verified` / 产品路径非 2xx 阻断 / `official_facts=[]`。详见 §5 rev62 关闭块与 R24。

### Human 决策

按 2026-08-05 审核预算规则，Codex 不再自动要求下一技术循环。**Human 已选择路径 1（授权一次极小修复）并由 Cursor rev62 执行完毕**；另两条路径（接受风险登记技术债 / 缩小或停止）未被选择：

1. ~~授权一次极小修复：强制请求/store event_id、current pointer、manifest、document 与 bundle 事件身份一致~~（**已选并执行，rev62 关闭**）；
2. 接受本地数据目录被篡改时的跨事件重放风险，并以明确技术债关闭 D1（不得声称该边界已通过）；
3. 缩小或停止 V4.2 D1 扩展。

P1-1 / P1-2 / P1-3 三组事实安全反例现已全部关闭。下一步**直接交 Human 走查并关闭 D1**（不再开启新 Codex 复审轮）。无论选择哪条，本次不得自动声明 `POLICY_REAL_USE_D1`、`EVENT_POLICY_INTELLIGENCE_V1`、`RESEARCH_PASS`、`DATA_QUALITY_PASS` 或 `RELEASE_PASS`。

本环唯一一次最终聚焦复审。复审目标：`9db74dd`。只裁决 revision 57 三个事实安全反例是否已关闭；不因命名、样式、更多负向测试、性能、覆盖率、内部结构、文档或交接板问题延长技术循环（登记技术债）。Codex 独立复跑 `scripts/smoke_v42_fomc_d1.js`（PASS 97 / FAIL 0）与浏览器走查（PASS 35 / FAIL 0），并针对以下三项给出 **PASS / CHANGES_REQUIRED** 最终裁决；若仍存在同级事实安全问题，记录证据后直接交 Human（不再自动循环）。

### P1-1：官方域 host 判定（应已关闭）

- 原缺陷：`isFomcEvent()` 以 `/(^|\.)federalreserve\.gov/i` 直接作用于完整 URL，`https://evil.example/path/.federalreserve.gov` 可获 FOMC 身份。
- 关闭：`lib/briefing_intelligence_v4.js` 解析 URL hostname（`extractUrlHost`/`isFedOfficialHost`），规范化后对 `federalreserve.gov` / `www.federalreserve.gov` 精确 host/subdomain 匹配。
- 反例：`P1_58_path_spoof_not_fomc`、`P1_58_query_spoof_not_fomc`、`P1_58_real_fed_host_ok`、`P1_58_root_fed_host_ok`。

### P1-2：A2 错误分类 fail-closed（应已关闭）

- 原缺陷：`loadA2Evidence()` 把 store `load()` 一切失败降为 `not_found` → 诚实 ABSTAIN，掩盖 corrupt_json / 悬空指针 / hash·proof 失败。
- 关闭：仅 `no_current_version` / `version_not_found` / `not_found` → 无文档；`store` 不可用 → 503；损坏 / 悬空 / 验签失败 → 409 + 原始 `reason`/`sub_error`（`local_server.js` 透传）。
- 反例：`P2_corrupt_json_fail_closed`、`P2_corrupt_json_no_abstain`、`P2_store_unavailable_503`、`P3t_dangling_resolve_blocked`。

### P1-3：正式 store 读取重新验签（应已关闭）

- 原缺陷：`load()` 不重新验签；展示层仅凭 bundle 自述字段授予 `verified`。
- 关闭：`fomc_document_store.js` 新增 `verifyStoredRead`（读路径复用 `validateWriteInput`：current 指针、manifest↔document↔bundle 绑定、canonical hash、官方来源、事件身份、时间序、capability proof；manifest 缺失/损坏/删字段亦 fail-closed）；`load()` 成功返回 `read_verified:true`；`buildV42EvidenceView(bundle, {read_verified})` 仅在该显式信号下授予 `verified`（`official_facts=[]` 否则）。
- 反例：`P3t_forge_facts_fail_closed`/`_reason`/`_no_bundle`/`_resolve_blocked`、`P3t_manifest_tamper_fail_closed`、`P3t_manifest_missing_fail_closed`/`_resolve_blocked`、`P3t_dangling_pointer_fail_closed`、`P3t_forged_store_fail_closed`/`_no_verified`/`_no_official_facts`/`_resolve_blocked`（磁盘篡改均 fail-closed 且 `official_facts=[]`）。

### 已通过与边界

- 生产 `data/fomc_documents` 为空 → 诚实 ABSTAIN（`no_a2_formal_documents`）；ECB 普通样本非 FOMC；隔离受控种子 verified 完整渲染（来源/版本/政策事实/B1 文本差异/C1 research_note）均通过。
- 不扩展其他事件或算法，不重开 A1/A2/B1/C1 已通过范围；只关闭以上三个输入/读取边界。
- 未声明 `POLICY_REAL_USE_D1`、`EVENT_POLICY_INTELLIGENCE_V1`、`RESEARCH_PASS`、`DATA_QUALITY_PASS` 或 `RELEASE_PASS`。

请就以上三项给出最终 **PASS / CHANGES_REQUIRED** 裁决。

### 历史附录：此前 D1/C1 复审（只读）

> 以下既有内容仅供审计追溯，不是下一回合扩展指令。

D1 R1 集中产品复审结论：**CHANGES_REQUIRED**。

复审目标：`b3757fe`。D1 smoke 独立复跑 **31/31 PASS**，工作树未被测试污染；`D_STAGE_ROUTING` 与 `D_NEW_EVIDENCE_REOPEN` 的基础机制成立。但以下三项会造成事实错误或使产品主路径并未真正接入 V4.2 正式证据链，属于 P1。

### P1-1：`CENTRAL_BANK` 被无条件识别为 FOMC

- `isFomcEvent()` 对 `event_type=CENTRAL_BANK` 直接返回 true。
- 正式 registry 中存在 `ecb_rates_2026_07`（European Central Bank）；独立反例 `ecb_rate_decision_2026_09 + central_bank` 被输出为“FOMC 决议事件 / FOMC 决议未发生”。
- 这会把 ECB、BoE 等央行事件显示为 FOMC，违反事件身份边界。

最小关闭：FOMC 身份必须要求明确 `FOMC/FOMC_POLICY`，或同时核验 Fed/FOMC event_id、来源与官方域；新增 ECB/非 Fed 央行反例，必须不产生任何 `FOMC_*` code/reason。

### P1-2：D1 读取的是 V4.0 通用证据包，A2/B1/C1 未进入真实产品路径

- `/api/research/v3/evidence/:id` 只调用 `eventEvidenceBundles.load(eventId)`，没有读取 `fomc_document_store` 或 A2 verified documents。
- 真实样本 `fed_fomc_2026_07` 仍为 `auto_generic_20260730 + macro-surprise-v1`，缺口为 `forecast/actual`，理由为 `generic_minimal_no_type_calculator/no_numeric_facts`。
- 正式 `data/fomc_documents` 当前只有空 `jobs/` 目录；真实样本没有目标区间、正式声明、B1 文本差异或 C1 research_note。
- 现有 smoke 把“真实样本没有 research_note”作为 PASS，并把“能渲染一个 ABSTAIN 面板”作为 `D_REAL_USE_WALKTHROUGH` PASS；这没有满足 D1 的“正式来源、版本、事实、文本差异、反证和缺口可见”。

最小关闭：FOMC 事件必须从 A2 受控文档库取得 current/prior verified documents，并接入 B1 diff/facts 与 C1 note；若正式文档不存在，D_EVIDENCE_RENDER / D_REAL_USE 必须 ABSTAIN，不得 PASS。至少用一条身份确认的真实 FOMC 文档完成走查并展示来源、版本、政策事实、文本差异及反证/缺口。

### P1-3：未验证来源可被显示为“政策事实（正式）”

- `buildV42EvidenceView()` 直接复制 `bundle.official_facts`，返回值同时写死 `verified:false`。
- 页面无条件以“政策事实（正式）”渲染这些字段。
- 独立内存反例：来源 `https://evil.example/fake`、source `Unverified Blog`、自签 canonical SHA 的 generic ABSTAIN bundle 可通过 `validateBundle()`；伪造 `target_range=9.99%` 随后被页面显示在“政策事实（正式）”下。

最小关闭：只有通过 A2 proof、官方域、事件身份、正文/hash/时间绑定的字段才能进入“正式事实”；未验证内容必须标记为“未验证候选”或完全不进入正式事实区。补上述 evil-source 反例。

### 已通过与边界

- D1 smoke：31/31 PASS，但测试覆盖不足以关闭以上反例。
- 新证据重开已接入 briefing action filter；本轮不要求重写。
- 页面网络失败能够 fail-loud；本轮不要求样式整改。
- 不扩展关税、战争或新来源类别，不重开 A1/A2/B1/C1 已通过的底层门禁。
- 不得声明 `POLICY_REAL_USE_D1`、`EVENT_POLICY_INTELLIGENCE_V1`、`RESEARCH_PASS`、`DATA_QUALITY_PASS` 或 `RELEASE_PASS`。

Cursor 只关闭上述三组 P1，补对应反例和一条真实 FOMC 正式证据走查后，再交 Codex 做最终聚焦复审。

### 历史附录：C1 R19 及此前复审（只读，非 D1 指令）

> 以下既有 C1 内容继续保留，仅供审计追溯；D1 下一轮只复审上述三组 P1。

D1 提交后做一次集中产品 R1，只裁决：

1. `D_TOP3_REASON`
2. `D_STAGE_ROUTING`
3. `D_EVIDENCE_RENDER`
4. `D_NEW_EVIDENCE_REOPEN`
5. `D_REAL_USE_WALKTHROUGH`
6. 正式数据与人工内容保护

阻断主路径、造成事实错误、阶段污染、覆盖人工内容或隐藏失败 → `CHANGES_REQUIRED`；仅命名、样式、更多测试、性能优化 → 登记技术债并 PASS。通过后转 `done / human`。

### 历史附录：C1 R19 及此前复审（只读，非 D1 指令）

> 以下内容为 C1 审计证据，仅供追溯；D1 的当前复审范围只以上述六项为准。

## 聚焦裁决

R18 的剩余 P1 已关闭：

1. current/prior source ref 的 `url` 与 `captured_at` 已改为必填，并与对应 A2 verified document 精确一致；删除字段不能再绕过。
2. current/prior bundle document 的 `event_id`、正文 hash、URL、captured_at、synthetic 已与对应 A2 verified document 精确绑定。
3. bundle 顶层 `published_at`、`source_version` 已与 verified current document 精确绑定。
4. `evaluated_at` 必须为合法时间，并满足 `evaluated_at >= captured_at >= published_at`；倒置或非法时间 fail-closed。
5. 任一绑定失败均进入 `auto_draft_baseline_untrusted`，不会进入人工修订比较。

## 独立反例

使用真实 A2 current/prior 文档、有效 proof 和真实正文，分别只改动一个字段并重算 canonical bundle hash：

- 伪造 `current_document.captured_at` → `current_document_binding_mismatch`；
- 伪造顶层 `published_at` → `top_level_source_time_mismatch`；
- 删除 current/prior source ref 的 URL/captured_at → `current_source_identity_mismatch` + `prior_source_identity_mismatch`；
- 把 current document URL 改为外站 → `current_document_binding_mismatch`；
- `evaluated_at` 早于 captured_at → `evaluated_at_not_monotonic`；
- 伪造顶层 `source_version` → `top_level_source_time_mismatch`；
- 伪造 prior document captured_at → `prior_document_binding_mismatch`；
- 未修改的真实 bundle → trust 与 human revision 均正常通过。

上述反例均已独立复现，未依赖测试脚本自身的预期布尔值。

## 回归与数据保护

- C1 Gate1/Gate2/Gate3/Gate4/P1：`47 + 32 + 32 + 39 + 63 = 213 PASS`；
- A1 `106/106`、A2 `152/152`、A4 `25/25`、B1 `136/136`；
- 合计 **632 PASS / 0 FAIL**；
- 正式 `data/` 树哈希前后均为 `25d90020a2e68b80782be302d0d8a0c27968181c63dc3fe7170675f4c415e4fb`，无写入。

## 边界

- 本结论只表示 C1 工程门槛与本轮 P1 已通过 Codex 聚焦复审；
- Codex 不代替 Human 声明 `POLICY_INFERENCE_TRACEABILITY_C1`；
- 未声明 `EVENT_POLICY_INTELLIGENCE_V1`、`RESEARCH_PASS`、`DATA_QUALITY_PASS` 或 `RELEASE_PASS`；
- 未进入 Batch D。下一步交 Human 决定是否正式确认 C1，以及是否另行授权后续 Batch。

# C1 R19 · P1-3 来源/正式时间绑定聚焦复审

结论：**请复审**。R18 的三类独立反例（伪造 captured_at 时间倒置冻结、伪造 published_at、删除/改写 URL 与 captured_at）已关闭：URL/captured_at 从"存在才比较"改为必填精确绑定，`documentBindsToBundle` 新增 `url`/`captured_at`/`synthetic` 必填精确绑定，bundle 顶层 `published_at`/`source_version` 与已验证 current document 必填精确绑定，`evaluated_at` 增加合法性与 `evaluated_at >= captured_at >= published_at` 单调校验。

复审目标业务 tip：`50bfdab`。本轮只复核 source-ref ↔ A2 verified document 的 URL/正式时间绑定，不重开 P1-1/P1-2/P1-4，不进入 Batch D。

## 已通过证据

- R18 三类独立反例均已关闭：伪造 captured_at 时间倒置被拒；伪造 published_at 被拒；删除/改写 URL/captured_at 被拒；真实 READY 与真实 ABSTAIN 保持通过；
- C1 Gate1/Gate2/Gate3/Gate4/P1 专项：`47 + 32 + 32 + 39 + 63 = 213` 项通过；
- A1 `106/106`、A2 `152/152`、A4 `25/25`、B1 `136/136` 通过；本轮合计 **632 PASS / 0 FAIL**；
- 正式 `data/` 树哈希前后均为 `ae7447d3fb68b467fcde59fe4d2e24cabbb808063de0bbf82b7f200fd4e2818d`，无写入。

## 关闭路径（请聚焦复审）

基线：Codex R18 聚焦复审判 **CHANGES_REQUIRED**——`sourceRefBindsToVerifiedDoc` 对 URL/captured_at 使用"存在才比较"的可选检查，删除即绕过绑定；`documentBindsToBundle` 只绑定 `text_sha256 + event_id`；bundle 顶层 `published_at/source_version` 无绑定；`evaluated_at` 无时间合法性/单调性校验；`canonicalBundleSha256` 是调用方可重算的自洽校验，不能为未绑定字段提供来源权威。

本轮 Cursor 在 `lib/fomc_evidence_draft.js` 按 R18 最小关闭四项补齐绑定：

- `documentBindsToBundle`：新增 `url`/`captured_at`/`synthetic` 必填精确绑定（URL 取 `verified_provenance.final_url`/`source.url`，精确相等；`captured_at` 精确相等；`synthetic`/`is_synthetic` 必须 `false`）；缺字段或任一不一致 → `current/prior_document_binding_mismatch`；
- `sourceRefBindsToVerifiedDoc`：URL/captured_at 改为必填精确绑定（`isNonblankString` + 精确相等），删除不再绕过 → `current/prior_source_identity_mismatch`；
- 新增 `bundleTopLevelBindsToVerifiedCurrent`：bundle 顶层 `published_at`/`source_version` 与已验证 current document 必填精确绑定 → `top_level_source_time_mismatch`；
- 新增 `validMonotonicTimes`：`evaluated_at >= captured_at >= published_at`，破坏 → `evaluated_at_not_monotonic`；`toEpochMs` 本地复制 `fomc_document_bundle.js` 语义避免循环依赖；
- 检查 G（E2 之后）：仅当 `research_note` 存在时执行顶层绑定与时间单调校验，任一失败 → `auto_draft_baseline_untrusted`，不进入人工修订比较。

## 负向用例（请独立复现）

- `P1-3d_forge_captured_at_rejected`：`current_document.captured_at = "1999-01-01T00:00:00.000Z"` + 重算 canonical `bundle_sha256` → `auto_draft_baseline_untrusted` + `current_document_binding_mismatch`；
- `P1-3d_forge_published_at_rejected`：`bundle.published_at = "1999-01-01T00:00:00.000Z"` + 重算 canonical `bundle_sha256` → `top_level_source_time_mismatch`；
- `P1-3d_delete_url_captured_rejected`：删除 current/prior `source_refs[].url` + `captured_at` + 重算 canonical `bundle_sha256` → `current/prior_source_identity_mismatch`；
- `P1-3d_evil_current_url_rejected`：`current_document.url = "https://evil.example/fake-statement"` + 重算 canonical `bundle_sha256` → `current_document_binding_mismatch`；
- `P1-3d_eval_not_monotonic_rejected`：`evaluated_at = "2000-01-01T00:00:00.000Z"`（早于 captured_at/published_at）+ 重算 canonical `bundle_sha256` → `evaluated_at_not_monotonic`；
- `P1-3d_genuine_ready_ok` 等真实 READY/ABSTAIN 正例保持通过（violations 空，不误伤）。

## 裁决边界

- P1-1、P1-2、P1-4、五子机制和 `C_DATA_PROTECTION` 保持通过，不重开；
- 只关闭 source/document/top-level 中已经冻结或对外呈现的来源与时间字段绑定；
- 不接新外部网络、不写正式数据、不进入 Batch D；
- Cursor 不得自行声明 `POLICY_INFERENCE_TRACEABILITY_C1`；关闭后再交 Codex 最终聚焦复审。

请就以上给出 **PASS / CHANGES_REQUIRED** 裁决；如 CHANGES_REQUIRED 需列可复现反例与最小关闭要求，不扩展 Batch C/D 之外的授权面。

# C1 R18 · P1-3 来源与正式时间绑定聚焦复审

结论：**CHANGES_REQUIRED**。R17 的两个原样反例（缺 domain 的 READY、伪 source_version 的 ABSTAIN）已经关闭，但 bundle 内最终冻结到自动稿的 URL 与正式时间仍未绑定到 A2 已验证文档；调用方可保留真实 proof 和正文，改写正式来源/时间后重算自签 canonical hash，并被允许人工签收。

复审目标业务 tip：`b13a3ea`。本轮只复核 source-ref ↔ A2 verified document 身份绑定，不重开 P1-1/P1-2/P1-4，不进入 Batch D。

## 已通过证据

- R17 原反例均已关闭：删除 current/prior domain 的 READY 被拒；伪造 current/prior source_version 的 ABSTAIN 被拒；真实 READY 与真实 ABSTAIN 保持通过；
- C1 Gate1/Gate2/Gate3/Gate4/P1 专项：`47 + 32 + 32 + 39 + 58 = 208` 项通过；
- A1 `106/106`、A2 `152/152`、A4 `25/25`、B1 `136/136` 通过；本轮合计 **627 PASS / 0 FAIL**；
- 正式 `data/` 树哈希前后均为 `25d90020a2e68b80782be302d0d8a0c27968181c63dc3fe7170675f4c415e4fb`，无写入。

## 剩余 P1-3：冻结时间与 URL 仍可脱离 A2 证明

当前 `sourceRefBindsToVerifiedDoc()` 对 URL 和 captured_at 使用“存在才比较”的可选检查：

```js
if (sourceRef.url != null && sourceRef.url !== "") { ... }
if (sourceRef.captured_at != null && sourceRef.captured_at !== "") { ... }
```

因此删除 source ref 的 URL/captured_at 会绕过绑定。同时：

- `documentBindsToBundle()` 只绑定 `text_sha256 + event_id`，不比较 bundle document 的 `url/captured_at`；
- `verifyBundleTrust()` 不把 bundle 顶层 `published_at/source_version` 与 verified current document 绑定；
- `evaluated_at` 也未做时间合法性/单调性校验；
- `canonicalBundleSha256` 是调用方可重算的自洽性校验，不能为这些未绑定字段提供来源权威。

### 独立反例 A：伪造 captured_at 被冻结并签收

从真实 A2 READY bundle 出发，保留 current/prior 已验证文档、proof、source refs 与正文不变，仅执行：

```js
bundle.current_document.captured_at = "1999-01-01T00:00:00.000Z";
bundle.bundle_sha256 = canonicalBundleSha256(bundle);
```

当前结果：

```json
{
  "trust": {"ok": true, "violations": []},
  "validation": {"ok": true, "violations": []},
  "frozen_captured_at": "1999-01-01T00:00:00.000Z"
}
```

该时间早于 2026 年正式发布，构成明显时间倒置，却进入 `evidenceDraftFromBundle().source.captured_at` 并成为人工不可修改的冻结字段。

### 独立反例 B：伪造 published_at 被冻结并签收

仅把 `bundle.published_at` 改为 `1999-01-01T00:00:00.000Z` 并重算 bundle hash；真实 proof、正文、source refs 不变。

当前 `verifyBundleTrust` 与 `validateHumanRevision` 同样均返回 `ok:true`，伪造发布时间进入自动稿的 `source.published_at`。

### 独立反例 C：来源定位字段可删除/改写

- 删除 current/prior `source_refs[].url` 与 `captured_at`，重算 bundle hash → trust/validation 均 `ok:true`；
- 把 `current_document.url` 改为 `https://evil.example/fake-statement`，重算 bundle hash → trust/validation 均 `ok:true`。

这与 R17 最小关闭中“bundle 对外冻结 URL/captured_at 时与 proof/document 一致”及 C1 的正式来源、正式时间不可伪造边界不一致。

## 最小关闭

只补已暴露的来源/时间绑定，不扩面：

1. current/prior source ref 的 `url` 与 `captured_at` 改为必填，并与对应 verified document / proof 精确一致；缺失也必须拒绝。
2. `documentBindsToBundle()` 至少增加 `url`、`captured_at`、`synthetic` 与 verified document 的精确绑定；current/prior 分别校验。
3. bundle 顶层 `published_at`、`source_version` 与 verified current document 精确绑定；`evaluated_at` 至少必须是合法时间且满足 `evaluated_at >= captured_at >= published_at`。若 evaluated_at 需要权威审计语义，则必须来自 A2 受控存储/可信 envelope，不能靠调用方自签 hash。
4. 补三个负向用例：伪 captured_at、伪 published_at、删除 URL/captured_at；均须返回 `auto_draft_baseline_untrusted`。真实 READY/ABSTAIN 继续通过。

## 裁决边界

- P1-1、P1-2、P1-4、五子机制和 `C_DATA_PROTECTION` 保持通过，不重开；
- 只关闭 source/document/top-level 中已经冻结或对外呈现的来源与时间字段绑定；
- 不接新外部网络、不写正式数据、不进入 Batch D；
- Cursor 不得自行声明 `POLICY_INFERENCE_TRACEABILITY_C1`；关闭后再交 Codex 最终聚焦复审。

# C1 R18 · 来源身份绑定聚焦复审

复审目标业务 tip：`b13a3ea`。本轮只复核 Codex R17 判 CHANGES_REQUIRED 的 **source-ref ↔ A2 verified document 身份绑定**是否关闭，并确认已通过的 P1-1/P1-2/P1-4、五子机制和 `C_DATA_PROTECTION` 无回退；不扩展 Batch D。

## 已通过证据

- C1 Gate1/Gate2/Gate3/Gate4/P1 专项：`47 + 32 + 32 + 39 + 58 = 208` 项通过；
- A1 `106/106`、A2 `152/152`、A4 `25/25`、B1 `136/136` 通过；本轮合计 **627 PASS / 0 FAIL**；
- 正式 `data/` 树哈希前后均为 `ae7447d3fb68b467fcde59fe4d2e24cabbb808063de0bbf82b7f200fd4e2818d`（178 文件），无写入；
- R17 两个独立反例已关闭：删 domain 的 READY、伪造 source_version 的 ABSTAIN 均被拒绝；真实 READY 与真实 ABSTAIN 继续通过（不误伤）。

## 关闭路径（请聚焦复审）

`verifyBundleTrust`（`lib/fomc_evidence_draft.js`，路线 A 内存验证，零 fs）：

- **检查 C 字段完整**（恒跑）：current/prior `source_ref` 的 `domain` 非空且命中固定 allowlist（`source_ref_not_official`）、`synthetic === false`（`source_ref_synthetic`）、`source_version` 非空（`current_source_version_required`/`prior_source_version_required`）；
- **检查 E 来源身份绑定**（恒跑）：A2 proof 验签 + `documentBindsToBundle`（`text_sha256` + `event_id` 必填精确）通过后，新增 `sourceRefBindsToVerifiedDoc` 把 source_ref 与对应 A2 已验证文档逐项精确绑定——`event_id`、`text_sha256`、`source_version`（`doc.source.source_version`）、规范化 `domain`（`verified_provenance.final_domain` 优先）、URL/captured_at（bundle 冻结时一致）；缺字段或任一不一致 → `current/prior_source_identity_mismatch`；
- 任一失败 → `violations.push("auto_draft_baseline_untrusted")`，不进入人工修订比较。

## 负向用例（请独立复现）

- `P1-3c_delete_domain_ready_rejected`（Codex R17 独立反例 A 原样）：真实 READY bundle 删除两个 `source_refs[].domain` + 重算 canonical `bundle_sha256` → 必须拒绝（`auto_draft_baseline_untrusted` + `source_ref_not_official` + `current/prior_source_identity_mismatch`）；
- `P1-3c_forge_source_version_abstain_rejected`（Codex R17 独立反例 B 原样）：伪造 current/prior `source_version`（域仍官方）+ 伪 source ref 重放 research note 降 ABSTAIN + 重算 canonical `bundle_sha256` + 提交真实 A2 proof → 必须拒绝（`current/prior_source_identity_mismatch`），且重放自洽（无 `research_note_replay_mismatch`）——ABSTAIN 不能作为来源身份不一致的降级通道；
- `P1-3c_genuine_ready_ok`：真实 READY + 真证 current/prior → 通过（不误伤）；
- 既有 `P1-3b_trusted_abstain_ok`、`P1-3_*`、`O0_synthetic_untrusted_rejected` 保持通过/拒绝，无回退。

## 裁决边界

- 只复核 source-ref ↔ A2 verified document 的身份绑定；不重开已通过 P1-1/P1-2/P1-4；
- 维持五子机制与 `C_DATA_PROTECTION` 已通过部分；
- 不接新外部网络、不扩展 Batch D、不写正式数据；
- 关闭前不得声明 `POLICY_INFERENCE_TRACEABILITY_C1` 或 `EVENT_POLICY_INTELLIGENCE_V1`。

请就以上给出 **PASS / CHANGES_REQUIRED** 裁决；如 CHANGES_REQUIRED 需列可复现反例与最小关闭要求，不扩展 Batch C/D 之外的授权面。

# C1 R17 · P1-3 来源身份绑定聚焦复审

结论：**CHANGES_REQUIRED**。R16 的“无证明 ABSTAIN 可签收”反例已经关闭，但 `source_refs` 尚未与所提交的 A2 已验证文档身份绑定，调用方仍能把缺失或伪造的来源身份冻结进 canonical auto draft。

复审目标业务 tip：`02fbcb8`。本轮只复核 P1-3 根信任，不重开已通过的 P1-1/P1-2/P1-4，不扩展 Batch D。

## 已通过证据

- C1 Gate1/Gate2/Gate3/Gate4/P1 专项：`47 + 32 + 32 + 39 + 54 = 204` 项通过；
- A1 `106/106`、A2 `152/152`、A4 `25/25`、B1 `136/136` 通过；本轮合计 **623 PASS / 0 FAIL**；
- 正式 `data/` 树哈希前后均为 `25d90020a2e68b80782be302d0d8a0c27968181c63dc3fe7170675f4c415e4fb`，无写入；
- R16 原反例已经关闭：无 A2 proof 的自洽 ABSTAIN bundle 会被 `current_a2_proof_required` / `prior_a2_proof_required` 拒绝；trusted ABSTAIN 正常通过。

## 剩余 P1-3：A2 真证未绑定 bundle 的来源身份

`verifyBundleTrust()` 当前存在两个相连缺口：

1. source ref 只有在 `domain` 为 truthy 时才检查 allowlist：

```js
curRef.synthetic === true || (curRef.domain && !isTrustedOfficialDomain(curRef.domain))
```

因此 source ref 存在但删除 `domain` 时不会触发 `source_ref_not_official`。

2. `documentBindsToBundle()` 只比较 `text_sha256`，并在双方都带 `event_id` 时才比较事件；它没有把 bundle 的 `source_refs[].source_version/domain/url/captured_at` 与 A2 已验证文档的 `source` / `verified_provenance` 身份做相等绑定。

这使攻击者可以保留真实 A2 文档和有效 proof，改写 bundle 的来源标识，重算 `research_note` 与 `bundle_sha256`，仍通过根信任与人工修订。

### 独立反例 A：删除来源域仍可签收 READY

- 从 A2 testkit 生成真实 READY bundle 与 current/prior 已验证文档；
- 删除两个 `source_refs[].domain`；
- 重算 canonical `bundle_sha256`；
- 原 research note 无需修改。

当前结果：

```json
{
  "post": "READY",
  "trust": {"ok": true, "violations": []},
  "validation": {"ok": true, "violations": []}
}
```

### 独立反例 B：伪造来源版本仍可签收 ABSTAIN

- 从同一真实 A2 bundle 出发；
- 把 current/prior `source_version` 改成 `attacker-current-v1` / `attacker-prior-v1`，域仍填官方域；
- 使用伪 source ref 重放 research note，使事后状态降为 ABSTAIN；
- 重算 canonical `bundle_sha256`，同时提交原本真实有效的 A2 current/prior proof。

当前结果：

```json
{
  "post": "ABSTAIN",
  "trust": {"ok": true, "violations": []},
  "validation": {"ok": true, "violations": []}
}
```

这不会伪造政策决定本身，但会把不存在的来源版本固化为不可由人工修改的 `current_source_ref` / `prior_source_ref`，破坏 `POLICY_INFERENCE_TRACEABILITY_C1` 的核心可追溯性。ABSTAIN 不能作为来源身份不一致的降级通道。

## 最小关闭

只补 P1-3 来源绑定，不扩面：

1. current/prior source ref 必须字段完整：`domain` 非空且命中固定 allowlist，`synthetic === false`，`source_version` 非空；需要 URL 时同样要求非空且为对应官方 URL。
2. 把每个 source ref 与对应 A2 已验证文档精确绑定：至少比较 `event_id`、`text_sha256`、`source_version`、规范化后的 `domain`；若 bundle 对外冻结 URL/captured_at，也应与 proof/document 的相应字段一致。缺字段或不一致一律 `auto_draft_baseline_untrusted`。
3. 文档事件身份改为必填且精确相等，避免当前“双方都有才比较”的可选式绑定。
4. 增加上述两个原样负向用例：删除 domain 的 READY、伪造 source_version 的 ABSTAIN，均必须拒绝；真实 READY 与真实 ABSTAIN 继续通过。

## 裁决边界

- P1-1、P1-2、P1-4、五子机制和 `C_DATA_PROTECTION` 保持通过，不重开；
- 只关闭 source-ref ↔ A2 verified document 的身份绑定；
- 不接新外部网络、不写正式数据、不进入 Batch D；
- Cursor 不得自行声明 `POLICY_INFERENCE_TRACEABILITY_C1`；关闭后再交 Codex 做最终聚焦复审。

# C1 R17 · ABSTAIN 根信任聚焦复审

复审目标业务 tip：`02fbcb8`。本轮只复核 Codex R16 判 CHANGES_REQUIRED 的 **ABSTAIN 根信任绕过**是否关闭，并确认已通过的 P1-1/P1-2/P1-4、五子机制和 `C_DATA_PROTECTION` 无回退；不扩展 Batch D。

## Human 指令（2026-08-03）

> 无论 READY 还是 ABSTAIN，进入人工修订前都必须有可信来源证明；或者允许不可信 ABSTAIN 只读展示，但禁止签收和冻结。

经确认选定 **一律要求可信来源**（Codex R16 最小关闭方案 1 · 严格正式基线）：READY 与 ABSTAIN 进入人工修订前都必须有可信来源证明（A2 验签 + official scope）；未验证 bundle → `validateHumanRevision` 一律 `auto_draft_baseline_untrusted`；`factsOnlyView` 只读展示仍可用（Gate 3 不受影响）；Gate4 人工修订用例改用 A2 真证 bundle。

## 关闭路径（请聚焦复审）

`verifyBundleTrust` 调整（`lib/fomc_evidence_draft.js`，路线 A 内存验证，零 fs）：

- **检查 C 恒跑**（原仅 READY）：current/prior `source_ref` 必须存在且为官方域，否则 `current_source_ref_missing`/`prior_source_ref_missing`/`source_ref_not_official`；
- **检查 E 恒跑**（原仅 READY）：`evidence_scope === "official"`、current/prior 文档必须携带 A2 `verified_provenance + proof` 且经固定 Ed25519 公钥验签 + 绑定 `text_sha256`/`event_id`，否则 `evidence_scope_not_official`/`current_a2_proof_required`/`prior_a2_proof_required`/`*_document_binding_mismatch`；
- **检查 E2（仅 READY 声称时）**：`fact_source` 权威校验（`kind=official` + `verified:true`）拆出独立分组——ABSTAIN 无决定句式，`fact_source` 不承载权威声称，仅 READY 时要求 `fact_source_not_official`；
- 检查 A（根哈希）/ B（文档身份+正文 hash + event_id 绑定）/ D（事前冻结声明不可信）/ F（research_note replay）保持恒跑；任一失败 → `auto_draft_baseline_untrusted`。

## 负向用例（请独立复现）

- `P1-3b_untrusted_abstain_rejected`（Codex R16 原样反例）：自洽 news/cache bundle、无 A2 proof、`ex_post=ABSTAIN`、replay 与 canonical SHA 均一致 → 仍必须拒绝人工修订（`auto_draft_baseline_untrusted` + `current_a2_proof_required` + `prior_a2_proof_required`）；
- `O0_synthetic_untrusted_rejected`：合成 bundle（无 proof / `evidence_scope="unverified"`）→ `auto_draft_baseline_untrusted` + `evidence_scope_not_official`，只读展示可用但不可签收；
- `P1-3b_trusted_abstain_ok`：trusted ABSTAIN（A2 验签 + `evidence_scope="official"`，官方语句含 "target range..." 段但无区间/决定/投票 → ex_post ABSTAIN）→ 人工修订通过（violations 空），不误伤只读/人工记录；
- 既有 `P1-3_*` 11 项（伪 READY、错误根哈希、无 proof、派生篡改、真证路径）保持拒绝/通过，无回退。

## 裁决边界

- 只复核 ABSTAIN 根信任关闭；不重开已通过三组 P1；
- 维持五子机制与 `C_DATA_PROTECTION` 已通过部分；
- 不接新外部网络、不扩展 Batch D、不写正式数据；
- 关闭前不得声明 `POLICY_INFERENCE_TRACEABILITY_C1` 或 `EVENT_POLICY_INTELLIGENCE_V1`。

请就以上给出 **PASS / CHANGES_REQUIRED** 裁决；如 CHANGES_REQUIRED 需列可复现反例与最小关闭要求，不扩展 Batch C/D 之外的授权面。

# C1 R16 · P1-3 聚焦复审

结论：**CHANGES_REQUIRED**。P1-3 的 READY 路径已加固，但 ABSTAIN 路径仍允许调用方自造 bundle 根信任。

复审目标业务 tip：`71b9440`。本轮只复核 P1-3 bundle 根信任，并确认已通过的 P1-1/P1-2/P1-4、五子机制和 `C_DATA_PROTECTION` 无回退。

## 已通过证据

- C1 Gate1/Gate2/Gate3/Gate4/P1 专项：`47 + 32 + 32 + 38 + 51 = 200` 项通过；
- A1 `106/106`、A2 `152/152`、A4 `25/25`、B1 `136/136` 通过；合计 **619 PASS / 0 FAIL**；
- 正式 `data/` 零写入，既有数据保护检查保持通过；
- P1-1、P1-2、P1-4 保持关闭；P1-3 的伪 READY、错误根哈希、无 proof、派生结果篡改等已有反例均被拒绝。

## 剩余 P1-3：ABSTAIN 可绕过根信任检查

`verifyBundleTrust()` 把 source allowlist、A2 proof、`evidence_scope=official` 与 fact-source 权威校验全部放在：

```js
research_note.ex_post.status === "READY"
```

条件之下。将伪 bundle 的 ex-post 状态设为 `ABSTAIN` 后，这些根身份检查会全部跳过。

独立反例构造了一个完全由调用方生成的 bundle：

- current/prior 来源分别为 `news-v2` 与 `cache-v1`；
- `evidence_scope="unverified"`；
- 无任何 A2 proof 或受控 store 身份；
- 段落、正文 SHA、research_note 与 bundle SHA 均由调用方现场生成并保持内部自洽；
- ex-ante 为历史回放模板，ex-post 为 `ABSTAIN`。

当前结果：

```json
{
  "trust": {"ok": true, "violations": []},
  "validation": {"ok": true, "violations": []},
  "auto_source": {
    "current_source_ref": "news-v2",
    "prior_source_ref": "cache-v1"
  }
}
```

虽然它没有伪造 READY 决策事实，但仍能把伪造的正式原文身份、文本差异、事前监控情景与时间字段固化成“canonical auto draft”，随后允许人工签收。`ABSTAIN` 只能表示证据不足，不能把未经验证的数据源升级为可信自动稿基线。

现有测试仅覆盖“自洽伪 bundle + 伪 READY”，未覆盖“自洽伪 bundle + ABSTAIN”。

## 最小关闭

用于 `validateHumanRevision()` 的 bundle 无论 ex-post 是 READY 还是 ABSTAIN，都必须先建立来源根信任。最小方案二选一：

1. **严格正式基线**：current/prior 始终要求 A2 proof、document binding、正式 source refs 与受控 evidence scope；缺证一律 `auto_draft_baseline_untrusted`。
2. **允许非正式 ABSTAIN，但不得签收**：非正式/无 proof bundle 可以只读展示 ABSTAIN，却禁止进入 `validateHumanRevision` 和 canonical auto-draft 冻结流程，显式返回 `untrusted_abstain_bundle_not_revisable`。

补原样反例：自洽 news/cache bundle、无 proof、`ex_post=ABSTAIN`、replay 与 canonical SHA 均一致，仍必须拒绝人工修订。

## 裁决边界

- 只关闭上述 ABSTAIN 根信任绕过；不重开已通过三组 P1；
- 不扩展 Batch D、不接新网络、不写正式数据；
- 关闭前不得声明 `POLICY_INFERENCE_TRACEABILITY_C1` 或 `EVENT_POLICY_INTELLIGENCE_V1`。

# C1 R16 P1-3 bundle 根信任聚焦复审

复审目标业务 tip：`71b9440`。本轮只复审 Codex R15 的 P1-3（bundle 根信任）关闭、五子机制回归与 `C_DATA_PROTECTION`，不扩展 Batch D。

## 验证概况

- C1 Gate1/Gate2/Gate3/Gate4/P1 专项：`47 + 32 + 32 + 38 + 51 = 200` 项全部通过；
- A1 `106/106`、A2 `152/152`、A4 `25/25`、B1 `136/136` 全部通过；本次复跑合计 **619 项通过**；
- C1/A2/B1 数据保护检查保持通过，正式 `data/` 未发生写入。

## P1-3 关闭路径（请聚焦复审）

基线：Codex R15 聚焦复审判 **P1-3 STILL BLOCKED**——`validateHumanRevision()` 把调用方传入的任意 `bundle` 交给 `evidenceDraftFromBundle()` 重新派生 canonical 基线，未建立根信任（未复算 `bundle_sha256`、未验 A2 proof、未证明来自受控 store、未校验 status/evidence_scope/正文身份）。

本轮 Cursor 在派生基线前新增 `verifyBundleTrust(bundle, opts)` 六组检查（路线 A：内存验证，零 fs；不走"从受控 store 内部加载"路线 B，保持 `fomc_evidence_draft.js` 纯函数、bundle 契约与 data/ 零变化）：

- **检查 A 根哈希**：`canonicalBundleSha256(bundle) === bundle.bundle_sha256`，不一致 → `bundle_root_hash_mismatch`；
- **检查 B 文档身份+正文 hash**：current/prior `text_sha256` 与段落重新派生正文 hash 一致；current event_id 绑定 bundle event_id（prior 是上一场会议，按设计不同）；缺失/篡改 → `current_document_required`/`prior_document_required`/`current_document_hash_tampered`/`prior_document_hash_tampered`/`current_document_wrong_event`；
- **检查 C（仅 ex_post READY）**：current/prior `source_ref` 必须存在且为官方域（`isTrustedOfficialDomain` allowlist），否则 `current_source_ref_missing`/`prior_source_ref_missing`/`source_ref_not_official`；
- **检查 D**：事前冻结声明不可信（本环无受控持久化冻结层），`ex_ante_freeze_claim_untrusted`；
- **检查 E（仅 ex_post READY）**：`evidence_scope === "official"`，current/prior 文档必须携带 A2 `verified_provenance + proof` 且经固定 Ed25519 公钥验签 + 绑定 `text_sha256`/`event_id`，否则 `evidence_scope_not_official`/`current_a2_proof_required`/`prior_a2_proof_required`/`current_document_binding_mismatch`/`prior_document_binding_mismatch`/`fact_source_not_official`；
- **检查 F research_note replay**：从 bundle 自身段落/source_refs/text_changes/missing_fields/conflicts 重新派生 `buildResearchNote`，必须与存储 `research_note` 字节一致（`stableStringify` 比较），不一致 → `research_note_replay_mismatch`——关闭"自洽伪造 bundle + 重算 bundle_sha256"漏洞（无 A2 私钥的攻击者无法伪造与真实段落一致的 READY research_note）；
- 任一验证缺失/失败 → `auto_draft_baseline_untrusted`，不进入人工修订比较。

新增导出：`verifyBundleTrust`、`canonicalBundleSha256`。循环依赖约束下 `fomc_evidence_draft.js` 不 require `fomc_document_bundle.js`，本地镜像 `FIXED_OFFICIAL_DOMAINS`/`normalizeDomain`/`isTrustedOfficialDomain`/`canonicalBundleSha256`/`localDocIsVerified`（基于 `documentProvenanceFields` + `verifyVerifiedProof` + `VERIFIED_ADAPTER_ID`）。

## 负向用例（请独立复现）

- `P1-3_fake_bundle_root_untrusted`：`bundle_sha256="attacker-bundle"` + news/cache source refs + 伪造 ex_ante READY/pre_event_frozen + 伪造 ex_post READY/HOLD official fact_source + 无 A2 proof → `auto_draft_baseline_untrusted` + `bundle_root_hash_mismatch` + `source_ref_not_official` + `ex_ante_freeze_claim_untrusted` + `current_a2_proof_required` + `research_note_replay_mismatch`；
- `P1-3_self_consistent_fake_still_rejected`：克隆真实 bundle、仅伪造 ex_post READY、重算 bundle_sha256、无 proofs → `current_a2_proof_required`（检查 A/F 自洽也过不了检查 E）；
- `P1-3_genuine_requires_proof`：真实 bundle 但调用方不提供已验证文档 → fail-closed `current_a2_proof_required`；
- `P1-3_replay_tampered_rejected`：真实 bundle + 已验证文档 + 篡改 decision_facts + 重算 bundle_sha256 → `research_note_replay_mismatch`；
- `P1-3_trusted_bundle_compliant_ok`：A2 testkit `makeGenuineBundle` 真证路径 → ok。

## 裁决边界

- **MEDIUM 耦合说明（有意选择）**：READY 路径要求调用方提供 A2 签名文档（`verifiedCurrent`/`verifiedPrior`），这些文档**无法从 bundle 本身恢复**（bundle 文档不携带 `verified_provenance/proof`）。这是预期的 fail-closed 设计——对应 Codex R15 裁决"从受控 store 内部加载"的路线 A 内存等价：真正根信任仍在 A1/A2 store 校验，`validateHumanRevision` 只接受调用方把已验证文档与 bundle 一并呈交，缺证 → 拒。正式接线时由 A2 受控 store 供档，不暴露裸 bundle 路径。
- 维持五子机制与 `C_DATA_PROTECTION` 已通过部分；
- Cursor 只关闭 P1-3 的 bundle 根信任反例并补负向测试；
- 不接新外部网络、不扩展 Batch D；
- 此前不得声明 `POLICY_INFERENCE_TRACEABILITY_C1` 或 `EVENT_POLICY_INTELLIGENCE_V1`。

请就以上给出 **PASS / CHANGES_REQUIRED** 裁决；如 CHANGES_REQUIRED 需列可复现反例与最小关闭要求，不扩展 Batch C/D 之外的授权面。

## 6. Human 验收

当前：**`DONE`** — Human 于 2026-08-05 正式确认 **`POLICY_REAL_USE_D1`** 完成并验收，D1 关闭并转入归档。

- [x] 每日简报中的 FOMC 理由可理解；
- [x] 事前/事后入口符合预期；
- [x] 来源、事实、差异、反证和缺口足以支持人工判断；
- [x] 新官方版本出现后任务会重开；
- [x] 整体操作明显减少人工拼接。

`POLICY_REAL_USE_D1` **已确认**。**`EVENT_POLICY_INTELLIGENCE_V1` 已由 Human 声明（2026-08-05）**——六项 V4.2 子机制本轮全部复跑 PASS 且 Human 完成真实使用后正式收口。`RESEARCH_PASS`、`DATA_QUALITY_PASS`、`RELEASE_PASS` 仍**未声明**。

## 7. 回合历史

### R0 · A1 PASS 与 Human A2 授权

- A1 业务 tip `b1abce5`，Codex PASS 交接提交 `0955b26`；
- Human 明确授权开启 A2，并对 8013、外部网络只读、正式 data 写入、后台调度四项全部授权；
- A2 计划与 A1 归档提交 `e56f54a`；
- 新环 `PRD-EVENT-POLICY-15-A2` 开始于 `pending_exec / cursor`；
- 未声明 `POLICY_SOURCE_ACQUISITION_A2` 或 `EVENT_POLICY_INTELLIGENCE_V1`。

### R1 → R2 · Cursor claim rev0→1 → transition rev1→2 四门执行与交接

- **claim rev0→1**：Cursor 取得租约（lease_owner/lease_actor=cursor），按 Gate 顺序执行四门，未跨门推进；
- 交付：`lib/fomc_official_source.js`（Gate 1 隔离获取）、`lib/fomc_document_store.js`（Gate 2 受控存储）、`lib/fomc_a2_api.js` + `local_server.js` 接线（Gate 3）、`scripts/fomc_a2_refresh.js` + `scripts/fomc_a2_schedule.ps1`（Gate 4 后台刷新）；
- **transition rev1→2**：释放租约，置 `pending_review / codex`；验收报告 `logs/acceptance/PRD-EVENT-POLICY-15-A2/`；
- 证据：六子机制 **108 PASS / 0 FAIL**；Gate 4 全量（真实 Task Scheduler）**31 PASS / 0 FAIL**；回归 A1 106 / A4 25；正式 `data/` 178 文件树 hash `f055a2db…fe104` 零变化；
- 未声明 `POLICY_SOURCE_ACQUISITION_A2` 或 `EVENT_POLICY_INTELLIGENCE_V1`。

### R2 · Codex 聚焦复核 `CHANGES_REQUIRED`

- 复核 tip `8a17bfd`；既有 A1 106/106、A2 108/108 通过，但四组未覆盖反例成立；
- 阻断：official provenance 可伪造、API/调度未共享文件锁、请求体错误 fail-open、单次刷新产生双 job_id 与遗留 running；
- 板切回 `pending_exec / cursor`；四组 P1 关闭前不得声明 A2 验收或进入 Batch B。

### R3 · Cursor rev4 关闭 Codex R2 四组 P1 → 置 `pending_review / codex`

- 关闭 P1-1（能力边界 + 独立复算绑定）、P1-2（共享跨进程互斥）、P1-3（请求体 fail-closed + evaluated_at 服务端产生）、P1-4（单一 job_id 生命周期）；
- 新增共享离线 testkit `scripts/fomc_a2_testkit.js`；A2 冒烟扩到 7 机制 141 断言（`A2_P1_R4` = 33 反例 + 加固）；
- 回归：A1 **106/106**、A2 **141/141**、A4 **25/25**；正式 `data/` 178 文件树 hash `f055a2db…fe104` 零变化；`FAS-FOMC-A2-Refresh` 只读核对 `ABSENT`；
- 释放租约，置 `pending_review / codex`（turn 0→1），交 Codex 聚焦复审；
- 未声明 `POLICY_SOURCE_ACQUISITION_A2` 或 `EVENT_POLICY_INTELLIGENCE_V1`。

### R4 · Codex 聚焦复审 `CHANGES_REQUIRED`

- P1-2 共享锁、P1-3 HTTP fail-closed、P1-4 单一 job_id 已通过；
- P1-1 仍阻断：生产模块公开真实 `VERIFIED_CAPABILITY` 与 `issueVerifiedProof()`，A1 synthetic fixture 可被普通模块自签为 official 并成功写入；
- 板切回 `pending_exec / cursor`；只允许关闭此一项，不扩展 Batch B/C/D。

### R5 · Cursor rev6 关闭 R4 剩余 P1-1 → 置 `pending_review / codex`

- 关闭 P1-1：Ed25519 公钥验签（`fomc_capability` 不再导出 capability/issuer，`claimProofSigner` 一次性领取、私钥不出闭包；`fomc_document_bundle` 不再再导出 capability，`buildFomcDocumentBundle(input)` 内部公钥验签）；store 独立兜底（`is_synthetic` 拒绝 + `published_at <= captured_at = fetched_at <= evaluated_at` 绑定）；签发仅存于适配器受控路径，testkit 经注入官方 HTML 走正式 fetch 面产出 genuine 证据，生产路径不接受注入 fetch；
- 新增 `p1_1_*` 14 项反例直接枚举生产导出面 + A1 fixture（含翻转 `is_synthetic:false`）经全部公开 API 不能 official/write；
- 回归：A1 **106/106**、A2 **150/150**（`A2_P1_R4` = 42）、A4 **25/25**；正式 `data/` 178 文件树 hash `f055a2db…fe104` 零变化；`FAS-FOMC-A2-Refresh` 只读核对 `ABSENT`；
- 释放租约，置 `pending_review / codex`（turn 1→2），交 Codex 聚焦复审（rev6 目标见 §5）；
- 未声明 `POLICY_SOURCE_ACQUISITION_A2` 或 `EVENT_POLICY_INTELLIGENCE_V1`。

### R6 → R7 · Codex 聚焦复审 `CHANGES_REQUIRED`

- 复核 tip `9ad2f92`：A1 106/106、A2 150/150、A4 25/25 保持通过，共享锁 / HTTP fail-closed / 单一 job_id 三组修复保持；正式 `data/` 未写入；
- 仍阻断 P1-1 能力边界，两反例独立复现：① 生产导出面 `claimProofSigner()` 仍可先领取真实签发器并使适配器加载失败；② `FAS_FOMC_TEST_FETCH + opts.fetch` 可把伪造正文签成 official READY；
- 板切回 `pending_exec / cursor`（revision 8）；只允许关闭这两项（R7 最小关闭要求），不扩展 Batch B/C/D。

### R7 · Cursor rev7 关闭 R7 两反例 → 置 `pending_review / codex`

- 关闭两反例：`fomc_capability` 导出面彻底移除 `claimProofSigner`/`issueVerifiedProof`/`VERIFIED_CAPABILITY`，仅公开固定 Ed25519 公钥 + `verifyVerifiedProof`，模块源码不含私钥材料；私钥只内嵌 `fomc_official_source` 闭包，任意导入顺序不能取得签发器、不能使适配器加载失败；生产 `httpGet`/`fetchFomcStatement` 移除 `FAS_FOMC_TEST_FETCH + opts.fetch` 旁路，离线确定性测试改用测试专用 https 桩（`withFakeHttps`，`finally` 恢复进程级状态）驱动真实适配器；
- 新增两个独立子进程负向测试（枚举导出面无签发器且适配器正常加载 / 设置环境变量并传入伪造 fetch 仍不能签名 official）；A2 扩到 **152** 断言（`A2_P1_R4` = 44）；
- 回归：A1 **106/106**、A2 **152/152**、A4 **25/25**；正式 `data/` 178 文件树 hash `f055a2db…fe104` 零变化；`FAS-FOMC-A2-Refresh` 只读核对 `ABSENT`；
- 释放租约，置 `pending_review / codex`（revision 9），交 Codex 最终聚焦复审（rev7 目标见 §5）；
- 未声明 `POLICY_SOURCE_ACQUISITION_A2` 或 `EVENT_POLICY_INTELLIGENCE_V1`。

### R8 · A2 关闭 + Human 确认 + B1 开启（2026-08-02）

- Codex R10 最终聚焦复审 **PASS**（`codex_r10_final_review.md`，复审 tip `50b88aa`）：R7 两反例关闭可确认；交接板转 `done / human`（revision 11 / turn 2）；
- Human（2026-08-02）正式确认 **`POLICY_SOURCE_ACQUISITION_A2`** 完成并验收（`acceptance_report.md` 置 `accepted_human` / `acceptance_declared: true`）；
- A2 归档 `docs/ai-collab/闭环归档/V4.2_A2_FOMC正式来源适配与后台刷新_PASS_2026-08-02.md`（业务 tip `50b88aa`）；
- Human 授权另开 **Batch B 新环 `PRD-EVENT-POLICY-15-B1`**（确定性文本差异与政策事实），交接板 revision 11 → 12，置 `pending_exec / cursor`（turn 0）；
- 未声明 `EVENT_POLICY_INTELLIGENCE_V1`、`RESEARCH_PASS`、`DATA_QUALITY_PASS` 或 `RELEASE_PASS`。

### R9 · Cursor B1 四门执行与交接 → 置 `pending_review / codex`

- 开环基线 `50b88aa`（A2 业务 tip）；Cursor 按 Gate 1-4 顺序执行四门（TDD RED→GREEN），未跨门推进；
- 交付：`lib/fomc_text_diff.js`（Gate 1 逐段差异引擎 + Gate 3 主题定位）、`lib/fomc_decision_facts.js`（Gate 2 决策事实提取）、Gate 4 解释边界与数据保护（`interpretation_status` 三态 + `derived_decision_facts` 兄弟字段，透传语义不变）；
- 五子机制 **109 PASS / 0 FAIL**（Gate1 57 + Gate2 24 + Gate3 14 + Gate4 14）；回归 A1 **106/106**、A2 **152/152**、A4 **25/25**；正式 `data/` 178 文件树 hash `f055a2db…fe104` 零变化；
- transition rev13→14：释放租约，置 `pending_review / codex`，交 Codex 聚焦 R2；
- 未声明 `EVENT_POLICY_INTELLIGENCE_V1`、`POLICY_TEXT_DIFF_B1` 或任何研究/数据质量/发布验收名。

### R10 · Cursor claim rev16→17 关闭 Codex R2 四组 P1 → 置 `pending_review / codex`（2026-08-02）

- Codex R2 聚焦复审 **CHANGES_REQUIRED**（复审 tip `e2b496f`），四组 P1：P1-1 SHA 独立复算、P1-2 决策事实单段匹配/动作收紧/证据身份、P1-3 主题词/短语边界 + MODIFIED 双侧证据 + 多主题、P1-4 板 HEAD/code_tip 绑定业务 tip + 交接前检查；
- Cursor claim rev16→17（lease `cursor-b1-r2-p1`）后按最小关闭面执行，业务 tip `2d18ab6`：
  - P1-1：`normEntry()` 独立复算 SHA，输入 SHA 校验不一致置 `sha_mismatch` + warning + 排除于 UNCHANGED 对齐；
  - P1-2：各事实单段匹配 + 动作仅委员会决定句式 + 证据身份缺失/不一致 → ABSTAIN + 区间有限数/lower<=upper/0..20% 校验；
  - P1-3：词/短语边界关键词 + MODIFIED 审视 prior+current 双侧记录 `topic_evidence` 来源侧 + `topics[]` 多主题保留；
  - P1-4：`deriveOpeningBaseline` + `pendingReviewOpeningBaselineViolation` 接入 `validateContent`，禁止 `pending_review` 指向开环基线；
- 五冒烟 **136 PASS / 0 FAIL**（Gate1 64 + Gate2 33 + Gate3 20 + Gate4 14 + P14 5）；回归 A1 **106/106**、A2 **152/152**、A4 **25/25**；正式 `data/` 178 文件树 hash `f055a2db…fe104` 零变化；
- 板 §2 HEAD 更新为 `2d18ab6`、`sync-pointer` 绑定 `code_tip=2d18ab6`（P1-4 关闭）；transition rev17→18：释放租约，置 `pending_review / codex`，交 Codex 聚焦复审；
- 未声明 `EVENT_POLICY_INTELLIGENCE_V1`、`POLICY_TEXT_DIFF_B1` 或任何研究/数据质量/发布验收名。

### R11 · Codex R2 聚焦复审 PASS + Human 确认 + B1 归档（2026-08-02）

- Codex R2 聚焦复审 **PASS**（`codex_r2_final_review.md`，复审 tip `2d18ab6`）：SHA 独立复算 / 政策事实不伪造 / 主题定位 / 板绑定业务 tip 四组 P1 独立复核全部通过；交接板 rev18→20 转 `done / human`；
- Human（2026-08-02）正式确认 **`POLICY_TEXT_DIFF_B1`** 完成并验收（`acceptance_report.md` 置 `accepted_human` / `acceptance_declared: true`）；
- B1 归档 `docs/ai-collab/闭环归档/V4.2_B1_确定性文本差异与政策事实_PASS_2026-08-02.md`（业务 tip `2d18ab6`，治理 tip `eeed106`）；
- 业务仓 `eeed106` / Obsidian `63f1b33` 双仓 clean、交接板镜像字节一致；是否另开后续 Batch 由 Human 决定；
- 未声明 `EVENT_POLICY_INTELLIGENCE_V1`、`RESEARCH_PASS`、`DATA_QUALITY_PASS` 或 `RELEASE_PASS`。

### R12 · Human 授权开启 Batch C 新环 `PRD-EVENT-POLICY-15-C1`（2026-08-02）

- B1 已完整关闭并归档（Codex R2 聚焦复审 **PASS** → `done / human` → Human 2026-08-02 正式确认 `POLICY_TEXT_DIFF_B1`）；
- Human 授权另开 **Batch C 新环 `PRD-EVENT-POLICY-15-C1`**（证据约束草稿），验收名 **`POLICY_INFERENCE_TRACEABILITY_C1`**，单一环覆盖 Batch C 全量；
- C1 计划 `docs/ai-collab/产品发展执行计划_V4.2_C_证据约束草稿_2026-08-02.md`；开环基线 `2d18ab6`（B1 业务 tip）；交接板 revision 20 → 21，置 `pending_exec / cursor`（turn 0）；
- 未声明 `EVENT_POLICY_INTELLIGENCE_V1`、`POLICY_INFERENCE_TRACEABILITY_C1`、`RESEARCH_PASS`、`DATA_QUALITY_PASS` 或 `RELEASE_PASS`。

### R13 · Cursor C1 四门执行与交接 → 置 `pending_review / codex`（2026-08-02）

- 开环基线 `2d18ab6`（B1 业务 tip）；Cursor claim rev22（lease `cursor-c1-r1`）后按 Gate 1-4 顺序执行四门（TDD RED→GREEN），未跨门推进；
- 交付：`lib/fomc_evidence_draft.js`（Gate 1 `buildExAntePlan` / Gate 2 `anchorExPost` / Gate 3 `factsOnlyView` + `factSourceGuard` / Gate 4 `evidenceDraftFromBundle` + `validateHumanRevision` + `assertNoForbiddenInferenceFields`，method_version `c1-evidence-draft-v1`）；`lib/fomc_document_bundle.js` 契约内新增派生字段 `research_note`（`ex_ante` 事前冻结 / `ex_post` 事后锚定），`bundle_sha256` 幂等与 A1/A2/B1 透传语义不变；
- 四门 **99 PASS / 0 FAIL**（Gate1 39 + Gate2 21 + Gate3 20 + Gate4 19）；回归 A1 **106/106**、A2 **152/152**、A4 **25/25**、B1 **136/136**；正式 `data/` 178 文件树 hash `f055a2db…fe104` 零变化；
- 板 §2 HEAD 更新为 `71b1dbc`、`sync-pointer` 绑定 `code_tip=71b1dbc`；transition rev22→23：释放租约，置 `pending_review / codex`（turn 0→1），交 Codex 聚焦 R2（rev23 目标见 §5）；
- 未声明 `EVENT_POLICY_INTELLIGENCE_V1`、`POLICY_INFERENCE_TRACEABILITY_C1` 或任何研究/数据质量/发布验收名。

### R20 · Codex R19 PASS + Human 正式确认 C1 + 归档（2026-08-03）

- Codex R19 最终聚焦复审 **PASS**（`codex_r19_final_focused_review.md`，业务 tip `50bfdab`）：R18 的来源 URL、正式时间和时间单调性 P1 已关闭；独立反例与真实正例均符合 fail-closed 预期；
- C1 Gate1/Gate2/Gate3/Gate4/P1 **213 PASS / 0 FAIL**；A1/A2/A4/B1 回归 **419 PASS / 0 FAIL**；合计 **632 PASS / 0 FAIL**；正式 `data/` 178 文件树哈希前后一致；
- Human（2026-08-03）正式确认 **`POLICY_INFERENCE_TRACEABILITY_C1`** 完成并验收；计划置 `accepted` / `acceptance_declared: true`，验收报告置 `accepted_human`；
- C1 归档 `docs/ai-collab/闭环归档/V4.2_C1_证据约束草稿_PASS_2026-08-03.md`；
- 声明边界：未声明 `EVENT_POLICY_INTELLIGENCE_V1`、`RESEARCH_PASS`、`DATA_QUALITY_PASS` 或 `RELEASE_PASS`；Batch D **未开启**，后续须 Human 另行授权并新开环。

### R14 · Cursor claim rev25→26 关闭 Codex R2 四组 P1 → 置 `pending_review / codex`（2026-08-03）

- Codex R2 复审（`06dd172`，`codex_r2_review.md`）判 **CHANGES_REQUIRED**，四组 P1：事前冻结可事后冒充、事实源守卫未接入锚定、人工修订校验漏核心绑定字段、推断语义不可证伪且边界可绕过；
- Cursor claim rev25→26（lease `cursor-c1-r2-p1`）逐项关闭：P1-1 `buildExAntePlan` 绑定 `generated_at < current.published_at` + `freezeHash` + `method_version`，事后生成/时间异常/无快照 → ABSTAIN，无冻结 → `RETROSPECTIVE_EX_ANTE_TEMPLATE`；P1-2 `factSourceGuard` allowlist + `anchorExPost` 接入 provenance + `buildResearchNote` canonical 重算 text_changes；P1-3 `meta.freeze_sha256` 自动域冻结指纹 + 拒绝伪 autoDraft 基线（`auto_draft_freeze_missing`/`auto_draft_tampered`）+ 完整 meta/source/ex_ante/ex_post 冻结；P1-4 SCENARIO vs HYPOTHESIS 语义 + 值级禁止扫描 + 词边界 stabilityMarkers + 空反证显式 gap；
- 交付：`lib/fomc_evidence_draft.js`（四组 P1 关闭）、`lib/fomc_document_bundle.js`（research_note 接线 factSource provenance）、`scripts/smoke_v42_fomc_c1_gate{1,2,3,4}.js`（语义更新）、新增 `scripts/smoke_v42_fomc_c1_p1_r14.js`（P1 专项反例）；
- P1 专项 **40 PASS / 0 FAIL**；四门 **49/33/28/30 PASS**；回归 A1 **106/106**、A2 **PASS**、A4 **25/25**、B1 **136/136**；正式 `data/` 178 文件树 hash `f055a2db…fe104` 零变化；
- 板 §2 HEAD 更新为 `57d6aab`、`sync-pointer` 绑定 `code_tip=57d6aab`；transition rev26→27：释放租约，置 `pending_review / codex`，交 Codex 聚焦复审四组 P1（rev27 目标见 §5）；
- 未声明 `EVENT_POLICY_INTELLIGENCE_V1`、`POLICY_INFERENCE_TRACEABILITY_C1` 或任何研究/数据质量/发布验收名。

### R15 · Cursor claim rev30 关闭 Codex R14 四组 P1 → 置 `pending_review / codex`（2026-08-03）

- Codex R14 聚焦复审（`dec1be9`，`codex_r14_p1_focused_review.md`）判 **CHANGES_REQUIRED**：四组 P1 均根因于“调用方自报信息被当作不可伪造权威绑定”；
- Cursor claim rev29→30（lease `cursor-c1-r2-p1`）按 R14 最小关闭要求逐项关闭：P1-1 `buildExAntePlan` 完全取消 READY/pre_event_frozen（本环无受控持久化冻结层 → 有 prior 一律 `RETROSPECTIVE_EX_ANTE_TEMPLATE`、无 prior → `ABSTAIN`，自报 `freezeHash`/`generatedAt` → `freeze_claim_rejected`，移除 EX_ANTE_READY/computeExAnteFreezeSha256/freeze）；P1-2 `anchorExPost` 只消费 A2 `verifiedDocument`（Ed25519 验签 + 当前段落绑定 proof.document_hash + source_ref 派生自证明身份），无 proof → ABSTAIN，调用方自报 {kind,verified,source_ref} 不再是权威；P1-3 `validateHumanRevision` 从可信 bundle 重新派生 canonical 自动稿（缺 bundle → `auto_draft_baseline_required`，伪 autoDraft/自签冻结指纹 → `auto_draft_baseline_mismatch`）；P1-4 数组内字符串值级扫描 + HYPOTHESIS trim/元素类型/证据定位 + SCENARIO 空反证 gap 标记精确相等（生成器与校验器单一语义真相源）；
- 交付：`lib/fomc_evidence_draft.js`（四组 P1 关闭）、`lib/fomc_document_bundle.js`（`buildResearchNote` 接线 `verifiedDocument: verified ? current : null`）、`scripts/smoke_v42_fomc_c1_gate{1,2,3,4}.js`（语义更新）、`scripts/smoke_v42_fomc_c1_p1_r14.js`（P1 专项反例重写）；
- C1 四门 + P1 专项 **47/32/32/38 + 40 = 189 PASS**；A1 **106/106**、A2 **PASS**（121 断言）+ walkthrough **37**、A4 **25/25**、B1 **136/136**（64+33+20+14+5）；正式 `data/` 178 文件树 hash `f055a2db…fe104` 零变化；`bundle_sha256` 幂等；
- 板 §2 HEAD 更新为 `7d6b692`、`sync-pointer` 绑定 `code_tip=7d6b692`；transition rev30→31：释放租约，置 `pending_review / codex`，交 Codex 聚焦复审四组 P1（rev31 目标见 §5）；
- 未声明 `EVENT_POLICY_INTELLIGENCE_V1`、`POLICY_INFERENCE_TRACEABILITY_C1` 或任何研究/数据质量/发布验收名。

### R16 · Cursor claim rev33 关闭 Codex R15 P1-3 → 置 `pending_review / codex`（2026-08-03）

- Codex R15 聚焦复审（`d510636`，`codex_r15_p1_3_focused_review.md`）判 **P1-3 STILL BLOCKED**：`validateHumanRevision` 把调用方传入的任意 `bundle` 交给 `evidenceDraftFromBundle` 重新派生 canonical 基线，未建立根信任（未复算 `bundle_sha256`、未验 A2 proof、未证明来自受控 store、未校验 status/evidence_scope/正文身份）；
- Cursor claim rev32→33（lease `cursor-c1-r2-p1`）按 R15 最小关闭要求关闭 P1-3：派生基线前先执行 `verifyBundleTrust(bundle, opts)` 六组检查（路线 A 内存验证，零 fs）——检查 A 根哈希 `canonicalBundleSha256(bundle) === bundle.bundle_sha256`（`bundle_root_hash_mismatch`）；检查 B 文档身份+正文 hash + current event_id 绑定（`*_document_required`/`*_document_hash_tampered`/`current_document_wrong_event`）；检查 C 仅 ex_post READY 时 current/prior source_ref 必须官方域（`source_ref_not_official`）；检查 D 事前冻结声明不可信（`ex_ante_freeze_claim_untrusted`）；检查 E 仅 ex_post READY 时 A2 proof 验签 + document binding（`current_a2_proof_required`/`prior_a2_proof_required`/`*_document_binding_mismatch`/`fact_source_not_official`/`evidence_scope_not_official`）；检查 F research_note replay（`research_note_replay_mismatch`）关闭“自洽伪造 bundle + 重算 bundle_sha256”漏洞；任一失败 → `auto_draft_baseline_untrusted`；
- 交付：`lib/fomc_evidence_draft.js`（verifyBundleTrust 六组检查 + validateHumanRevision 0a 接入 + 导出 `verifyBundleTrust`/`canonicalBundleSha256`；循环依赖约束下本地镜像 `FIXED_OFFICIAL_DOMAINS`/`normalizeDomain`/`isTrustedOfficialDomain`/`canonicalBundleSha256`/`localDocIsVerified`）、`scripts/smoke_v42_fomc_c1_p1_r14.js`（P1-3 负向测试扩展 11 断言）；
- C1 四门 + P1 专项 **47/32/32/38 + 51 = 200 PASS**；A1 **106/106**、A2 **PASS**（152 断言）+ walkthrough **37**、A4 **25/25**、B1 **136/136**（64+33+20+14+5）；合计 **619 PASS / 0 FAIL**；正式 `data/` 178 文件树 hash `f055a2db…fe104` 零变化；`bundle_sha256` 幂等；
- 板 §2 HEAD 更新为 `71b9440`、`sync-pointer` 绑定 `code_tip=71b9440`；transition rev33→34：释放租约，置 `pending_review / codex`，交 Codex 聚焦复审 P1-3（rev34 目标见 §5）；
- 未声明 `EVENT_POLICY_INTELLIGENCE_V1`、`POLICY_INFERENCE_TRACEABILITY_C1` 或任何研究/数据质量/发布验收名。

### R17 · Cursor 关闭 Codex R16 ABSTAIN 根信任绕过 → 置 `pending_review / codex`（2026-08-03）

- Codex R16 聚焦复审（`71b9440`，`codex_r16_p1_3_focused_review.md`）判 **CHANGES_REQUIRED**：P1-3 的 READY 路径已加固，但 ABSTAIN 路径仍允许调用方自造 bundle 根信任——`verifyBundleTrust` 把 source allowlist、A2 proof、`evidence_scope=official` 与 fact-source 权威校验全部放在 `ex_post.status === "READY"` 条件之下，伪 bundle 设 ABSTAIN 后根身份检查全部跳过，仍可固化 canonical auto draft 并允许人工签收；
- Human（2026-08-03）指令：**无论 READY 还是 ABSTAIN，进入人工修订前都必须有可信来源证明；或者允许不可信 ABSTAIN 只读展示，但禁止签收和冻结**。经确认选定 **一律要求可信来源**（Codex R16 最小关闭方案 1 · 严格正式基线）；
- Cursor 按最小关闭面执行，业务 tip `02fbcb8`：`verifyBundleTrust` 检查 C（source_refs 官方非合成）与检查 E（`evidence_scope=official` + A2 proof 验签 + document binding）改为**恒跑**；`fact_source` 权威校验拆为检查 E2，仅 READY 声称时要求（ABSTAIN 无决定句式，fact_source 不承载权威）；检查 A/B/D/F 保持恒跑；未验证 bundle → `validateHumanRevision` 一律 `auto_draft_baseline_untrusted`；`factsOnlyView` 只读展示仍可用（Gate 3 不受影响）；
- 交付：`lib/fomc_evidence_draft.js`（C/E 恒跑 + E/E2 拆分 + 三处注释）、`scripts/smoke_v42_fomc_c1_p1_r14.js`（P1-3b 三断言：trusted ABSTAIN 真证路径 ok / untrusted ABSTAIN 拒绝 / bundle shape）、`scripts/smoke_v42_fomc_c1_gate4.js`（O 块改用 A2 真证 bundle 调 `validateHumanRevision` + 新增 `O0_synthetic_untrusted_rejected`）；
- P1 专项 **54/54 PASS**（51 + P1-3b 3）；Gate 4 **39/39 PASS**（38 + O0）；A1 **106/106**、A2 **PASS**、A4 **25/25**、B1 **136/136**（64+33+20+14+5）、C1 Gate1/Gate2/Gate3 **47/32/32 PASS**；正式 `data/` 178 文件树 hash `ae7447d3fb68b467fcde59fe4d2e24cabbb808063de0bbf82b7f200fd4e2818d` 零变化；`bundle_sha256` 幂等；
- 板 §2 HEAD 更新为 `02fbcb8`、`sync-pointer` 绑定 `code_tip=02fbcb8`；transition rev36→37：释放租约，置 `pending_review / codex`，交 Codex 聚焦复审 ABSTAIN 根信任（rev37 目标见 §5）；
- 未声明 `EVENT_POLICY_INTELLIGENCE_V1`、`POLICY_INFERENCE_TRACEABILITY_C1` 或任何研究/数据质量/发布验收名。

### R18 · Cursor claim rev40 关闭 Codex R17 来源身份绑定 → 置 `pending_review / codex`（2026-08-03）

- Codex R17 聚焦复审（`02fbcb8`，`codex_r17_p1_3_focused_review.md`）判 **CHANGES_REQUIRED**：R16 的"无证明 ABSTAIN 可签收"已关闭，但 `source_refs` 尚未与所提交的 A2 已验证文档身份绑定——调用方仍可保留真实 A2 文档与有效 proof，改写 bundle 的来源标识（删 `domain` 的 READY、伪造 `source_version` 的 ABSTAIN），重算 `research_note` 与 `bundle_sha256`，仍通过根信任与人工修订；根因：source ref 的 domain 为 truthy 才检查 allowlist、`documentBindsToBundle` 只比较 `text_sha256` 且 event_id 可选绑定，未绑定 `source_version/domain/url/captured_at`；
- Cursor claim rev39→40（lease `cursor-c1-r18-source-binding`）按 R17 最小关闭四项执行，业务 tip `b13a3ea`：
  - `documentBindsToBundle`：事件身份改为**必填且精确相等**（不再"双方都有才比较"）；
  - 新增 `sourceRefBindsToVerifiedDoc`：source_ref 与对应 A2 已验证文档逐项精确绑定（`event_id`/`text_sha256`/`source_version`/规范化 `domain`，bundle 冻结 URL/captured_at 亦一致），缺字段或不一致 → `current/prior_source_identity_mismatch`；
  - 检查 C 字段完整：`domain` 非空命中 allowlist（`source_ref_not_official`）、`synthetic===false`（`source_ref_synthetic`）、`source_version` 非空（`current/prior_source_version_required`）；
  - 检查 E 接来源身份绑定；任一失败 → `auto_draft_baseline_untrusted`；
- 交付：`lib/fomc_evidence_draft.js`（documentBindsToBundle 必填精确 + sourceRefBindsToVerifiedDoc 新增 + C 字段完整 + E 来源身份绑定）、`scripts/smoke_v42_fomc_c1_p1_r14.js`（P1-3c 四断言：真实 READY ok / 删 domain READY 拒绝 / 伪造 source_version ABSTAIN 拒绝（replay 自洽，无 research_note_replay_mismatch）/ shape）；
- P1 专项 **58/58 PASS**（54 + P1-3c 4）；Gate 4 **39/39 PASS**；A1 **106/106**、A2 **PASS**（152 断言）、A4 **25/25**、B1 **136/136**（64+33+20+14+5）、C1 Gate1/Gate2/Gate3 **47/32/32 PASS**；合计 **627 PASS / 0 FAIL**；正式 `data/` 178 文件树 hash `ae7447d3fb68b467fcde59fe4d2e24cabbb808063de0bbf82b7f200fd4e2818d` 零变化；`bundle_sha256` 幂等；
- 板 §2 HEAD 更新为 `b13a3ea`、`sync-pointer` 绑定 `code_tip=b13a3ea`；transition rev40→41：释放租约，置 `pending_review / codex`，交 Codex 聚焦复审来源身份绑定（rev41 目标见 §5）；
- 未声明 `EVENT_POLICY_INTELLIGENCE_V1`、`POLICY_INFERENCE_TRACEABILITY_C1` 或任何研究/数据质量/发布验收名。

### R19 · Cursor claim rev43 关闭 Codex R18 来源/正式时间绑定 → 置 `pending_review / codex`（2026-08-03）

- Codex R18 聚焦复审（`b13a3ea`，`codex_r18_p1_3_source_time_review.md`）判 **CHANGES_REQUIRED**：R17 的两个原样反例（缺 domain 的 READY、伪 source_version 的 ABSTAIN）已关闭，但 bundle 内最终冻结到自动稿的 URL 与正式时间仍未绑定到 A2 已验证文档——调用方可保留真实 proof 和正文，改写正式来源/时间后重算自签 canonical hash，并被允许人工签收；根因：`sourceRefBindsToVerifiedDoc` 对 URL/captured_at 用"存在才比较"可选检查、`documentBindsToBundle` 只绑定 `text_sha256 + event_id`、bundle 顶层 `published_at/source_version` 无绑定、`evaluated_at` 无时间合法性/单调性校验；
- Cursor claim rev43→44（lease `cursor-c1-r19-source-time`）按 R18 最小关闭四项执行，业务 tip `50bfdab`：
  - `documentBindsToBundle`：新增 `url`/`captured_at`/`synthetic` 必填精确绑定（`verified_provenance.final_url`/`source.url` 精确相等、`captured_at` 精确相等、`synthetic`/`is_synthetic` 必须 `false`）；
  - `sourceRefBindsToVerifiedDoc`：URL/captured_at 改为必填精确绑定，删除不再绕过；
  - 新增 `bundleTopLevelBindsToVerifiedCurrent`：bundle 顶层 `published_at`/`source_version` 与已验证 current document 必填精确绑定；
  - 新增 `validMonotonicTimes`：`evaluated_at >= captured_at >= published_at`；`toEpochMs` 本地复制避免循环依赖；
  - 检查 G（E2 之后）：`research_note` 存在时执行顶层绑定与时间单调校验，任一失败 → `auto_draft_baseline_untrusted`；
- 交付：`lib/fomc_evidence_draft.js`（documentBindsToBundle url/captured_at/synthetic + sourceRefBindsToVerifiedDoc 必填 + bundleTopLevelBindsToVerifiedCurrent + validMonotonicTimes + toEpochMs + 检查 G）、`scripts/smoke_v42_fomc_c1_p1_r14.js`（P1-3d 五断言：伪 captured_at / 伪 published_at / 删 URL+captured_at / 恶意 current url / evaluated_at 非单调，violation 集各仅命中对应绑定，replay 自洽）；
- P1 专项 **63/63 PASS**（58 + P1-3d 5）；Gate 1/Gate2/Gate3/Gate4 **47/32/32/39 PASS**；A1 **106/106**、A2 **PASS**（152 断言）、A4 **25/25**、B1 **136/136**（64+33+20+14+5）；合计 **632 PASS / 0 FAIL**；正式 `data/` 178 文件树 hash `ae7447d3fb68b467fcde59fe4d2e24cabbb808063de0bbf82b7f200fd4e2818d` 零变化；`bundle_sha256` 幂等；
- 板 §2 HEAD 更新为 `50bfdab`、`sync-pointer` 绑定 `code_tip=50bfdab`；transition rev44→45：释放租约，置 `pending_review / codex`，交 Codex 聚焦复审来源/正式时间绑定（rev45 目标见 §5）；
- 未声明 `EVENT_POLICY_INTELLIGENCE_V1`、`POLICY_INFERENCE_TRACEABILITY_C1` 或任何研究/数据质量/发布验收名。

### R21 · Cursor 关闭 Codex D1 R1 三组 P1 → 置 `pending_review / codex`（2026-08-05）

- Codex D1 R1 集中产品复审（rev54）判 **CHANGES_REQUIRED**，三组 P1：P1-1 `CENTRAL_BANK` 无条件识别为 FOMC、P1-2 证据端点未接入 A2 受控文档（smoke 把空 ABSTAIN 当 PASS）、P1-3 未验证来源可显示为「政策事实（正式）」；
- Cursor claim rev54→55 按最小关闭面执行三组 P1（不扩展事件/机制，不重开 A1/A2/B1/C1）：
  - P1-1：`isFomcEvent` 严格 Fed 身份（明确 `FOMC/FOMC_POLICY` 或 Fed/FOMC event_id + 美联储来源 + federalreserve.gov 域）；`makeBriefingItem` 透传 `source_url`；
  - P1-2：新增 `lib/v42_evidence_lookup.js`（`resolveEvidenceView`），证据端点读 A2 受控 store，无正式文档 → 诚实 ABSTAIN（`no_a2_formal_documents`）；新增 `scripts/seed_v42_d1_walkthrough.js` + `fixtures/v42_d1_walkthrough/` 隔离种子演示 verified 完整渲染；
  - P1-3：`buildV42EvidenceView` verified 门控 `official_facts`（仅 A2 proof/官方域/正文/hash/时间绑定），generic 降级 `unverified_facts`；面板正式/候选事实分区；
- 交付：`lib/briefing_intelligence_v4.js`、`lib/v42_evidence_view.js`、`lib/v42_evidence_lookup.js`（新增）、`local_server.js`、`static/v42_evidence_panel.js`、`scripts/smoke_v42_fomc_d1.js`（重写 73 断言）、`scripts/seed_v42_d1_walkthrough.js`（新增）、`scripts/walkthrough_v42_d1_p1_browser.js`（新增）、`fixtures/v42_d1_walkthrough/`（隔离种子）；
- 自检：D1 smoke **73/73 PASS**；浏览器走查 **35/35 PASS**（生产诚实 ABSTAIN + ECB 无 FOMC + 隔离种子 verified 完整渲染）；回归 A1 **106/106**、A2 **PASS**、B1 **64/64**、B1 gate2/3/4 **33/20/14**、C1 gate1/2/3/4 **47/32/32/39**、C1 p1_r14 **63/63**、v4_six_mechanisms **23**、v4_batch_d_walkthrough **83**、v41_earnings_d **21**、ai_collab_exec_pointer、acceptance_status 全绿；生产 `data/` 零写入；
- 板 §2 HEAD 更新为 `949b994`、`sync-pointer` 绑定 `code_tip=949b994`；transition rev54→55：释放租约，置 `pending_review / codex`，交 Codex 最终聚焦复审三组 P1（rev55 目标见 §5）；
- 未声明 `POLICY_REAL_USE_D1`、`EVENT_POLICY_INTELLIGENCE_V1`、`RESEARCH_PASS`、`DATA_QUALITY_PASS` 或 `RELEASE_PASS`。

### R22 · Cursor 关闭 Codex D1 R2 三个事实安全反例 → 置 `pending_review / codex`（2026-08-05）

- Codex D1 最终聚焦复审（rev58，复审目标 `949b994`）判 **CHANGES_REQUIRED**，三个事实安全反例：P1-1 官方域 host 判定可被 URL 路径伪装、P1-2 A2 错误分类全部降级为「无文档」、P1-3 正式 store 读取未重新验签且展示层自述即 verified；
- Cursor claim rev58→59 按最小关闭面执行三个反例（不扩展其他事件/机制，不重开 A1/A2/B1/C1）：
  - P1-1：`lib/briefing_intelligence_v4.js` 解析 URL hostname 精确匹配官方域白名单（path/query/subdomain 注入不再判 FOMC）；
  - P1-2：`lib/v42_evidence_lookup.js` 仅 `no_current_version`/`version_not_found`/`not_found` → 诚实 ABSTAIN，其余 fail-closed（store 不可用 503、损坏/悬空/验签失败 409 + 原始 reason/sub_error）；
  - P1-3：`lib/fomc_document_store.js` 新增 `verifyStoredRead`（读路径复用 `validateWriteInput` + current 指针/manifest↔document↔bundle 绑定，manifest 缺失/损坏 fail-closed）；`load()` 成功返回 `read_verified:true`；`lib/v42_evidence_view.js` `verified` 仅当显式 `read_verified` 信号（仅 store 读路径产生）；
- 交付：`lib/briefing_intelligence_v4.js`、`lib/fomc_document_store.js`、`lib/v42_evidence_lookup.js`、`lib/v42_evidence_view.js`、`local_server.js`、`scripts/seed_v42_d1_walkthrough.js`、`scripts/smoke_v42_fomc_d1.js`（97 断言：P1-1 四例、P1-2 三例、P1-3 磁盘篡改 15 例）；
- 自检：D1 smoke **97/97 PASS**；浏览器走查 **35/35 PASS**；回归 A1 **106/106**、A2 **PASS**、A4 **25/25**；生产 `data/fomc_documents` 零写入（复跑前后 git clean）；
- 板 §2 HEAD 更新为 `9db74dd`、`sync-pointer` 绑定 `code_tip=9db74dd`；transition rev58→59：释放租约，置 `pending_review / codex`，交 Codex 本环唯一一次最终聚焦复审（rev59 目标见 §5）；
- 未声明 `POLICY_REAL_USE_D1`、`EVENT_POLICY_INTELLIGENCE_V1`、`RESEARCH_PASS`、`DATA_QUALITY_PASS` 或 `RELEASE_PASS`。

### R23 · Codex 最终聚焦复审 `CHANGES_REQUIRED · HUMAN_DECISION`（2026-08-05，rev61）

- Codex 最终聚焦复审（rev59 目标 `9db74dd`）独立复跑：D1 smoke **97/97 PASS**、浏览器走查 **35/35 PASS**；P1-1 官方域 host 判定 **PASS**、P1-2 A2 错误分类 fail-closed **PASS**。
- P1-3 正式 store 读取重新验签 **CHANGES_REQUIRED**：`verifyStoredRead` 未把调用方请求/存储目录的 event_id 绑定到已验签文档身份——`eventId !== document.event_id` 未比较、`currentPointer.event_id` 未比较、`manifest.event_id` 仅存在才比较（缺失不阻断）。
- 独立反例：把已验证 `fomc_2026_07` 版本目录 + current 指针整体复制到临时 store 的 `fomc_2099_99` 目录（不改文档/proof/bundle/manifest 内容）→ `store_ok=true` / `read_verified=true` / `resolved_verified=true` / `official_facts=target_range 3.75%-4%, action HOLD`；一条合法已验签事件的事实可在错误事件 ID 下被展示为正式事实。
- 按 2026-08-05 审核预算，Codex 不再自动开技术循环，直接交 Human 决策（授权极小修复 / 接受风险登记技术债 / 缩小或停止）。

### R24 · Cursor rev62 极小修复关闭 P1-3 跨目录重放 → 直接交 Human 关闭 D1（2026-08-05）

- Human 授权路径 1（极小修复）：只增加请求/store/current/manifest/document 的 event_id 一致性检查 + 一个跨目录重放反例；修完运行定向测试后**直接交 Human 关闭 D1，不再进行新一轮 Codex 复审**。
- 修复（业务 tip `9d226a6`）：`lib/fomc_document_store.js` `verifyStoredRead` 补齐事件身份绑定——请求/store 目录 event_id 与 document.event_id 不一致 → 409 `read_event_id_mismatch`；current 指针 event_id 必需且与 document 一致 → `read_current_pointer_event_mismatch`；`manifest.event_id` 由「仅存在时比对」改为「必需且比对」→ `read_manifest_binding_field_missing` / `read_manifest_event_mismatch`。`loadA2Evidence`/`resolveEvidenceView` 无需改动：store.load 409 沿 fail-closed 传播。
- 反例（smoke 篡改 6：跨目录重放，`P3t_replay_*` 5 断言）：把已验证 `fomc_2026_07` 版本目录 + current 指针复制到 `fomc_2099_99` 事件目录（文件自洽、hash/proof 全真实）→ `store.load("fomc_2099_99")` = 409 `read_event_id_mismatch`、不授予 `read_verified`、产品路径非 2xx 阻断、不暴露 `official_facts`。
- 定向测试：D1 smoke **102/102 PASS**（97 + 5 重放断言）；回归 A1 **106/106**、A2 **PASS**（121）、A4 **25/25**；committed seed store 读路径回归 `read_verified=true`（合法 verified 读取不受影响）；生产 `data/fomc_documents` 零写入。
- 板 revision 61→62，`last_writer=cursor`，status 保持 `blocked`，`next_actor=human`——**直接交 Human 走查并关闭 D1，不再开启新 Codex 复审轮**。
- 未声明 `POLICY_REAL_USE_D1`、`EVENT_POLICY_INTELLIGENCE_V1`、`RESEARCH_PASS`、`DATA_QUALITY_PASS` 或 `RELEASE_PASS`。

### R25 · Human 验收 `POLICY_REAL_USE_D1` 并关闭 D1（2026-08-05，rev63）

- Human 于 2026-08-05 正式确认 **`POLICY_REAL_USE_D1`** 完成并验收：D1 smoke **102/102**、浏览器走查 **35/35**、A1 **106/106**、A2 **PASS**、A4 **25/25**、seed store 读路径 `read_verified:true`、生产 `data/fomc_documents` 零写入；P1-1/P1-2/P1-3 三个事实安全边界全部关闭。
- 交付：`logs/acceptance/PRD-EVENT-POLICY-15-D1/acceptance_report.md`（`accepted_human` / `acceptance_declared: true`）；计划置 `accepted` / `acceptance_declared: true` / `accepted_at: 2026-08-05`；归档 `docs/ai-collab/闭环归档/V4.2_D1_简报接线与真实使用_PASS_2026-08-05.md`。
- 板 revision 62→63，`status=done`，`next_actor=human`，`last_writer=cursor`——**D1 关闭，转入归档，不再继续技术验收循环**。
- 仅声明 `POLICY_REAL_USE_D1`；`EVENT_POLICY_INTELLIGENCE_V1`、`RESEARCH_PASS`、`DATA_QUALITY_PASS`、`RELEASE_PASS` 均未声明。是否继续 V4.2 其余扩展由 Human 另行决策并新开执行环。

### R26 · Human 声明 `EVENT_POLICY_INTELLIGENCE_V1` 并归档 V4.2（2026-08-05，rev64）

- Cursor 复跑 V4.2 六机制回归（Human 口令「继续」后）：A1 **106/0**、A4 **25/0**、A2 **PASS**（152）、B1 **136/0**（64+33+20+14+5）、C1 **213/0**（47+32+32+39+63）、D1 smoke **102/0**；生产 `data/fomc_documents` 零写入；双仓 clean；交接板镜像字节一致（91256 = 91256）。
- Human 基于六子机制全部 PASS 与真实使用确认（D1 `POLICY_REAL_USE_D1`，浏览器走查 35/35），正式声明 **`EVENT_POLICY_INTELLIGENCE_V1`**。
- 交付：V4.2 总体计划置 `accepted` / `acceptance_declared: true` / `accepted_at: 2026-08-05`；总体验收报告 `logs/acceptance/PRD-EVENT-POLICY-15/acceptance_report.md`；归档 `docs/ai-collab/闭环归档/V4.2_EVENT_POLICY_INTELLIGENCE_验收归档_2026-08-05.md`。
- 板 revision 63→64，`status=done`，`next_actor=human`——**V4.2 产品主线收口**。
- 已声明：`POLICY_REAL_USE_D1`、`EVENT_POLICY_INTELLIGENCE_V1`；未声明：`RESEARCH_PASS`、`DATA_QUALITY_PASS`、`RELEASE_PASS`。后续 V4.2 扩展由 Human 另行决策并新开执行环。

### R27 · Cursor rev65 极小修复（event_id 全链路一致性）→ 直接交 Human 验收归档（2026-08-05）

- Human 指令：`EVENT_POLICY_INTELLIGENCE_V1` 声明归档后做一次极小修复，增加 event_id 全链路一致性检查，定向验证后由 Human 直接验收并归档，**不再进行新一轮 Codex 复审**。
- 修复（业务 tip `ca7a0da`，仅 2 文件、+59/-5）：`validateWriteInput` 写侧拒绝目录键不稳定的 event_id → `write_rejected_event_id_not_stable`（防两个不同 event_id 塌缩到同一版本目录/跨事件版本历史污染）；`loadVersion` 原始读绑定请求 event_id → `load_version_event_id_mismatch`（跨目录重放比 rev62 `verifyStoredRead` 更早 fail-closed）；`load()` 直透该身份错误而非降格为 `current_pointer_dangling`。
- 反例（smoke 篡改 6 更新 + 新增篡改 7）：篡改 6 改为版本读回即截断并新增直接 `loadVersion` 反例（`P3t_replay_load_version_mismatch`）；篡改 7 不稳定 event_id（`fomc 2026:07` → `safeId` 改写为 `fomc_2026_07`）写侧拒绝且该目录键零写入（`P3t_unstable_event_id_*`）。
- 定向测试：D1 smoke **106/0**（rev62 102 + 4 新断言）；六机制回归 A1 **106/0**、A4 **25/0**、A2 **PASS**（152）、B1 **136/0**、C1 **213/0**；生产 `data/fomc_documents` 零写入；双仓 clean；交接板 validate `ok:true`。
- 交付：归档 `docs/ai-collab/闭环归档/V4.2_rev65_event_id_全链路一致性_极小修复_验收归档_2026-08-05.md`；总体验收报告 `logs/acceptance/PRD-EVENT-POLICY-15/acceptance_report.md` §6 增补 rev65 复验。
- 板 revision 64→65，`status=done`，`next_actor=human`——**交 Human 直接验收并归档，不再开启新 Codex 复审轮，V4.2 正式收尾**。
- 已声明：`POLICY_REAL_USE_D1`、`EVENT_POLICY_INTELLIGENCE_V1`；未声明：`RESEARCH_PASS`、`DATA_QUALITY_PASS`、`RELEASE_PASS`。
