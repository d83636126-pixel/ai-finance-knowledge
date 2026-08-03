---
type: Cursor_Codex闭环交接板
schema_version: 2
tags: [AI协作, Cursor, Codex, V4.2, C1, FOMC]
created: 2026-08-01
updated: '2026-08-03'
project: financial-alert-system
loop_id: PRD-EVENT-POLICY-15-C1
acceptance: POLICY_INFERENCE_TRACEABILITY_C1
revision: 43
turn: 0
next_actor: 'cursor'
status: 'pending_exec'
max_turns: 3
last_writer: 'codex'
written_at: '2026-08-03T07:08:17.466Z'
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
| HEAD | `b13a3ea`（C1 R18 来源身份绑定业务 tip） |
| 开环基线 | `2d18ab6`（B1 业务 tip） |
| A1 / A2 / B1 业务 tip | `b1abce5` / `50b88aa` / `2d18ab6` |
| change class | `C2` |
| review | `R2`（聚焦） |
| status / next_actor | `pending_review / codex` |
| 授权范围 | 沿用 V4.2 主计划与 B1 已授权面；本环为证据约束草稿派生计算，无新外部网络/正式写入/后台调度需求 |
| R18 复审目标 | `b13a3ea`（来源身份绑定；Codex R17 `codex_r17_p1_3_focused_review.md` CHANGES_REQUIRED 关闭） |
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

Cursor 完成报告（revision 41 · 置 `pending_review / codex` · R18 关闭 Codex R17 来源身份绑定缺口）

- 基线：R17 C1 业务 tip `02fbcb8`。Codex R17 聚焦复审 `codex_r17_p1_3_focused_review.md` 判 **CHANGES_REQUIRED**：R16 的"无证明 ABSTAIN 可签收"反例已关闭，但 `source_refs` 尚未与所提交的 A2 已验证文档身份绑定——调用方仍能保留真实 A2 文档与有效 proof，改写 bundle 的来源标识（删 `domain` 的 READY、伪造 `source_version` 的 ABSTAIN），重算 `research_note` 与 `bundle_sha256`，仍通过根信任与人工修订。本轮业务 tip `b13a3ea` 按 Codex R17 最小关闭四项关闭该缺口；未改正式 `data/`、未改既有生产入口语义。
- 验收证据：`logs/acceptance/PRD-EVENT-POLICY-15-C1/`；P1 专项 `scripts/smoke_v42_fomc_c1_p1_r14.js`。

### 来源身份绑定：source_ref ↔ A2 已验证文档逐项精确绑定

`lib/fomc_evidence_draft.js` 关闭 Codex R17 最小关闭四项：

- `documentBindsToBundle`：文档事件身份改为**必填且精确相等**（不再"双方都有才比较"的可选式绑定），否则 `current/prior_document_binding_mismatch`；
- 新增 `sourceRefBindsToVerifiedDoc`：把 bundle 冻结的 `source_ref` 与对应 A2 已验证文档身份逐项精确绑定——`event_id`（必填精确）、`text_sha256`（相等）、`source_version`（与 `doc.source.source_version` 精确一致）、规范化 `domain`（与 `verified_provenance.final_domain`/`source.domain` 相等）；bundle 冻结 URL/captured_at 时同样要求与已验证文档一致；缺字段或任一不一致 → `current/prior_source_identity_mismatch`；
- 检查 C 字段完整：current/prior `source_ref` 的 `domain` 非空且命中固定 allowlist（`source_ref_not_official`）、`synthetic === false`（`source_ref_synthetic`）、`source_version` 非空（`current/prior_source_version_required`）；
- 检查 E 接来源身份绑定：A2 proof 验签 + 文档绑定通过后，再执行 `sourceRefBindsToVerifiedDoc`，任一不一致 → `auto_draft_baseline_untrusted`，不进入人工修订比较。

### 反例覆盖（对应 Codex R17 `codex_r17_p1_3_focused_review.md` 两个独立反例 + 正例）

`scripts/smoke_v42_fomc_c1_p1_r14.js` 新增 P1-3c（4 断言）：

- `P1-3c_genuine_ready_ok`：真实 READY bundle + 真证 current/prior → 人工修订通过（violations 空，不误伤）；
- `P1-3c_delete_domain_ready_rejected`（Codex R17 独立反例 A）：删除两个 `source_refs[].domain` + 重算 canonical `bundle_sha256` → `auto_draft_baseline_untrusted` + `source_ref_not_official` + `current/prior_source_identity_mismatch`（删 domain 不再跳过官方域检查）；
- `P1-3c_forged_abstain_shape`（反例 B 前置）：伪造 `source_version`（域仍官方）后 `evidence_scope="official"`、`synthetic=false`、ex_post `ABSTAIN`；
- `P1-3c_forge_source_version_abstain_rejected`（Codex R17 独立反例 B）：伪造 current/prior `source_version` 为 `attacker-current-v1`/`attacker-prior-v1` + 用伪 source ref 重放 research note（事后降 ABSTAIN）+ 重算 canonical `bundle_sha256` + 提交真实 A2 proof → `auto_draft_baseline_untrusted` + `current/prior_source_identity_mismatch`，且 **无** `research_note_replay_mismatch`（replay 自洽，仅来源身份绑定命中——证明只有身份绑定挡住伪造，ABSTAIN 不再是来源身份不一致的降级通道）。

