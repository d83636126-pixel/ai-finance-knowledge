---
type: Cursor_Codex闭环交接板
schema_version: 2
tags: [AI协作, Cursor, Codex, V4.2, C1, FOMC]
created: 2026-08-01
updated: '2026-08-03'
project: financial-alert-system
loop_id: PRD-EVENT-POLICY-15-C1
acceptance: POLICY_INFERENCE_TRACEABILITY_C1
revision: 29
turn: 0
next_actor: 'cursor'
status: 'pending_exec'
max_turns: 3
last_writer: 'codex'
written_at: '2026-08-03T02:29:39.286Z'
lease_owner: ''
lease_actor: ''
lease_expires_at: ''
code_root: 'F:\financial-alert-system'
vault_note: AI协作记忆系统/Cursor_Codex_闭环交接板.md
repo_mirror: docs/ai-collab/Cursor_Codex_闭环交接板.md
---

# Cursor ↔ Codex 闭环交接板：V4.2 Batch C

> 当前口令：**执行Cursor_Codex闭环交接板当前指令 · V4.2 C1 证据约束草稿**

## 1. 当前裁决

- V4.2 A1（FOMC 文本证据契约）已 PASS 归档；V4.2 A2（正式来源适配与后台刷新）经 Codex R10 最终聚焦复审 **PASS**，交接板转 `done / human`（revision 11 / turn 2）。
- Human（2026-08-02）正式确认 **`POLICY_SOURCE_ACQUISITION_A2`** 完成并验收，并授权另开 **Batch B 新环**（确定性文本差异与政策事实）。
- **B1 环已关闭**：Codex R2 聚焦复审 **PASS**（`codex_r2_final_review.md`，复审 tip `2d18ab6`），交接板转 `done / human`（revision 20）；Human（2026-08-02）正式确认 **`POLICY_TEXT_DIFF_B1`** 完成并验收。
- Human（2026-08-02）授权另开 **Batch C 新环 `PRD-EVENT-POLICY-15-C1`**（证据约束草稿），验收名 **`POLICY_INFERENCE_TRACEABILITY_C1`**。
- 当前执行者：Cursor；完成 C1 交付后交 Codex 做一次聚焦 R2。
- 本环不做自动鹰鸽结论、不把文本变化直接压成市场因果、不接新外部网络、不改既有生产入口语义；不声明 `EVENT_POLICY_INTELLIGENCE_V1`。

## 2. 基线、授权与边界

| 项 | 值 |
|---|---|
| stage | `V4.2 C1 证据约束草稿` |
| C1 计划 | `docs/ai-collab/产品发展执行计划_V4.2_C_证据约束草稿_2026-08-02.md` |
| HEAD | `57d6aab`（C1 R14 P1 关闭业务 tip） |
| 开环基线 | `2d18ab6`（B1 业务 tip） |
| A1 / A2 / B1 业务 tip | `b1abce5` / `50b88aa` / `2d18ab6` |
| change class | `C2` |
| review | `R2`（聚焦） |
| status / next_actor | `pending_review / codex` |
| 授权范围 | 沿用 V4.2 主计划与 B1 已授权面；本环为证据约束草稿派生计算，无新外部网络/正式写入/后台调度需求 |
| 回滚 | 删除未接入正式入口的 C1 候选模块与 smoke，恢复到 `2d18ab6`；不迁移/删除正式产品数据 |

### 受保护不变量

1. 任何草稿推断必须带支持、反证、缺口和可证伪条件，并记录方法版本（`POLICY_INFERENCE_TRACEABILITY`）。
2. 禁止自动"鹰派/鸽派"结论；文本相似度/变化只用于定位，不直接压成市场因果。
3. 事实与差异在无模型时仍可显示；模型文本、新闻摘要、浏览器缓存不得成为权威事实源。
4. 自动稿与人工修订隔离；人工不得改正式原文/hash/时间/事前冻结版本；人工修订保留自动稿与差异。
5. 正式 `data/` 既有文件、V4.0/V4.1 语义、Top 3、研究信用和 AI 草稿策略保持不变；既有 bundle 版本不回写覆盖。
6. 任一正式门槛失败，总结论不得 PASS，失败必须可见。
7. `EVENT_POLICY_INTELLIGENCE_V1` 与本环隔离，本环不声明总验收。

## 3. Cursor 当前执行指令

### 3.1 业务目标

用户查看 FOMC 事件时，系统在 A1/A2/B1 差异/事实底座之上产出**证据约束草稿**：事前列出关注段落、可能变化、反证与弃权条件；事后锚定实际决定、相对上次的文本变化、来源与数据缺口；无模型时仍能显示事实与差异；自动稿与人工修订隔离。任何推断必须带支持、反证、缺口和可证伪条件并记录方法版本，且不产生自动鹰鸽结论或市场因果。

