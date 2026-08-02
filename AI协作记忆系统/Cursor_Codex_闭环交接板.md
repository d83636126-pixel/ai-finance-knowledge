---
type: Cursor_Codex闭环交接板
schema_version: 2
tags: [AI协作, Cursor, Codex, V4.2, C1, FOMC]
created: 2026-08-01
updated: '2026-08-02'
project: financial-alert-system
loop_id: PRD-EVENT-POLICY-15-C1
acceptance: POLICY_INFERENCE_TRACEABILITY_C1
revision: 23
turn: 0
next_actor: 'codex'
status: 'pending_review'
max_turns: 3
last_writer: 'cursor'
written_at: '2026-08-02T16:28:04.793Z'
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
| HEAD | `71b1dbc`（C1 业务 tip） |
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

Cursor 完成报告（revision 23 · 置 `pending_review / codex`）

- 基线：开环 `2d18ab6`（B1 业务 tip）。本轮仅新增 C1 候选模块 / smoke / 验收证据，未改正式 `data/`、未改既有生产入口语义。
- 验收证据：`logs/acceptance/PRD-EVENT-POLICY-15-C1/gate{1,2,3,4}_*_evidence.json`。

### Gate 顺序执行证据（TDD 先测后实现，逐门推进，未跨门）

| Gate | 交付 | 冒烟 | 断言 |
|---|---|---|---|
| 1 事前证据约束 | `buildExAntePlan`（focus_paragraphs / possible_changes / counter_evidence / abstain_conditions） | `scripts/smoke_v42_fomc_c1_gate1.js` | 39/39 PASS |
| 2 事后证据锚定 | `anchorExPost`（decision_facts / missing_fields / evidence_refs） | `scripts/smoke_v42_fomc_c1_gate2.js` | 21/21 PASS |
| 3 无模型事实呈现 | `factsOnlyView` + `factSourceGuard` | `scripts/smoke_v42_fomc_c1_gate3.js` | 20/20 PASS |
| 4 自动稿隔离 + 推断可溯 | `buildResearchNote` + `evidenceDraftFromBundle` + `validateHumanRevision` + `assertNoForbiddenInferenceFields` | `scripts/smoke_v42_fomc_c1_gate4.js` | 19/19 PASS |

- bundle 接线：`lib/fomc_document_bundle.js` 契约内补充派生字段 `research_note`（`{ method_version, ex_ante, ex_post }`）；事前 `ex_ante` 只派生自 `prior`（事前冻结），事后 `ex_post` 锚定实际决定 / 逐项文本变化 / 来源与数据缺口。透传 `decision_facts` + `missing_fields` 语义不变，`bundle_sha256` 幂等保持。
- 每门先写测试见 RED（MODULE_NOT_FOUND / 断言失败），再实现至 GREEN。

### 五子机制结果

1. `C_INFERENCE_TRACEABILITY` **PASS** —— 每项推断带 `support[]` / `counter_evidence[]` / `gaps[]` / `falsifiable_conditions[]` / `method_version`，且 `support`/`counter_evidence` 全部可定位到 `source_ref + paragraph_id`；全量遍历研究记录无缺失（P_every_inference_contract）；无自动鹰鸽 / 单一分数 / 市场因果字段（禁止字段断言，顶层与逐项）。
2. `C_EX_ANTE_CONSTRAINT` **PASS** —— 事前研究记录含关注段落（5 段，source_ref + paragraph_id + reason + topics）、可能变化（每关注段一个候选，含支持侧证据）、反证（prior 正式文本延续性标记，方向中立）、弃权条件（`next_statement_unavailable` / `decision_not_stated` / 缺基线追加）；同输入同 method_version 字节级同输出；缺证据 → ABSTAIN，不猜测。
3. `C_EX_POST_ANCHOR` **PASS** —— 实际决定（HOLD 3.75–4，evidence_refs 2 条可定位）、逐项文本变化（7 条全带 evidence_refs）、来源与数据缺口（投票缺口 `vote` 记入 missing_fields 并集 + bundle 缺口，conflicts 锚定）；仅在正式声明明确提供时锚定，输入伪造 `decision_facts` 不继承（纯文本派生）。
4. `C_MODEL_FREE_RENDER` **PASS** —— `factsOnlyView` 无模型直接渲染事实与差异（text_changes / decision_facts / research_note / missing_fields / conflicts / source_refs）；`factSourceGuard` 拒绝 model/news/cache 与缺 source_ref/paragraph_id；视图无模型输出键（model_output/llm/summary）。
5. `C_DRAFT_ISOLATION` **PASS** —— 自动稿（`evidenceDraftFromBundle`，`auto_draft:true`）与人工修订分域；`validateHumanRevision` 检出改事前冻结版本 / 正式时间 / 正式 hash / 覆盖自动稿决策事实 / 覆盖逐项文本变化；合规修订（仅追加 human_note）通过；人工不得改正式原文/hash/时间/事前冻结版本。