### 五子机制结果（维持 R17 通过项，来源身份绑定后全部保留）

1. `C_INFERENCE_TRACEABILITY` **PASS**；
2. `C_EX_ANTE_CONSTRAINT` **PASS**；
3. `C_EX_POST_ANCHOR` **PASS**；
4. `C_MODEL_FREE_RENDER` **PASS** —— `factsOnlyView` 只读展示路径不受影响；
5. `C_DRAFT_ISOLATION` **PASS** —— 人工修订的 canonical 基线一律来自先经根信任验证的 bundle；缺失或伪造的来源身份无法冻结进 auto draft。

### 正式数据 / 既有文件前后 hash

- 本轮改动：`lib/fomc_evidence_draft.js`（documentBindsToBundle 必填精确 + sourceRefBindsToVerifiedDoc 新增 + C 字段完整 + E 来源身份绑定）、`scripts/smoke_v42_fomc_c1_p1_r14.js`（P1-3c 四断言）。
- 正式 `data/` 树 hash：`ae7447d3fb68b467fcde59fe4d2e24cabbb808063de0bbf82b7f200fd4e2818d`（178 文件），build 前后零变化；`bundle_sha256` 幂等。

### 回归

- P1 专项 **58/58 PASS**（54 + P1-3c 4）；Gate 4 **39/39 PASS**；
- A1 `smoke_v42_fomc_a1.js` **106/106**；A2 `smoke_v42_fomc_a2.js` **PASS**（152 断言）；A4 `smoke_v42_fomc_a4.js` **25/25**；B1 全量 **136/136 PASS**（64+33+20+14+5）；C1 Gate1/Gate2/Gate3 **47/32/32 PASS**；合计 **627 PASS / 0 FAIL**。

### 回滚实测

- 恢复到 R17 业务 tip `02fbcb8`：`lib/fomc_evidence_draft.js`/`scripts/smoke_v42_fomc_c1_p1_r14.js` 回退 → 可完整回退；正式 `data/` 不受影响。

### 未覆盖项与残余风险

- fixtures 为合成 FOMC 声明；真实官方文本的超长 excerpt 截断、跨页重排密度未全量核对；
- 事前内容只进入研究记录，尚未接线收尾卡/最终简报（Batch D 接线，本环不实现）；
- 本环无受控持久化冻结层：`RETROSPECTIVE_EX_ANTE_TEMPLATE` 是历史回放模板，真实"事件前已冻结"入口需另环在受控持久化层落地；
- READY 与 ABSTAIN 路径均需调用方供 A2 已验证文档（bundle 不携带 proof）：正式接线时由 A2 受控 store 供档，本环保持纯函数；
- 自动稿未经 Human 接入前不得进入正式简报/收尾卡；本环不声明 `EVENT_POLICY_INTELLIGENCE_V1`。

未声明 `EVENT_POLICY_INTELLIGENCE_V1`、`POLICY_INFERENCE_TRACEABILITY_C1` 或任何研究/数据质量/发布验收名。


Cursor 完成报告（revision 37 · 置 `pending_review / codex` · R17 关闭 Codex R16 ABSTAIN 根信任绕过）

- 基线：R16 C1 业务 tip `71b9440`。Codex R16 聚焦复审 `codex_r16_p1_3_focused_review.md` 判 **CHANGES_REQUIRED**：P1-3 的 READY 路径已加固，但 ABSTAIN 路径仍允许调用方自造 bundle 根信任（`verifyBundleTrust` 把 source allowlist、A2 proof、`evidence_scope=official` 与 fact-source 权威校验全部放在 `ex_post.status === "READY"` 条件之下）。本轮业务 tip `02fbcb8` 按 Codex 最小关闭**方案 1（严格正式基线）** + Human（2026-08-03）确认指令"一律要求可信来源（推荐）"关闭该绕过；未改正式 `data/`、未改既有生产入口语义。
- Human（2026-08-03）指令：**无论 READY 还是 ABSTAIN，进入人工修订前都必须有可信来源证明；或者允许不可信 ABSTAIN 只读展示，但禁止签收和冻结**。经确认选定 **一律要求可信来源**：READY 与 ABSTAIN 进入人工修订前都必须有可信来源证明（A2 验签 + official scope）；未验证 bundle → `validateHumanRevision` 一律 `auto_draft_baseline_untrusted`；`factsOnlyView` 只读展示仍可用（Gate 3 不受影响）；Gate4 人工修订用例改用 A2 真证 bundle。
- 验收证据：`logs/acceptance/PRD-EVENT-POLICY-15-C1/`；P1 专项 `scripts/smoke_v42_fomc_c1_p1_r14.js`。