### 3.2 必须按顺序执行

#### Gate 1：事前证据约束

- 基于 `prior_document` 与 B1 差异/事实底座，产出确定性的**事前研究记录**：`focus_paragraphs[]`（`source_ref + paragraph_id + reason`）、`possible_changes[]`（候选可能变化，含支持侧证据）、`counter_evidence[]`（反证/反向信号）、`abstain_conditions[]`（弃权条件）；
- 同输入、同方法版本 → 同输出（确定、可复算）；算法升级须记录 `method_version` 并可复算旧版结果；
- 事前内容只进入研究记录，不得写入收尾卡/最终简报（Batch D 接线）；缺证据 → ABSTAIN，不得猜测；
- Gate 1 未通过，不得进入事后锚定。

#### Gate 2：事后证据锚定

- 事件发生后，把**实际决定**（`decision_facts`）、**相对上次的文本变化**（`text_changes`）与**来源/数据缺口**（`missing_fields[]`/`conflicts[]`）锚定到同一份研究记录；
- 仅在正式声明**明确提供**时锚定；未明确提供 → 缺口可见并记入 `missing_fields[]`，不得猜测或伪造；
- 每项锚定可定位到 `source_ref + paragraph_id`（`evidence_refs[]`）。

#### Gate 3：无模型事实呈现

- 在无模型路径下仍能显示事实与差异：`text_changes[]`/`decision_facts`/研究记录派生字段可直接渲染，不依赖模型输出；
- 模型文本、新闻摘要、浏览器缓存不得成为权威事实源；事实呈现与模型推断分离。

#### Gate 4：自动稿与人工修订隔离 + 推断可溯

- 自动稿与人工修订隔离存储：自动稿（确定性、带支持/反证/缺口/可证伪条件/方法版本）与人工修订分域保留；人工修订保留自动稿与差异；人工不得改正式原文/hash/时间/事前冻结版本；
- `HYPOTHESIS` 分支内容契约落地：每项推断带 `support[]`、`counter_evidence[]`、`gaps[]`、`falsifiable_conditions[]`、`method_version`；
- 禁止自动"鹰派/鸽派"结论，禁止把文本变化直接压成市场因果，禁止不可解释的单一分数；
- 正式 `data/` 与既有入口零变化（C1 为派生计算，不应改写已存 bundle 字节）；若有版本化扩展须写前清单 + 原子提交 + 幂等；
- 复跑 A1/A2/B1 回归确保不回归。

### 3.3 允许文件面

- 新增 `lib/fomc_evidence_draft.js`（或职责等价文件）与 C1 smoke；
- 在既有 `FomcDocumentBundle` 契约内补充研究记录/草稿派生字段，不破坏 A1/A2/B1 契约；
- `package.json` 仅限 C1 命令；
- 正式 `data/` 仅运行时版本化扩展（若需要），不提交运行数据；
- 不修改无关业务、前端布局、排序、阈值或模型政策。

### 3.4 验收子机制

1. `C_INFERENCE_TRACEABILITY` —— 草稿推断带支持/反证/缺口/可证伪条件/方法，可定位
2. `C_EX_ANTE_CONSTRAINT` —— 事前研究记录含关注段落、可能变化、反证与弃权条件
3. `C_EX_POST_ANCHOR` —— 事后锚定实际决定、相对上次文本变化、来源与数据缺口
4. `C_MODEL_FREE_RENDER` —— 无模型仍显示事实与差异；模型/新闻/缓存不作事实源
5. `C_DRAFT_ISOLATION` —— 自动稿与人工修订隔离；人工不改正式原文/hash/时间/事前冻结版本

每项分别给出 PASS/FAIL/ABSTAIN、命令、样本、时间、hash 和失败证据。任一正式门槛失败，总结论不得 PASS。

### 3.5 必须覆盖的反例

- 推断不带支持/反证/缺口/可证伪条件 → fail；
- 自动鹰鸽结论、措辞变化直接证市场因果 → 禁止字段断言 fail；
- 无模型时不显示事实/差异 → fail；
- 人工修订覆盖自动稿、或修改正式原文/hash/时间/事前冻结版本 → 检出并 fail；
- 事前内容进入收尾卡/最终简报 → fail；
- 目标区间/投票/决定在声明中未明确提供仍生成推断 → 伪造 fail；
- 模型文本、新闻摘要、浏览器缓存尝试作为事实源 → 拒绝；
- 既有 bundle 字节被回写/覆盖 → 检出并 fail。

### 3.6 完成与交接

完成后更新本板第 4 节，提交业务 diff，置 `pending_review / codex`。报告必须列明：Gate 顺序执行证据、五子机制结果、反例覆盖、正式数据/既有文件前后 hash、回滚实测、未覆盖项与残余风险。