### 反例覆盖（对应 C1 计划 §6 + 交接板 §3.5）

- 推断不带支持/反证/缺口/可证伪条件 → 全字段断言 fail（B_pc_contract_* / P_every_inference_contract）；
- 自动鹰鸽结论、措辞变化直接证市场因果 → 禁止字段断言 + 无 market_* 因果（D / M / P_no_forbidden_anywhere）；
- 无模型时不显示事实/差异 → `factsOnlyView` 可直接序列化渲染（K_*）；
- 人工修订覆盖自动稿、或修改正式原文/hash/时间/事前冻结版本 → 检出并 fail（O2–O7）；
- 目标区间/投票/决定在声明中未明确提供仍生成推断 → 伪造 fail（G / F_fixture_vote_gap）；
- 模型文本、新闻摘要、浏览器缓存尝试作为事实源 → `factSourceGuard` 拒绝（L_*）；
- 既有 bundle 字节被回写/覆盖 → `bundle_sha256` 幂等 + `data/` 树 hash 零变化（E / J / N / P_bundle_bytes_stable）。

### 正式数据 / 既有文件前后 hash

- 本轮改动仅：新增 `lib/fomc_evidence_draft.js`、`scripts/smoke_v42_fomc_c1_*.js`、`logs/acceptance/PRD-EVENT-POLICY-15-C1/`；修改 `lib/fomc_document_bundle.js`（契约内新增派生字段 `research_note`）、`package.json`（仅 C1 命令）。
- 正式 `data/` 178 文件树 hash：`f055a2db145d567f0d3b0f8d031c7ce340f8bbcf05586fc84542f20dc61fe104`，build 前后零变化。

### 回归

- A1 `smoke_v42_fomc_a1.js` **106/106**；A2 `smoke_v42_fomc_a2.js` **152/152（PASS）**；A4 `smoke_v42_fomc_a4.js` **25/25（PASS）**；B1 全量 **136/136（PASS）**；C1 四门 **99/99（PASS）**。

### 回滚实测

- 删除未接入正式入口的 C1 候选模块与 smoke（`lib/fomc_evidence_draft.js`、`scripts/smoke_v42_fomc_c1_*.js`），`lib/fomc_document_bundle.js` / `package.json` 恢复 `2d18ab6` → 可完整回退；正式 `data/` 不受影响。

### 未覆盖项与残余风险

- fixtures 为合成 FOMC 声明；真实官方文本的超长 excerpt 截断、跨页重排密度未全量核对；
- 事前内容只进入研究记录，尚未接线收尾卡/最终简报（Batch D 接线，本环不实现）；
- 自动稿未经 Human 接入前不得进入正式简报/收尾卡；本环不声明 `EVENT_POLICY_INTELLIGENCE_V1`。

未声明 `EVENT_POLICY_INTELLIGENCE_V1`、`POLICY_INFERENCE_TRACEABILITY_C1` 或任何研究/数据质量/发布验收名。

## 5. Codex 集中 R2 指令

聚焦复审目标（本环为证据约束草稿，范围收敛到五子机制与四类风险）：

1. **C_INFERENCE_TRACEABILITY 可溯** —— 复核草稿推断是否带 `support[]`/`counter_evidence[]`/`gaps[]`/`falsifiable_conditions[]`/`method_version`；禁止字段断言（score / similarity / confidence / hawk / dove / market_*）覆盖顶层与逐项；`HYPOTHESIS` 不自动伪造。
2. **C_EX_ANTE / C_EX_POST 不伪造** —— 复核事前研究记录（focus_paragraphs/possible_changes/counter_evidence/abstain_conditions）与事后锚定（decision_facts/text_changes/missing_fields/conflicts）是否仅来自正式文本、可定位到 `source_ref + paragraph_id`；拒绝模型/新闻/缓存事实源。
3. **C_MODEL_FREE_RENDER** —— 复核无模型路径仍能渲染事实与差异；事实呈现与模型推断分离。
4. **C_DRAFT_ISOLATION** —— 复核自动稿与人工修订隔离；人工不得改正式原文/hash/时间/事前冻结版本；人工修订保留自动稿与差异。
5. **C_DATA_PROTECTION** —— 复核 build 前后 `data/` 树 hash 零变化、`bundle_sha256` 幂等、A1/A2/B1 透传语义不变。

请就以上给出 **PASS / CHANGES_REQUIRED** 裁决；如 CHANGES_REQUIRED 需列可复现反例与最小关闭要求，不扩展 Batch C/D 之外的授权面。

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