### ABSTAIN 根信任关闭：verifyBundleTrust C/E 组恒跑

`lib/fomc_evidence_draft.js` 的 `verifyBundleTrust` 调整（维持路线 A：内存验证，零 fs；不 require `fomc_document_bundle.js`，本地镜像不变）：

- **检查 C 恒跑**（原仅 READY）：current/prior `source_ref` 必须存在且为官方域（`isTrustedOfficialDomain` allowlist），否则 `current_source_ref_missing`/`prior_source_ref_missing`/`source_ref_not_official`；
- **检查 E 恒跑**（原仅 READY）：`evidence_scope === "official"`、current/prior 文档必须携带 A2 `verified_provenance + proof` 且经固定 Ed25519 公钥验签 + 绑定 `text_sha256`/`event_id`，否则 `evidence_scope_not_official`/`current_a2_proof_required`/`prior_a2_proof_required`/`current_document_binding_mismatch`/`prior_document_binding_mismatch`；
- **检查 E2（仅 READY 声称时）**：`fact_source` 权威校验（`kind=official` + `verified:true`）拆出独立分组——ABSTAIN 无决定句式，`fact_source` 不承载权威声称，仅 READY 时要求 `fact_source_not_official`；
- 检查 A（根哈希）/ B（文档身份+正文 hash + event_id 绑定）/ D（事前冻结声明不可信）/ F（research_note replay）保持恒跑，任一失败 → `violations.push("auto_draft_baseline_untrusted")`，不进入人工修订比较。

### 反例覆盖（对应 Codex R16 最小关闭 + Human 指令）

`scripts/smoke_v42_fomc_c1_p1_r14.js` 新增 P1-3b（3 断言）：用 A2 testkit `makeGenuineBundle` 构造 **trusted ABSTAIN**——官方语句含 "target range for the federal funds rate" 段（过官方解析器）但无 "X to Y percent" 区间、无委员会决定句式、无投票计数 → `fomc_decision_facts.extractDecisionFacts` 返回 null → ex_post `ABSTAIN`，同时官方解析器恒附 truthy `decision_facts` → `evidence_scope="official"`：

- `P1-3b_abstain_bundle_shape`：真证 ABSTAIN bundle `evidence_scope="official"`、`synthetic=false`、ex_post `ABSTAIN`；
- `P1-3b_untrusted_abstain_rejected`：同一 bundle 但调用方不提供已验证文档 → `auto_draft_baseline_untrusted` + `current_a2_proof_required` + `prior_a2_proof_required`（Codex R16 要求的原样反例：自洽 news/cache bundle、无 proof、`ex_post=ABSTAIN`、replay 与 canonical SHA 均一致，仍必须拒绝人工修订）；
- `P1-3b_trusted_abstain_ok`：提供 `verifiedCurrent`/`verifiedPrior`（A2 验签）+ `evidence_scope=official` → 人工修订通过，violations 为空（不误伤 trusted ABSTAIN 只读/人工记录）。

`scripts/smoke_v42_fomc_c1_gate4.js` O 块改用 A2 真证 bundle 调 `validateHumanRevision`（`verifiedCurrent`/`verifiedPrior`），新增 `O0_synthetic_untrusted_rejected`：合成 bundle（无 A2 proof / `evidence_scope="unverified"`）→ `auto_draft_baseline_untrusted` + `evidence_scope_not_official`，只读展示仍可用但不可签收。

### 五子机制结果（维持 R16 通过项，ABSTAIN 根信任关闭后全部保留）

1. `C_INFERENCE_TRACEABILITY` **PASS**；
2. `C_EX_ANTE_CONSTRAINT` **PASS**；
3. `C_EX_POST_ANCHOR` **PASS**；
4. `C_MODEL_FREE_RENDER` **PASS** —— `factsOnlyView` 只读展示路径不受 verifyBundleTrust 影响（合成 bundle 仍可只读渲染事实与差异）；
5. `C_DRAFT_ISOLATION` **PASS** —— 自动稿与人工修订分域；人工修订的 canonical 基线一律来自先经根信任验证的 bundle（READY 与 ABSTAIN 同等要求）。

### 正式数据 / 既有文件前后 hash