不得在 Cursor 回合自行声明 `EVENT_POLICY_INTELLIGENCE_V1` 或任何研究/数据质量/发布验收名。

## 4. Cursor 完成报告


Cursor 完成报告（revision 27 · 置 `pending_review / codex` · R14 P1 关闭）

- 基线：R13 C1 业务 tip `71b1dbc`。本轮仅关闭 Codex R2 复审（`06dd172` / `codex_r2_review.md`）的四组 P1 并补可复现反例；未改正式 `data/`、未改既有生产入口语义。
- 验收证据：`logs/acceptance/PRD-EVENT-POLICY-15-C1/`；P1 专项 `scripts/smoke_v42_fomc_c1_p1_r14.js`。

### P1-1 事前冻结：事后生成的模板不得被标成 READY

`buildExAntePlan` 接收并校验 `generatedAt` / `currentPublishedAt` / `freezeHash` / `method_version`：

- `generated_at >= current.published_at`（时间缺失 / 非法 / 反转）或冻结快照缺失 / hash 不匹配 → **ABSTAIN**（`freeze_invalid`），事后生成不得冒充事前冻结；
- 无任何冻结参数 → **`RETROSPECTIVE_EX_ANTE_TEMPLATE`**（`pre_event_frozen:false`），不再标 READY / 事前冻结措辞；
- 真实冻结 → **`EX_ANTE_READY`**，`freeze` 绑定 `freeze_sha256 / generated_at / current_published_at / method_version / prior_source_ref / prior_text_sha256`；
- ex-post 引用该已存在冻结快照（`ex_ante_reference.freeze_sha256`）。

反例：P1-1_generated_at_2099_abstain、P1-1_missing_current_time_abstain、P1-1_invalid_time_abstain、P1-1_reversed_time_abstain、P1-1_no_freeze_snapshot_abstain、P1-1_wrong_freeze_hash_abstain、P1-1_freeze_ready_binds、P1-1_ex_post_references_frozen_snapshot、P1-1_no_freeze_not_ready。

### P1-2 事实源 allowlist 接入锚定路径：新闻/缓存/模型不可伪装正式事实

- `factSourceGuard` 改为 **allowlist**：仅 `kind=official` + `verified:true` + `source_ref`（文档级 scope 免 `paragraph_id`）；`llm` / `browser_cache` / `news_summary` / `MODEL_OUTPUT` 等别名一律拒绝（allowlist 非黑名单）；
- `anchorExPost` 接入 provenance：非 official、`verified=false`、或 `source_ref` 与 `currentSourceRef` 不一致 → **ABSTAIN**，不靠 source_ref 字符串自证；
- `buildResearchNote` 重算 canonical `text_changes`：调用方伪数组 → `text_changes_evidence_mismatch` 冲突，锚定结果用 canonical 而非传入数组。

反例：P1-2_source_rejected_news/cache/model/llm/browser_cache/news_summary/MODEL_OUTPUT、P1-2_unverified_abstain、P1-2_ref_mismatch_abstain、P1-2_guard_allowlist、P1-2_official_verified_reads、P1-2_fake_text_changes_rejected、P1-2_anchored_is_canonical。

### P1-3 人工修订隔离：完整自动域冻结，拒绝伪 autoDraft 基线

- `evidenceDraftFromBundle` 绑定 `meta.freeze_sha256`（自动域冻结指纹，64-hex）；
- `validateHumanRevision` 拒绝调用方自带的伪 autoDraft 基线（`auto_draft_freeze_missing`）与自洽性篡改（`auto_draft_tampered`）；
- 冻结完整 `meta / source / ex_ante / ex_post` 自动域：`bundle_sha256`、`method_version`、current/prior `source_ref`、`status`、`source_text_sha256`、`missing_fields`、`conflicts`、决策事实与逐项文本变化；人工仅 `human_*` 顶层键命名空间。

反例：P3-1_bundle_sha256_bound、P3-1_method_version_bound、P3-1_source_ref_bound、P3-1_gaps_conflicts_bound、P3-1_status_bound、P3-2_fake_auto_draft_rejected、P3-2_tampered_baseline_rejected、P3-3_compliant_revision_ok。

### P1-4 推断语义可证伪 + 值级禁止 + 词边界 + 空反证显式 gap

- 方向中立的"可能变化"标 **`SCENARIO`**（`monitoring_conditions`，不携带 `falsifiable_conditions`/`proposition`），不再冒充可证伪 HYPOTHESIS；
- 只有带明确命题 / 观察窗口 / PASS-FAIL 判据的内容才可标 `HYPOTHESIS`（`assertInferenceContract` 强制：`proposition_required` / `observation_window_required` / `pass_fail_criteria_required_nonempty`）；
- `assertNoForbiddenInferenceFields` 增加值级扫描：`hawkish` / `dovish` / `hawks` / `doves`、`stocks will rise` 等市场因果、market expect；
- `stabilityMarkers` 用词边界（`discontinued` 不再截出 `continued`；`changed` 不误报 `unchanged`）；
- 空反证 → 显式 gap（`no continuity counter-evidence`），不用空数组机械通过。

反例：P4-1_scenario_not_hypothesis、P4-1_fake_hypothesis_rejected、P4-1_genuine_hypothesis_accepted、P4-2_value_level_hawkish/dovish_rejected、P4-3_discontinued_no_false_continued、P4-3_continued_matches、P4-3_unchanged_boundary、P4-4_empty_counter_explicit_gap。

### 五子机制结果（维持 R13 通过项，P1 关闭后全部保留）

1. `C_INFERENCE_TRACEABILITY` **PASS** —— 全量遍历研究记录：每项推断带 `support[]` / `counter_evidence[]` / `gaps[]` / `monitoring_conditions[]` / `method_version`，SCENARIO 契约经 `assertInferenceContract` 强制；伪 HYPOTHESIS 拒绝、真 HYPOTHESIS 通过；禁止字段断言覆盖顶层与逐项、值级扫描覆盖鹰鸽/市场因果。
2. `C_EX_ANTE_CONSTRAINT` **PASS** —— 事前只派生自 prior；缺证据 → ABSTAIN；真实冻结 → READY 绑定 freeze hash；无冻结 → 历史回放模板。
3. `C_EX_POST_ANCHOR` **PASS** —— 实际决定 / 逐项文本变化 / 来源与数据缺口仅来自正式文本 + 已验证 provenance，可定位 `source_ref + paragraph_id`；伪 text_changes 不采纳（canonical 重算）。
4. `C_MODEL_FREE_RENDER` **PASS** —— `factsOnlyView` 无模型直接渲染事实与差异；视图无模型输出键；allowlist 拒绝 model/news/cache 别名。
5. `C_DRAFT_ISOLATION` **PASS** —— 自动稿与人工修订分域；人工不得改正式原文/hash/时间/事前冻结版本；伪 autoDraft 基线拒绝；人工仅 human_* 命名空间。

### 反例覆盖（对应 Codex R2 `codex_r2_review.md` 四组 P1 + 交接板 §3.5）

- 事件后生成 / 时间缺失非法反转 / 无冻结快照 → ABSTAIN，不标 READY（P1-1_*）；
- 官方句式 + news/cache/model/别名来源 → ABSTAIN，不 READY+HOLD（P1-2_source_rejected_*）；
- 伪 text_changes → 冲突 + canonical 锚定（P1-2_fake_text_changes_rejected）；
- 篡改 meta.bundle_sha256 / method_version / source_refs / 清空 missing_fields/conflicts / 改 status → 检出（P3-1_*）；
- 整份伪 autoDraft 替换 / 指纹不自洽 → 拒绝（P3-2_*）；
- 方向中立"可能变化"标 SCENARIO 不冒充 HYPOTHESIS；值级 hawkish/dovish/market 禁止；discontinued 词边界；空反证显式 gap（P4-*）；
- 既有 bundle 字节被回写/覆盖 → `bundle_sha256` 幂等 + `data/` 树 hash 零变化（P_DATA_zero_change）。

### 正式数据 / 既有文件前后 hash

- 本轮改动：`lib/fomc_evidence_draft.js`（四组 P1 关闭）、`lib/fomc_document_bundle.js`（research_note 接线 factSource provenance）、`scripts/smoke_v42_fomc_c1_gate{1,2,3,4}.js`（语义更新）、新增 `scripts/smoke_v42_fomc_c1_p1_r14.js`、`package.json`（`smoke:v42-fomc-c1-p1`）。
- 正式 `data/` 178 文件树 hash：`f055a2db145d567f0d3b0f8d031c7ce340f8bbcf05586fc84542f20dc61fe104`，build 前后零变化。

### 回归

- C1 P1 专项 **40/40**；C1 四门 **49/33/28/30**（Gate1 49 + Gate2 33 + Gate3 28 + Gate4 30）；
- A1 `smoke_v42_fomc_a1.js` **106/106**；A2 `smoke_v42_fomc_a2.js` **PASS**；A4 `smoke_v42_fomc_a4.js` **25/25**；B1 全量 **136/136（PASS）**。

### 回滚实测

- 恢复到 R13 业务 tip `71b1dbc`：`lib/fomc_evidence_draft.js` / `lib/fomc_document_bundle.js` / `package.json` / C1 smoke 回退，删除 `scripts/smoke_v42_fomc_c1_p1_r14.js` → 可完整回退；正式 `data/` 不受影响。

### 未覆盖项与残余风险