- 本轮改动：`lib/fomc_evidence_draft.js`（C/E 恒跑 + E/E2 拆分 + 三处注释）、`scripts/smoke_v42_fomc_c1_p1_r14.js`（P1-3b 三断言）、`scripts/smoke_v42_fomc_c1_gate4.js`（O 块真证 bundle + O0）。
- 正式 `data/` 树 hash：`ae7447d3fb68b467fcde59fe4d2e24cabbb808063de0bbf82b7f200fd4e2818d`（178 文件），build 前后零变化；`bundle_sha256` 幂等。

### 回归

- P1 专项 **54/54 PASS**（51 + P1-3b 3）；Gate 4 **39/39 PASS**（38 + O0）；
- A1 `smoke_v42_fomc_a1.js` **106/106**；A2 `smoke_v42_fomc_a2.js` **PASS**；A4 `smoke_v42_fomc_a4.js` **25/25**；B1 全量 **136/136 PASS**（64+33+20+14+5）；C1 Gate1/Gate2/Gate3 **47/32/32 PASS**。

### 回滚实测

- 恢复到 R16 业务 tip `71b9440`：`lib/fomc_evidence_draft.js`/`scripts/smoke_v42_fomc_c1_p1_r14.js`/`scripts/smoke_v42_fomc_c1_gate4.js` 回退 → 可完整回退；正式 `data/` 不受影响。

### 未覆盖项与残余风险

- fixtures 为合成 FOMC 声明；真实官方文本的超长 excerpt 截断、跨页重排密度未全量核对；
- 事前内容只进入研究记录，尚未接线收尾卡/最终简报（Batch D 接线，本环不实现）；
- 本环无受控持久化冻结层：`RETROSPECTIVE_EX_ANTE_TEMPLATE` 是历史回放模板，真实"事件前已冻结"入口需另环在受控持久化层落地；
- READY 与 ABSTAIN 路径均需调用方供 A2 已验证文档（bundle 不携带 proof）：正式接线时由 A2 受控 store 供档，本环保持纯函数；
- 自动稿未经 Human 接入前不得进入正式简报/收尾卡；本环不声明 `EVENT_POLICY_INTELLIGENCE_V1`。

未声明 `EVENT_POLICY_INTELLIGENCE_V1`、`POLICY_INFERENCE_TRACEABILITY_C1` 或任何研究/数据质量/发布验收名。


Cursor 完成报告（revision 34 · 置 `pending_review / codex` · R16 关闭 Codex R15 P1-3 bundle 根信任）

- 基线：R15 C1 业务 tip `7d6b692`（Codex R15 聚焦复审目标 `d510636`，`codex_r15_p1_3_focused_review.md` 判 **P1-3 STILL BLOCKED**：`validateHumanRevision` 把调用方传入的任意 `bundle` 交给 `evidenceDraftFromBundle` 重新派生 canonical 基线，未建立根信任）。本轮业务 tip `71b9440` 仅关闭 P1-3；未改正式 `data/`、未改既有生产入口语义。
- 验收证据：`logs/acceptance/PRD-EVENT-POLICY-15-C1/`；P1 专项 `scripts/smoke_v42_fomc_c1_p1_r14.js`。

### P1-3 根信任：派生基线前先验证 bundle 根身份（verifyBundleTrust）

`validateHumanRevision` 在调用 `evidenceDraftFromBundle` 派生 canonical 自动稿前，先执行 `verifyBundleTrust(bundle, opts)` 六组检查（路线 A：内存验证，零 fs；不走“从受控 store 内部加载”路线 B，保持 `fomc_evidence_draft.js` 纯函数、bundle 契约与 data/ 零变化）：

- 检查 A 根哈希：`canonicalBundleSha256(bundle) === bundle.bundle_sha256`（删除 bundle_sha256 后稳定序列化重算），不一致 → `bundle_root_hash_mismatch`；
- 检查 B 文档身份+正文 hash：current/prior `text_sha256` 与段落重新派生正文 hash 一致；current event_id 绑定 bundle event_id（prior 是上一场会议，按设计不同）；缺失 → `current_document_required`/`prior_document_required`，篡改 → `current_document_hash_tampered`/`prior_document_hash_tampered`/`current_document_wrong_event`；
- 检查 C（仅 `research_note.ex_post.status === READY` 时）：current/prior `source_ref` 必须存在且为官方域（`isTrustedOfficialDomain` allowlist，`federalreserve.gov` 固定镜像），否则 `current_source_ref_missing`/`prior_source_ref_missing`/`source_ref_not_official`；
- 检查 D：事前冻结声明不可信（本环无受控持久化冻结层，`ex_ante_freeze_claim_untrusted`），与 P1-1 取消 READY 一致；
- 检查 E（仅 ex_post READY 时）：`evidence_scope === "official"`、current/prior 文档必须携带 A2 `verified_provenance + proof` 且经固定 Ed25519 公钥验签（`verifyVerifiedProof(documentProvenanceFields(doc), proof)`）+ 绑定 `text_sha256`/`event_id`，否则 `evidence_scope_not_official`/`current_a2_proof_required`/`prior_a2_proof_required`/`current_document_binding_mismatch`/`prior_document_binding_mismatch`/`fact_source_not_official`；
- 检查 F research_note replay：从 bundle 自身段落/source_refs/text_changes/missing_fields/conflicts 重新派生 `buildResearchNote`，必须与存储的 `research_note` 字节一致（`stableStringify` 比较），不一致 → `research_note_replay_mismatch`——关闭“自洽伪造 bundle + 重算 bundle_sha256”漏洞（无 A2 私钥的攻击者无法伪造与真实段落一致的 READY research_note）；
- 任一验证缺失/失败 → `violations.push("auto_draft_baseline_untrusted")` + 具体违规码，不进入人工修订比较。