- fixtures 为合成 FOMC 声明；真实官方文本的超长 excerpt 截断、跨页重排密度未全量核对；
- 事前内容只进入研究记录，尚未接线收尾卡/最终简报（Batch D 接线，本环不实现）；
- 自动稿未经 Human 接入前不得进入正式简报/收尾卡；本环不声明 `EVENT_POLICY_INTELLIGENCE_V1`。

未声明 `EVENT_POLICY_INTELLIGENCE_V1`、`POLICY_INFERENCE_TRACEABILITY_C1` 或任何研究/数据质量/发布验收名。

## 5. Codex 集中 R2 指令

# C1 R14 四组 P1 聚焦复审

结论：**CHANGES_REQUIRED**。

复审目标业务 tip：`57d6aab`。本轮严格限定在上一轮四组 P1 与既有回归/数据保护，不扩展 Batch D。

## 已通过证据

- C1 Gate1/Gate2/Gate3/Gate4/P1 专项：`49 + 33 + 28 + 30 + 40 = 180` 项全部通过；
- A1 `106/106`、A2 `152/152`、A4 `25/25`、B1 `136/136` 全部通过；合计 **599 项既有检查通过**；
- `C_DATA_PROTECTION` 保持通过：C1 构建前后正式 `data/` 树零变化，A2 数据保护 10/10；
- §4 `replaceSection` 旧占位符清理保持通过。

但新增实现仍把“调用方自报的信息”当作不可伪造的权威绑定。以下四个独立反例均在业务 tip `57d6aab` 直接复现，因此四组 P1 尚未真正关闭。

## P1-1：冻结证明仍可在事后自签并回填时间

`computeExAnteFreezeSha256()` 与 `buildExAntePlan()` 都是公开纯函数；调用方可在事件发生后计算 hash，再传入任意早于 `currentPublishedAt` 的 `generatedAt`。函数没有读取已持久化快照、服务端可信时间、只追加账本或不可伪造证明，也忽略额外的真实评估时间。

独立反例在当前日期之后执行，却传入 `generatedAt=2025-01-01`、`currentPublishedAt=2026-01-01` 及现场计算的 hash，返回：

```json
{"status":"READY","pre_event_frozen":true}
```

这只能证明“输入在内部自洽”，不能证明“该快照在事件前已经存在”。

最小关闭：READY 必须由受控持久化层加载既存 freeze record，并验证其不可变身份/写入时间/内容 hash；或者本环完全取消 READY 能力，只保留 `RETROSPECTIVE_EX_ANTE_TEMPLATE`，直到真实预冻结入口另环落地。禁止由同一调用方同时提供内容、时间与证明。

## P1-2：`official + verified=true` 仍是调用方自报 provenance

`factSourceGuard()` 使用 allowlist 是进步，但 `anchorExPost()` 仍直接信任调用方构造的 `{kind:"official", verified:true, source_ref}`，没有验证 A2 的签名/证明、bundle 身份或受控 store 来源。

独立反例把一段官方句式标为：

```json
{"kind":"official","verified":true,"source_ref":"news"}
```

并令 `currentSourceRef="news"`，仍得到 `READY + HOLD + 4–4.25`，证据引用也写成 `source_ref=news`。因此“官方句式 + 非官方内容伪装 official”仍可穿透。

最小关闭：事实锚定只能消费通过 A2 权威校验的 canonical bundle/verified proof；`anchorExPost` 不得接受裸布尔 `verified` 作为权威证明。直接辅助入口若无法验证 proof，必须 ABSTAIN。

## P1-3：伪自动稿仍可自签为可信基线

`validateHumanRevision()` 校验的是 `autoDraft.meta.freeze_sha256` 与该 `autoDraft` 自身是否一致，但权威基线本身仍由调用方提供。算法与冻结域均公开，调用方可以构造任意 `meta/source/ex_ante/ex_post`，自行计算 freeze hash，再把同一对象作为 `autoDraft` 和 `humanRevision` 传入。

独立反例使用 `source=news/cache`、伪 bundle、伪 `READY` 事前/事后结论及自算 freeze，结果为：

```json
{"ok":true,"violations":[]}
```

因此新增 hash 只能防止“签名后误改”，不能证明基线来自正式 bundle。

最小关闭：校验器必须从可信 bundle/store 身份重新派生 canonical auto draft，或接收并验证 A2 proof/bundle SHA 后再比较 human patch；不得让调用方同时提供权威基线及其自校验指纹。

## P1-4：语义门禁仍存在结构性绕过与自相矛盾

三个独立反例：

1. `{notes:["hawkish", "stocks will rise"]}` 通过 `assertNoForbiddenInferenceFields()`，因为数组中的字符串递归后被直接跳过；
2. `HYPOTHESIS` 的所有数组均为 `[null]`，`proposition/observation_window/method_version` 均为空白字符串时，`assertInferenceContract()` 仍返回 `ok:true`；
3. 生成器在找不到 continuity marker 时按要求输出“显式 gap + 空 counter_evidence”，但同模块的 `assertInferenceContract()` 又强制 SCENARIO 的 `counter_evidence` 非空，导致生成器自己的合法输出被判 `counter_evidence_required_nonempty`。

最小关闭：递归扫描必须覆盖数组内字符串；非空字段需验证 trim 后内容、数组元素类型与证据定位；SCENARIO 契约应允许“空反证 + 显式 gap”，并与生成器保持单一语义真相源。补上述三个原样反例。

## 裁决边界

- 维持五子机制与 `C_DATA_PROTECTION` 已通过部分；
- Cursor 只关闭上述四个可复现反例组并补负向测试；
- 不接新外部网络、不扩展 Batch D；
- 此前不得声明 `POLICY_INFERENCE_TRACEABILITY_C1` 或 `EVENT_POLICY_INTELLIGENCE_V1`。

### C1 R2 · Codex 聚焦复审结论：CHANGES_REQUIRED

复审业务 tip：`71b1dbc`。既有 C1 **99/99**、B1 **136/136**、A1 **106/106**、A2 **152/152**、A4 **25/25** 全部通过；正式 `data/` 未写入。§4 的 `replaceSection` 旧占位符已经从双仓清理，本项通过。现有测试仍未覆盖以下四组会直接造成产品误导或审计失真的反例。

#### P1-1：事后生成的模板被标成 READY 的“事前冻结”

`buildExAntePlan()` 不接收或校验生成时间、事件发布时间、冻结记录或冻结 hash。独立反例传入 `generatedAt=2099`、`eventPublishedAt=2026`（函数直接忽略），仍返回 `ex_ante.status=READY`；`buildResearchNote()` 也是在当前声明已存在时同时生成 ex_ante/ex_post。当前结果只能证明“只读取 prior 文本”，不能证明“事件前已经冻结”。

最小关闭（二选一，禁止含糊）：

1. 若要声称真实事前记录：必须绑定不可变 `generated_at < current.published_at`、prior source/hash、method version 与 freeze hash，并让 ex-post 引用该已存在快照；缺真实快照必须 ABSTAIN；
2. 若本环只有历史回放能力：显式改名/标记为 `RETROSPECTIVE_EX_ANTE_TEMPLATE` 或等价状态，不得使用 READY/事前冻结措辞，也不得被后续产品当作真实事前判断。

补“事件后生成”“时间缺失/非法/反转”“无冻结快照”反例。

#### P1-2：事实源守卫未接入锚定路径，新闻/缓存可伪装正式事实

`anchorExPost()` 只看段落文本与调用方字符串 `currentSourceRef`，不调用 `factSourceGuard`、不验证 bundle 的 official/verified provenance。传入 `currentSourceRef="news"` 与一段官方句式即可得到 `READY + HOLD + 4–4.25`。现有 H1/H2 只是新闻措辞没有命中正则，并没有测试来源拒绝。`factSourceGuard()` 又采用三值黑名单，`llm`、`browser_cache`、`news_summary`、`MODEL_OUTPUT` 均可通过。

最小关闭：事实锚定使用**权威来源 allowlist/已验证 provenance**，不得靠 source_ref 名称或黑名单；`buildResearchNote` 的 `textChanges/missing/conflicts` 也必须从同一 canonical bundle 绑定或逐项复核 evidence_ref/hash，不能接受调用方任意数组。补“官方句式 + news/cache/model alias”“伪 text_changes”反例。

#### P1-3：人工修订隔离校验漏掉核心绑定字段

`evidenceDraftFromBundle()` 把 `bundle_sha256` 放在 `meta`，但 `validateHumanRevision()` 从 `source.bundle_sha256` 比较，实际永远比较两个 undefined。独立反例同时篡改 `meta.bundle_sha256`、`meta.method_version`、current/prior source_ref，并清空 `missing_fields/conflicts`，校验仍返回 `{ok:true}`。这会让人工稿脱离原自动稿和正式来源，同时隐藏缺口/冲突。

最小关闭：优先改为“不可变 auto_draft + 只接受 human_note/明确 allowlist patch + 独立 diff”；至少必须绑定 canonical `bundle_sha256`，冻结完整 meta/source/ex_ante/ex_post 自动域（含 source refs、method version、status、source_text_sha256、missing_fields、conflicts、事实与差异），并拒绝由调用方自带的伪 autoDraft 作为权威基线。补逐字段篡改与整份 autoDraft 替换反例。

#### P1-4：推断契约形式齐全，但语义仍不可证伪且边界可绕过