新增导出：`verifyBundleTrust`、`canonicalBundleSha256`。循环依赖约束下 `fomc_evidence_draft.js` 不 require `fomc_document_bundle.js`，本地镜像 `FIXED_OFFICIAL_DOMAINS`/`normalizeDomain`/`isTrustedOfficialDomain`/`canonicalBundleSha256`/`localDocIsVerified`（基于 `documentProvenanceFields` + `verifyVerifiedProof` + `VERIFIED_ADAPTER_ID`）。

反例（Codex R15 P1-3 原样复现 + 加固，`scripts/smoke_v42_fomc_c1_p1_r14.js` 新增 11 断言）：

- `P1-3_fake_bundle_root_untrusted`（`bundle_sha256="attacker-bundle"` + news/cache source refs + 伪造 ex_ante READY/pre_event_frozen + 伪造 ex_post READY/HOLD official fact_source + 无 A2 proof）→ `auto_draft_baseline_untrusted` + `bundle_root_hash_mismatch` + `source_ref_not_official` + `ex_ante_freeze_claim_untrusted` + `current_a2_proof_required` + `research_note_replay_mismatch`；
- `P1-3_self_consistent_fake_still_rejected`（克隆真实 bundle、仅伪造 ex_post READY、重算 bundle_sha256、无 proofs）→ `current_a2_proof_required`（检查 A/F 自洽也过不了检查 E）；
- `P1-3_genuine_requires_proof`（真实 bundle 但调用方不提供已验证文档）→ fail-closed `current_a2_proof_required`；
- `P1-3_replay_tampered_rejected`（真实 bundle + 已验证文档 + 篡改 decision_facts + 重算 bundle_sha256）→ `research_note_replay_mismatch`；
- `P1-3_trusted_bundle_compliant_ok`（A2 testkit `makeGenuineBundle` 真证路径 → ok）。

**MEDIUM 耦合说明（有意选择）**：READY 路径要求调用方提供 A2 签名文档（`verifiedCurrent`/`verifiedPrior`），这些文档**无法从 bundle 本身恢复**（bundle 文档不携带 `verified_provenance/proof`）。这是预期的 fail-closed 设计——对应 Codex R15 裁决“从受控 store 内部加载”的路线 A 内存等价：真正根信任仍在 A1/A2 store 校验，`validateHumanRevision` 只接受调用方把已验证文档与 bundle 一并呈交，缺证 → 拒。正式入口接线时由 A2 受控 store 供档，不暴露裸 bundle 路径。

### 五子机制结果（维持 R15 通过项，P1-3 关闭后全部保留）

1. `C_INFERENCE_TRACEABILITY` **PASS** —— 全量遍历研究记录：每项推断带 `support[]`/`counter_evidence[]`/`gaps[]`/`monitoring_conditions[]`/`method_version`；SCENARIO 契约经 `assertInferenceContract` 强制；HYPOTHESIS `[null]`/空白拒绝；数组字符串值级扫描。
2. `C_EX_ANTE_CONSTRAINT` **PASS** —— 事前只派生自 prior；缺证据 → ABSTAIN；无受控冻结 → 一律历史回放模板（pre_event_frozen 恒 false），自报冻结拒绝（freeze_claim_rejected）。
3. `C_EX_POST_ANCHOR` **PASS** —— 实际决定/逐项文本变化/来源与数据缺口仅来自正式文本 + A2 proof 验签；无 proof → ABSTAIN；决策事实纯文本派生，可定位 `source_ref + paragraph_id`。
4. `C_MODEL_FREE_RENDER` **PASS** —— `factsOnlyView` 无模型直接渲染事实与差异；视图无模型输出键；allowlist 拒绝 model/news/cache 别名。
5. `C_DRAFT_ISOLATION` **PASS** —— 自动稿与人工修订分域；校验器从可信 bundle（先经 verifyBundleTrust 根信任验证）重新派生 canonical 基线；伪 autoDraft/自签冻结/伪 bundle 拒绝；人工仅 `human_*` 命名空间。