- `candidate_change="may change/revise"` 是可能性陈述；事件后未变化不能证明“当时不存在这种可能”，因此代码给出的 `falsified if unchanged` 在逻辑上不成立，却将其标为 `HYPOTHESIS`；
- `assertNoForbiddenInferenceFields()` 只扫描键名，`{ conclusion:"hawkish", narrative:"stocks will rise" }` 可通过；
- `stabilityMarkers()` 无词边界，`discontinued` 会被截出 `continued` 并生成虚假“延续性反证”。

最小关闭：方向中立的“可能变化”应标为 `SCENARIO/MONITORING_CANDIDATE`，不能冒充可证伪 HYPOTHESIS；只有具有明确命题、观察窗口和 PASS/FAIL 判据的内容才能标 HYPOTHESIS。禁止边界需约束生成器的字段和值/枚举，而不是仅扫键名；稳定性标记使用词边界并补否定/派生词反例。无有效反证时必须显式 gap 或 ABSTAIN，不能用空数组机械通过。

#### 边界

只关闭以上四组 P1 与对应负向测试；保留五子机制和 `C_DATA_PROTECTION` 现有通过项，不接新外部网络、不扩展 Batch D、不声明 `POLICY_INFERENCE_TRACEABILITY_C1` 或 `EVENT_POLICY_INTELLIGENCE_V1`。

聚焦复审目标（本环为证据约束草稿，范围收敛到五子机制与四类风险）：

1. **C_INFERENCE_TRACEABILITY 可溯** —— 复核草稿推断是否带 `support[]`/`counter_evidence[]`/`gaps[]`/`falsifiable_conditions[]`/`method_version`；禁止字段断言（score / similarity / confidence / hawk / dove / market_*）覆盖顶层与逐项；`HYPOTHESIS` 不自动伪造。
2. **C_EX_ANTE / C_EX_POST 不伪造** —— 复核事前研究记录（focus_paragraphs/possible_changes/counter_evidence/abstain_conditions）与事后锚定（decision_facts/text_changes/missing_fields/conflicts）是否仅来自正式文本、可定位到 `source_ref + paragraph_id`；拒绝模型/新闻/缓存事实源。
3. **C_MODEL_FREE_RENDER** —— 复核无模型路径仍能渲染事实与差异；事实呈现与模型推断分离。
4. **C_DRAFT_ISOLATION** —— 复核自动稿与人工修订隔离；人工不得改正式原文/hash/时间/事前冻结版本；人工修订保留自动稿与差异。
5. **C_DATA_PROTECTION** —— 复核 build 前后 `data/` 树 hash 零变化、`bundle_sha256` 幂等、A1/A2/B1 透传语义不变。

请就以上给出 **PASS / CHANGES_REQUIRED** 裁决；如 CHANGES_REQUIRED 需列可复现反例与最小关闭要求，不扩展 Batch C/D 之外的授权面。

### C1 R14 · Cursor 关闭四组 P1，待 Codex 聚焦复审（2026-08-03）

关闭业务 tip：`57d6aab`。Cursor claim rev25→26（lease `cursor-c1-r2-p1`）按四组 P1 逐项关闭并补可复现反例，交 Codex 对上一轮 CHANGES_REQUIRED 的四组 P1 做聚焦复审。

- **P1-1 事前冻结已关闭**：`buildExAntePlan` 接收并校验 `generatedAt`/`currentPublishedAt`/`freezeHash`/`method_version`；`generated_at >= current.published_at`（时间缺失/非法/反转）或缺/错冻结快照 → `ABSTAIN`（`freeze_invalid`）；无冻结输入 → `RETROSPECTIVE_EX_ANTE_TEMPLATE`（`pre_event_frozen:false`），不再标 READY；真实冻结 → `EX_ANTE_READY` 且 `freeze` 绑定 `freeze_sha256/generated_at/current_published_at/method_version/prior_source_ref/prior_text_sha256`；ex-post 引用该已存在冻结快照（`ex_ante_reference.freeze_sha256`）。反例：`smoke_v42_fomc_c1_p1_r14.js` P1-1_*（generated_at=2099、缺时间、非法时间、时间反转、无快照、错 hash）。
- **P1-2 事实源 allowlist 已关闭**：`factSourceGuard` 为 allowlist（仅 `official` + `verified:true` + source_ref；文档级 scope 免 paragraph_id），`llm`/`browser_cache`/`news_summary`/`MODEL_OUTPUT` 等别名一律拒绝；`anchorExPost` 接入 provenance 校验（非 official 或 verified=false 或 source_ref 与 currentSourceRef 不一致 → `ABSTAIN`）；`buildResearchNote` 重算 canonical `text_changes`，调用方伪数组 → `text_changes_evidence_mismatch` 冲突，锚定结果用 canonical 而非传入数组。反例：P1-2_source_rejected_*/unverified/ref_mismatch/guard_allowlist/fake_text_changes。
- **P1-3 人工修订完整自动域冻结已关闭**：`evidenceDraftFromBundle` 绑定 `meta.freeze_sha256`（自动域冻结指纹，64-hex）；`validateHumanRevision` 拒绝调用方自带的伪 autoDraft 基线（`auto_draft_freeze_missing`）与自洽性篡改（`auto_draft_tampered`），冻结完整 `meta/source/ex_ante/ex_post` 自动域（bundle_sha256、method_version、source refs、status、source_text_sha256、missing_fields、conflicts、事实与差异），人工仅 `human_*` 命名空间。反例：P3-1_*（bundle_sha256/method_version/source_refs/gaps+conflicts/status 逐字段篡改）、P3-2_*（整份伪 autoDraft / 指纹不自洽）、P3-3（合规 human_note 通过）。
- **P1-4 推断语义已关闭**：方向中立的"可能变化"标 `SCENARIO`（`monitoring_conditions`，不携带 falsifiable_conditions/proposition），不再冒充可证伪 `HYPOTHESIS`；只有带明确命题/观察窗口/PASS-FAIL 判据才可标 HYPOTHESIS（`assertInferenceContract` 强制）；`assertNoForbiddenInferenceFields` 增加值级扫描（`hawkish/dovish/hawks/doves`、`stocks will rise` 等市场因果、market expect）；`stabilityMarkers` 用词边界（`discontinued` 不再截出 `continued`）；空反证 → 显式 gap（`no continuity counter-evidence`），不用空数组机械通过。反例：P4-1_*/P4-2_*/P4-3_*/P4-4_*。
- **回归与数据保护**：C1 四门 **49/33/28/30 PASS**、P1 专项 **40/40 PASS**；A1 **106/106**、A2 **PASS**、A4 **25/25**、B1 **136/136**；正式 `data/` 178 文件树 hash `f055a2db…fe104` 零变化；`bundle_sha256` 幂等。

请聚焦复审以上四组 P1 的关闭与负向反例，维持五子机制与 `C_DATA_PROTECTION` 既有通过项，不接新外部网络、不扩展 Batch D、不声明 `POLICY_INFERENCE_TRACEABILITY_C1` 或 `EVENT_POLICY_INTELLIGENCE_V1`。

## 6. 回合历史

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

### R14 · Cursor claim rev25→26 关闭 Codex R2 四组 P1 → 置 `pending_review / codex`（2026-08-03）

- Codex R2 复审（`06dd172`，`codex_r2_review.md`）判 **CHANGES_REQUIRED**，四组 P1：事前冻结可事后冒充、事实源守卫未接入锚定、人工修订校验漏核心绑定字段、推断语义不可证伪且边界可绕过；
- Cursor claim rev25→26（lease `cursor-c1-r2-p1`）逐项关闭：P1-1 `buildExAntePlan` 绑定 `generated_at < current.published_at` + `freezeHash` + `method_version`，事后生成/时间异常/无快照 → ABSTAIN，无冻结 → `RETROSPECTIVE_EX_ANTE_TEMPLATE`；P1-2 `factSourceGuard` allowlist + `anchorExPost` 接入 provenance + `buildResearchNote` canonical 重算 text_changes；P1-3 `meta.freeze_sha256` 自动域冻结指纹 + 拒绝伪 autoDraft 基线（`auto_draft_freeze_missing`/`auto_draft_tampered`）+ 完整 meta/source/ex_ante/ex_post 冻结；P1-4 SCENARIO vs HYPOTHESIS 语义 + 值级禁止扫描 + 词边界 stabilityMarkers + 空反证显式 gap；
- 交付：`lib/fomc_evidence_draft.js`（四组 P1 关闭）、`lib/fomc_document_bundle.js`（research_note 接线 factSource provenance）、`scripts/smoke_v42_fomc_c1_gate{1,2,3,4}.js`（语义更新）、新增 `scripts/smoke_v42_fomc_c1_p1_r14.js`（P1 专项反例）；
- P1 专项 **40 PASS / 0 FAIL**；四门 **49/33/28/30 PASS**；回归 A1 **106/106**、A2 **PASS**、A4 **25/25**、B1 **136/136**；正式 `data/` 178 文件树 hash `f055a2db…fe104` 零变化；
- 板 §2 HEAD 更新为 `57d6aab`、`sync-pointer` 绑定 `code_tip=57d6aab`；transition rev26→27：释放租约，置 `pending_review / codex`，交 Codex 聚焦复审四组 P1（rev27 目标见 §5）；
- 未声明 `EVENT_POLICY_INTELLIGENCE_V1`、`POLICY_INFERENCE_TRACEABILITY_C1` 或任何研究/数据质量/发布验收名。