### 反例覆盖（对应 Codex R15 `codex_r15_p1_3_focused_review.md` P1-3）

- 伪 bundle（`bundle_sha256` 不符 + news/cache source refs + 伪造 READY 事前/事后 + official fact_source + 无 A2 proof）→ `auto_draft_baseline_untrusted`；
- 自洽伪造 bundle（重算 bundle_sha256 也无法通过 A2 证据身份检查）→ `current_a2_proof_required`；
- 真 bundle 但缺已验证文档 → fail-closed；
- 真 bundle + 已验证文档 + 篡改派生字段 + 重算 bundle_sha256 → `research_note_replay_mismatch`；
- 真证路径 → ok（不误伤）。

### 正式数据 / 既有文件前后 hash

- 本轮改动：`lib/fomc_evidence_draft.js`（verifyBundleTrust 六组检查 + validateHumanRevision 0a 接入 + 导出）、`scripts/smoke_v42_fomc_c1_p1_r14.js`（P1-3 负向测试扩展）。
- 正式 `data/` 树 hash：`f055a2db145d567f0d3b0f8d031c7ce340f8bbcf05586fc84542f20dc61fe104`，build 前后零变化；`bundle_sha256` 幂等（含 research_note / A2 proof 路径）。

### 回归

- C1 四门 + P1 专项：**47/32/32/38 + 51 = 200 PASS**；
- A1 `smoke_v42_fomc_a1.js` **106/106**；A2 `smoke_v42_fomc_a2.js` **PASS**（152 断言） + walkthrough **37 PASS**；A4 `smoke_v42_fomc_a4.js` **25/25**；B1 全量 **136/136 PASS**（64+33+20+14+5）；合计 **619 PASS / 0 FAIL**。

### 回滚实测

- 恢复到 R15 业务 tip `7d6b692`：`lib/fomc_evidence_draft.js`/`scripts/smoke_v42_fomc_c1_p1_r14.js` 回退 → 可完整回退；正式 `data/` 不受影响。

### 未覆盖项与残余风险

- fixtures 为合成 FOMC 声明；真实官方文本的超长 excerpt 截断、跨页重排密度未全量核对；
- 事前内容只进入研究记录，尚未接线收尾卡/最终简报（Batch D 接线，本环不实现）；
- 本环无受控持久化冻结层：`RETROSPECTIVE_EX_ANTE_TEMPLATE` 是历史回放模板，真实“事件前已冻结”入口需另环在受控持久化层落地；
- READY 路径需调用方供 A2 已验证文档（bundle 不携带 proof）：正式接线时由 A2 受控 store 供档，本环保持纯函数；
- 自动稿未经 Human 接入前不得进入正式简报/收尾卡；本环不声明 `EVENT_POLICY_INTELLIGENCE_V1`。

未声明 `EVENT_POLICY_INTELLIGENCE_V1`、`POLICY_INFERENCE_TRACEABILITY_C1` 或任何研究/数据质量/发布验收名。


Cursor 完成报告（revision 31 · 置 `pending_review / codex` · R15 关闭 Codex R14 四组 P1）

- 基线：R14 C1 业务 tip `57d6aab`（Codex R14 聚焦复审目标 `dec1be9` / `codex_r14_p1_focused_review.md` 判 **CHANGES_REQUIRED**：四组 P1 均根因于“调用方自报信息被当作不可伪造权威绑定”）。本轮业务 tip `7d6b692` 仅关闭该四组 P1 并补可复现反例；未改正式 `data/`、未改既有生产入口语义。
- 验收证据：`logs/acceptance/PRD-EVENT-POLICY-15-C1/`；P1 专项 `scripts/smoke_v42_fomc_c1_p1_r14.js`。

### P1-1 事前冻结：取消 READY，自报冻结不再有权威

`buildExAntePlan` 完全取消 READY / pre_event_frozen 能力（R14 最小关闭路线二：取消 READY 只保留 `RETROSPECTIVE_EX_ANTE_TEMPLATE`）：

- 本环无受控持久化冻结层：不再接收/信任调用方自报的 `freezeHash`/`generatedAt`/`currentPublishedAt`；
- 有 prior → 一律 `RETROSPECTIVE_EX_ANTE_TEMPLATE`（`pre_event_frozen` 恒 false）；无 prior → `ABSTAIN`；
- 调用方若仍传入 `generatedAt`/`freezeHash`（声称“事件前已冻结”）→ 该声称无法验证，显式记入 `abstain_conditions.freeze_claim_rejected`，绝不产出 READY；
- 已移除 `EX_ANTE_READY` 常量、`computeExAnteFreezeSha256` 与 `freeze` 字段；`ex_ante_reference` 恒 null（事后永不引用不存在的冻结快照）。

反例（Codex R14 P1-1 原样复现）：`P1-1_posthoc_never_ready`（generatedAt=2025-01-01/currentPublishedAt=2026-01-01/自算 hash → 仍 RETROSPECTIVE_EX_ANTE_TEMPLATE + freeze_claim_rejected）、`P1-1_any_claim_rejected`、`P1-1_no_freeze_field`、`P1-1_no_prior_abstain`。

### P1-2 事实源权威：只消费 A2 proof，自报 {kind,verified,source_ref} 不再是权威

`anchorExPost` 不再接受调用方自报的事实源（R14 最小关闭）：

- `verifiedProofAuthority` 只消费 A2 受控来源适配器产出的 `verifiedDocument`（携带 `verified_provenance + proof`）：`verifyVerifiedProof` 固定公钥验签；
- 验签之外必须把当前段落内容绑定到 proof 的 `document_hash`（官方证明 + 非官方内容混搭 → `fact_source_proof_document_mismatch` ABSTAIN）；
- `source_ref` 派生自证明身份（`source_version || final_url`），不允许调用方自报；调用方提供的 `currentSourceRef` 必须与证明身份一致（不一致 → `fact_source_ref_mismatch` ABSTAIN）；
- 直接辅助入口无有效 proof → `fact_source_proof_required` ABSTAIN；`decision_facts` 纯文本派生，绝不继承输入透传值。

反例（Codex R14 P1-2 原样复现）：`P1-2_news_cannot_self_attest`（官方句式 + `currentSourceRef="news"` 无 proof → ABSTAIN，证据引用不写 source_ref=news）、`P1-2_content_proof_mismatch`、`P1-2_ref_mismatch_abstain`、`P1-2_tampered_proof_abstain`；真证路径 `P1-2_genuine_ready`（A2 验签 → READY + HOLD 4–4.25，fact_source 派生自证明身份，adapter=fomc_official_source_a2）。

### P1-3 人工修订隔离：校验器从可信 bundle 重新派生 canonical 基线

`validateHumanRevision` 不再接受调用方自带的权威基线（R14 最小关闭）：

- 必须接收可信 `bundle`（缺 → `auto_draft_baseline_required`），并经 `evidenceDraftFromBundle` 重新派生 canonical auto draft（`meta.freeze_sha256` 绑定 bundle_sha256 + source + ex_ante + ex_post）；
- 调用方若同时传入 `autoDraft`，必须与 canonical `stableStringify` 完全一致，否则 `auto_draft_baseline_mismatch`（即使指纹自洽）；真正的根信任在 A1/A2 store 的 bundle 校验；
- 自动域（meta/source/ex_ante/ex_post）完整冻结：人工不得改 bundle_sha256/method_version/source refs/正式时间/正式 hash/status/missing_fields/conflicts/决策事实/逐项文本变化；人工仅 `human_*` 顶层键。

反例（Codex R14 P1-3 原样复现）：`P1-3_self_signed_freeze_rejected`（伪 autoDraft + 自算冻结指纹 → `auto_draft_baseline_mismatch`）、`P1-3_omit_auto_draft_still_rejects`、`P1-3_bundle_required`、`P1-3_*_bound`（逐字段篡改检出）、`P1-3_compliant_revision_ok`。

### P1-4 推断语义：数组内字符串扫描 + trim/元素类型 + SCENARIO 空反证单一语义真相源

（R14 最小关闭：递归扫描覆盖数组内字符串 / 非空字段验证 trim 与元素类型 / SCENARIO 允许“空反证 + 显式 gap”并与生成器单一语义真相源）

- `assertNoForbiddenInferenceFields` 递归扫描覆盖数组内字符串元素（`{notes:["hawkish","stocks will rise"]}` → 拒绝），不再跳过；
- `assertInferenceContract` 校验 trim 后非空与元素类型/证据定位：HYPOTHESIS 的 `[null]` 数组 + 空白命题/窗口/判据 → `proposition_required`/`observation_window_required`/`*_element_not_locatable`/`*_element_invalid`/`method_version_required`；
- SCENARIO 契约允许“空反证 + 显式 gap”：`counter_evidence` 可为空仅当 `gaps` 显式携带 `EMPTY_COUNTER_EVIDENCE_GAP_MARKER`（生成器 `buildExAnteContent` 与校验器 `assertInferenceContract` 共用同一常量，单一语义真相源），否则 `counter_evidence_required_nonempty`；
- SCENARIO 不得携带 `falsifiable_conditions`/`proposition`（`scenario_must_not_claim_*`）；方向中立“可能变化”不冒充可证伪 HYPOTHESIS。

反例（Codex R14 P1-4 三组原样复现）：`P1-4_array_string_hawkish_rejected`、`P1-4_array_string_market_rejected`、`P1-4_array_clean_passes`、`P1-4_null_blank_hypothesis_rejected`、`P1-4_scenario_empty_counter_explicit_gap`、`P1-4_scenario_empty_counter_no_gap_rejected`、`P1-4_generator_empty_counter_marker`、`P1-4_generator_empty_counter_passes_contract`（生成器空反证项通过校验器契约）。

### 五子机制结果（维持 R13 通过项，P1 关闭后全部保留）

1. `C_INFERENCE_TRACEABILITY` **PASS** —— 全量遍历研究记录：每项推断带 `support[]`/`counter_evidence[]`/`gaps[]`/`monitoring_conditions[]`/`method_version`；SCENARIO 契约经 `assertInferenceContract` 强制；HYPOTHESIS `[null]`/空白拒绝；数组字符串值级扫描。
2. `C_EX_ANTE_CONSTRAINT` **PASS** —— 事前只派生自 prior；缺证据 → ABSTAIN；无受控冻结 → 一律历史回放模板（pre_event_frozen 恒 false），自报冻结拒绝（freeze_claim_rejected）。
3. `C_EX_POST_ANCHOR` **PASS** —— 实际决定/逐项文本变化/来源与数据缺口仅来自正式文本 + A2 proof 验签；无 proof → ABSTAIN；决策事实纯文本派生，可定位 `source_ref + paragraph_id`。
4. `C_MODEL_FREE_RENDER` **PASS** —— `factsOnlyView` 无模型直接渲染事实与差异；视图无模型输出键；allowlist 拒绝 model/news/cache 别名。
5. `C_DRAFT_ISOLATION` **PASS** —— 自动稿与人工修订分域；校验器从可信 bundle 重新派生 canonical 基线；伪 autoDraft/自签冻结拒绝；人工仅 `human_*` 命名空间。

### 反例覆盖（对应 Codex R14 `codex_r14_p1_focused_review.md` 四组 P1）

- 事后自签冻结 + 回填时间 → 不得 READY（P1-1_posthoc_never_ready）；
- 官方句式 + `{kind:"official",verified:true,source_ref:"news"}` 无 proof → ABSTAIN（P1-2_news_cannot_self_attest）；
- 伪 autoDraft + 自算冻结指纹 → `auto_draft_baseline_mismatch`（P1-3_self_signed_freeze_rejected）；
- `{notes:["hawkish","stocks will rise"]}` → 拒绝；HYPOTHESIS `[null]` + 空白 → 拒绝；SCENARIO 空反证无标记 → 拒绝（P1-4_*）。

### 正式数据 / 既有文件前后 hash

- 本轮改动：`lib/fomc_evidence_draft.js`（四组 P1 关闭）、`lib/fomc_document_bundle.js`（`buildResearchNote` 接线 `verifiedDocument: verified ? current : null`）、`scripts/smoke_v42_fomc_c1_gate{1,2,3,4}.js`（语义更新）、`scripts/smoke_v42_fomc_c1_p1_r14.js`（P1 专项反例重写）。
- 正式 `data/` 树 hash：`f055a2db145d567f0d3b0f8d031c7ce340f8bbcf05586fc84542f20dc61fe104`，build 前后零变化；`bundle_sha256` 幂等（含 research_note / A2 proof 路径）。

### 回归

- C1 四门 + P1 专项：**47/32/32/38 + 40 = 189 PASS**；
- A1 `smoke_v42_fomc_a1.js` **106/106**；A2 `smoke_v42_fomc_a2.js` **PASS**（121 断言） + walkthrough **37 PASS**；A4 `smoke_v42_fomc_a4.js` **25/25**；B1 全量 **136/136 PASS**（64+33+20+14+5）。

### 回滚实测

- 恢复到 R14 业务 tip `57d6aab`：`lib/fomc_evidence_draft.js`/`lib/fomc_document_bundle.js`/C1 smoke 回退 → 可完整回退；正式 `data/` 不受影响。

### 未覆盖项与残余风险

- fixtures 为合成 FOMC 声明；真实官方文本的超长 excerpt 截断、跨页重排密度未全量核对；
- 事前内容只进入研究记录，尚未接线收尾卡/最终简报（Batch D 接线，本环不实现）；
- 本环无受控持久化冻结层：`RETROSPECTIVE_EX_ANTE_TEMPLATE` 是历史回放模板，真实“事件前已冻结”入口需另环在受控持久化层落地；
- 自动稿未经 Human 接入前不得进入正式简报/收尾卡；本环不声明 `EVENT_POLICY_INTELLIGENCE_V1`。

未声明 `EVENT_POLICY_INTELLIGENCE_V1`、`POLICY_INFERENCE_TRACEABILITY_C1` 或任何研究/数据质量/发布验收名。


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
