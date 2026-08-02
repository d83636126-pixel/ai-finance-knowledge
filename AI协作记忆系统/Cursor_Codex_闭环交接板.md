---
type: Cursor_Codex闭环交接板
schema_version: 2
tags: [AI协作, Cursor, Codex, V4.2, B1, FOMC]
created: 2026-08-01
updated: '2026-08-02'
project: financial-alert-system
loop_id: PRD-EVENT-POLICY-15-B1
acceptance: POLICY_TEXT_DIFF_B1
revision: 20
turn: 0
next_actor: 'human'
status: 'done'
max_turns: 3
last_writer: 'codex'
written_at: '2026-08-02T09:52:34.481Z'
lease_owner: ''
lease_actor: ''
lease_expires_at: ''
code_root: 'F:\financial-alert-system'
vault_note: AI协作记忆系统/Cursor_Codex_闭环交接板.md
repo_mirror: docs/ai-collab/Cursor_Codex_闭环交接板.md
---

# Cursor ↔ Codex 闭环交接板：V4.2 Batch B

> 当前口令：**执行Cursor_Codex闭环交接板当前指令 · V4.2 B1 确定性文本差异与政策事实**

## 1. 当前裁决

- V4.2 A1（FOMC 文本证据契约）已 PASS 归档；V4.2 A2（正式来源适配与后台刷新）经 Codex R10 最终聚焦复审 **PASS**，交接板转 `done / human`（revision 11 / turn 2）。
- Human（2026-08-02）正式确认 **`POLICY_SOURCE_ACQUISITION_A2`** 完成并验收，并授权另开 **Batch B 新环**（确定性文本差异与政策事实）。
- **B1 环已关闭**：Codex R2 聚焦复审 **PASS**（`codex_r2_final_review.md`，复审 tip `2d18ab6`），交接板转 `done / human`（revision 20）；Human（2026-08-02）正式确认 **`POLICY_TEXT_DIFF_B1`** 完成并验收。
- 本环不做政策倾向/鹰鸽解释、不把文本差异压成不可解释的单一分数、不接新外部网络、不改既有生产入口语义；不声明 `EVENT_POLICY_INTELLIGENCE_V1`。

## 2. 基线、授权与边界

| 项 | 值 |
|---|---|
| stage | `V4.2 B1 确定性文本差异与政策事实` |
| B1 计划 | `docs/ai-collab/产品发展执行计划_V4.2_B_确定性文本差异与政策事实_2026-08-02.md` |
| HEAD | `2d18ab6`（B1 R2 P1 关闭业务 tip） |
| 开环基线 | `50b88aa`（A2 业务 tip） |
| A1 / A2 业务 tip | `b1abce5` / `50b88aa` |
| change class | `C2` |
| review | `R2`（聚焦） |
| status / next_actor | `done / human`（2026-08-02 确认 `POLICY_TEXT_DIFF_B1`） |
| 授权范围 | 沿用 V4.2 主计划与 A2 已授权面；本环为纯派生计算，无新外部网络/正式写入/后台调度需求 |
| 回滚 | 删除未接入正式入口的 B1 候选模块与 smoke，恢复到 `50b88aa`；不迁移/删除正式产品数据 |

### 受保护不变量

1. 逐段差异必须确定、可复算、可定位到 `source_ref + paragraph_id`（`PolicyTextChange` 契约）。
2. 文本相似度只用于定位变化，不自动赋予"鹰派/鸽派"结论；政策倾向判断必须列出支持、反证、缺口和可证伪条件。
3. 目标利率区间、决定方向、投票事实仅在正式声明明确提供时提取；缺证据不得猜测或伪造。
4. 浏览器缓存、模型文本、新闻摘要不得成为权威事实源。
5. 正式 `data/` 既有文件、V4.0/V4.1 语义、Top 3、研究信用和 AI 草稿策略保持不变；既有 bundle 版本不回写覆盖。
6. 任一正式门槛失败，总结论不得 PASS，失败必须可见。
7. `EVENT_POLICY_INTELLIGENCE_V1` 与本环隔离，本环不声明总验收。

## 3. Cursor 当前执行指令

### 3.1 业务目标

用户查看 FOMC 事件证据时，系统能把当前正式声明相对紧邻上一期的**逐段文本差异**（新增/删除/修改/未变）和**明确政策事实**（目标利率区间、决定方向、可核验投票、主题定位）以确定、可复算、可定位的方式并入既有 `FomcDocumentBundle`，且不产生不可解释的单一分数或鹰鸽结论。

### 3.2 必须按顺序执行

#### Gate 1：逐段文本差异引擎

- 新增确定性逐段差异计算：对 `current_document.paragraphs[]` 与 `prior_document.paragraphs[]` 产出 `text_changes[]`，每项含 `topic`、`change_kind = ADDED | REMOVED | MODIFIED | UNCHANGED`、`prior_paragraph_id`、`current_paragraph_id`、`prior_excerpt`、`current_excerpt`、`method_version`、`evidence_refs[]`、`interpretation_status = FACT_ONLY | HYPOTHESIS | ABSTAIN`；
- 同输入、同方法版本 → 同输出（确定、可复算）；
- 方法版本必须记录（`method_version`），算法升级须可复算旧版结果；
- Gate 1 未通过，不得进入决策事实提取。

#### Gate 2：明确决策事实提取

- 从正式声明文本提取 `decision_facts`：`target_range_lower`、`target_range_upper`、`action`、`vote`；
- 仅在正式声明**明确提供**时提取；未明确提供 → 相应字段缺失并记入 `missing_fields[]`，不得猜测或伪造；
- 每个事实可定位到 `source_ref + paragraph_id`（`evidence_refs[]`）。

#### Gate 3：主题定位

- 对通胀、就业、经济活动等主题的文本变化做段落/关键词定位（`topic` 分类）；
- 主题归属必须来自正式文本可定位证据，非模板硬编码判定；缺证据 → `ABSTAIN`。

#### Gate 4：解释边界与数据保护

- `interpretation_status` 三态落地：`FACT_ONLY`（文本本身）、`HYPOTHESIS`（带支持/反证/缺口/可证伪条件）、`ABSTAIN`（缺证据）；禁止把文本差异压缩成不可解释的单一分数；
- 不新增"鹰派/鸽派"自动结论，不把文本变化直接压成市场因果；
- 正式 `data/` 与既有入口零变化（B1 为派生计算，不应改写已存 bundle 字节）；若有版本化扩展须写前清单 + 原子提交 + 幂等；
- 复跑 A1/A2 回归确保不回归。

### 3.3 允许文件面

- 新增 `lib/fomc_text_diff.js`、`lib/fomc_decision_facts.js`（或职责等价文件）与 B1 smoke；
- 在既有 `FomcDocumentBundle` 契约内补充 `text_changes[]` / `decision_facts` 派生计算，不破坏 A1/A2 契约；
- `package.json` 仅限 B1 命令；
- 正式 `data/` 仅运行时版本化扩展（若需要），不提交运行数据；
- 不修改无关业务、前端布局、排序、阈值或模型政策。

### 3.4 验收子机制

1. `B_TEXT_DIFF` —— 逐段差异确定、可复算、可定位
2. `B_DECISION_FACTS` —— 目标利率区间、决定方向、投票事实（仅正式声明明确提供）
3. `B_TOPIC_LOCATION` —— 通胀/就业/经济活动主题定位
4. `B_INTERPRETATION_BOUNDARY` —— 三态解释、禁止单一分数、禁止鹰鸽结论
5. `B_DATA_PROTECTION` —— 正式数据/既有文件零变化、生产入口不改、回归不破坏

每项分别给出 PASS/FAIL/ABSTAIN、命令、样本、时间、hash 和失败证据。任一正式门槛失败，总结论不得 PASS。

### 3.5 必须覆盖的反例

- 同输入不同 method_version 或不同输入同输出（不变量破坏）；
- 空 paragraphs、段落 ID 缺失、excerpt 截断、跨页段落重排（MOVE 误判为 MODIFIED/REMOVED+ADDED）；
- 目标利率区间/投票在声明中未明确提供 → 不得伪造；
- 文本措辞变化 → 不得自动得出鹰/鸽结论；
- 模型文本、新闻摘要、浏览器缓存尝试作为事实源 → 拒绝；
- 既有 bundle 字节被回写/覆盖 → 检出并 fail。

### 3.6 完成与交接

完成后更新本板第 4 节，提交业务 diff，置 `pending_review / codex`。报告必须列明：Gate 顺序执行证据、五子机制结果、反例覆盖、正式数据/既有文件前后 hash、回滚实测、未覆盖项与残余风险。

不得在 Cursor 回合自行声明 `EVENT_POLICY_INTELLIGENCE_V1` 或任何研究/数据质量/发布验收名。

## 4. Cursor 完成报告

Cursor 完成报告（revision 17 → 18 · 置 `pending_review / codex` · B1 R2 四组 P1 关闭）

- 基线：开环 `50b88aa`（A2 业务 tip）。本业务 tip `2d18ab6` 仅关闭 Codex R2 要求的最小关闭项及对应负向测试；未改正式 `data/`、未改既有生产入口语义。
- 复审目标：`2d18ab6`（四组 P1 修复 commit）。交接板 HEAD 与执行指针 `code_tip` 已统一绑定该 tip（P1-4 关闭）。

### Gate 顺序执行证据（TDD RED→GREEN，逐门推进，未跨门）

| Gate | 交付 | 冒烟 | 断言 |
|---|---|---|---|
| 1 逐段文本差异引擎 | `lib/fomc_text_diff.js`（P1-1 SHA 独立复算） | `scripts/smoke_v42_fomc_b1.js` | 64/64 PASS |
| 2 明确决策事实提取 | `lib/fomc_decision_facts.js`（P1-2 单段匹配/动作收紧/证据身份） | `scripts/smoke_v42_fomc_b1_gate2.js` | 33/33 PASS |
| 3 主题定位 | `classifyTopic` + `TOPIC_RULES`（P1-3 词/短语边界 + MODIFIED 双侧证据 + 多主题保留） | `scripts/smoke_v42_fomc_b1_gate3.js` | 20/20 PASS |
| 4 解释边界与数据保护 | `interpretation_status` 三态 + `derived_decision_facts` | `scripts/smoke_v42_fomc_b1_gate4.js` | 14/14 PASS |
| P1-4 板绑定 | `scripts/ai_collab_board.js`（HEAD/code_tip 绑定 + 交接前检查） | `scripts/smoke_v42_fomc_b1_p14_board_check.js` | 5/5 PASS |

- 五冒烟合计 **136 PASS / 0 FAIL**（64 + 33 + 20 + 14 + 5）。
- 每门先写反例见 RED（断言失败），再实现至 GREEN；P1-4 交接前检查接线验证见 `smoke_v42_fomc_b1_p14_board_check.js`（Q1-Q5）。

### 五子机制结果

1. `B_TEXT_DIFF` **PASS** —— P1-1 关闭：`normEntry()` 始终从规范化文本独立计算 SHA；输入 SHA 存在则校验，不一致置 `sha_mismatch` + 显式 warning，且排除于 UNCHANGED 对齐；补“同 SHA 不同文本”“同文本输入 SHA 错误”反例（C7a-C7d）。同输入同 method_version 字节级同输出；跨页重排不误判（reorder_notes）。
2. `B_DECISION_FACTS` **PASS** —— P1-2 关闭：各事实必须在单一正式段落内完成匹配并返回该次匹配段落；动作仅接受明确委员会决定句式（participants/history/discussion 不得当决定）；段落缺 `id/sha256` 或 sha256 不一致 → 该事实 ABSTAIN；区间校验有限数 + lower <= upper + 合理范围 0..20%；补 participants 伪动作、跨段拼接、身份缺失/伪造、lower>upper、越界区间反例（P1_2a-P1_2f）。
3. `B_TOPIC_LOCATION` **PASS** —— P1-3 关闭：词/短语边界匹配（priceless 不得命中 price、laboratory 不得命中 labor）；MODIFIED/UNCHANGED 审视 prior+current 双侧并记录 `topic_evidence` 来源侧；多主题保留 `topics[]`，`topic` 取优先级首主题。补 priceless/laboratory/prior 侧证据/多主题反例（P1_3a-P1_3f）。
4. `B_INTERPRETATION_BOUNDARY` **PASS** —— `FACT_ONLY / HYPOTHESIS / ABSTAIN` 三态枚举不变；本轮差异项 `FACT_ONLY`；顶层与逐项无 score/similarity/confidence/hawk/dove/market_* 字段。
5. `B_DATA_PROTECTION` **PASS** —— 正式 `data/` 178 文件树 hash `f055a2db…fe104` 零变化；`bundle_sha256` 幂等；回归 A1/A2/A4 零破坏。

### 反例覆盖（对应 §3.5 + Codex R2 四组 P1）

- P1-1：同 SHA 不同文本 → 不判 UNCHANGED + warning；同文本输入 SHA 错误 → 不判 UNCHANGED + warning；正确 SHA → 仍 UNCHANGED 无 warning。
- P1-2：participants 伪动作 → 不提取；跨段区间拼接 → 不提取；缺/错证据身份 → ABSTAIN + `missing_fields` 可见；lower>upper、越界区间 → 不伪造。
- P1-3：`priceless`/`laboratory` 裸子串 → ABSTAIN；MODIFIED prior 侧通胀证据 → topic=inflation 且 `topic_evidence.inflation=["prior"]`；多主题 → `topics` 全保留。
- P1-4：`pending_review` + HEAD=开环基线 → 判定违反且 `validateContent` fail(`pending_review_points_at_opening_baseline`)；`pending_review` + 业务 tip → 放行；`pending_exec` + 基线 → 放行。

### 正式数据 / 既有文件前后 hash

- 正式 `data/` 178 文件树 hash：`f055a2db145d567f0d3b0f8d031c7ce340f8bbcf05586fc84542f20dc61fe104`，build 前后零变化。
- 本轮改动仅：`lib/fomc_text_diff.js`、`lib/fomc_decision_facts.js`、`scripts/ai_collab_board.js`、`scripts/smoke_v42_fomc_b1.js`、`scripts/smoke_v42_fomc_b1_gate2.js`、`scripts/smoke_v42_fomc_b1_gate3.js`、新增 `scripts/smoke_v42_fomc_b1_p14_board_check.js`、`logs/acceptance/PRD-EVENT-POLICY-15-B1/`。

### 回归

- A1 `smoke_v42_fomc_a1.js` **106/106**；A2 `smoke_v42_fomc_a2.js` **152/152（PASS）**；A4 `smoke_v42_fomc_a4.js` **25/25（PASS）**。

### 回滚实测

- 删除 B1 R2 修改面（`lib/fomc_text_diff.js`、`lib/fomc_decision_facts.js`、`scripts/ai_collab_board.js`、`scripts/smoke_v42_fomc_b1*.js`）并 `checkout 50b88aa` 恢复生产面 → 可完整回退；正式 `data/` 不受影响。

### 未覆盖项与残余风险

- fixtures 为合成 FOMC 声明；真实官方文本的超长 excerpt 截断、跨页重排密度未全量核对；
- `HYPOTHESIS` 分支（支持/反证/缺口/可证伪条件）属 Batch C 政策推断，本轮仅落地三态枚举与 FACT_ONLY/ABSTAIN 使用，未验证 HYPOTHESIS 内容契约；
- 投票名册（"Voting for the monetary policy action were: …"）本身不构成计数，本轮按缺证据处理（不伪造）；若未来需从名册推导，须 Batch C 单独授权。

未声明 `EVENT_POLICY_INTELLIGENCE_V1`、`POLICY_TEXT_DIFF_B1` 或任何研究/数据质量/发布验收名。

## 5. Codex 集中 R2 指令

### B1 R2 · Codex 最终聚焦复审结论：PASS

复审业务 tip：`2d18ab6`。本轮只复核上一轮四组 P1 及既有 B1/A1/A2/A4 回归，没有扩展 Batch C/D。

#### 四组 P1 独立复核

1. **SHA 独立复算：PASS。** 对齐使用规范化文本独立计算的 SHA；外部 SHA 不一致会产生显式 warning，且不能进入 UNCHANGED。不同文本同陈旧 SHA、相同文本错误 SHA、正确 SHA、缺 SHA 四类反例均符合预期。
2. **政策事实不伪造：PASS。** 目标区间、动作、投票均在单一段落内匹配；participants/discussion 不再生成 HOLD；跨段锚点+数字不再拼接事实；段落 id/hash 缺失或不一致时 ABSTAIN；逆序和超范围利率区间被拒绝。
3. **主题定位：PASS。** 采用词/短语边界；`priceless` 与 `laboratory` 不再误分类；MODIFIED 同时审视 prior/current，并用 `topics[] + topic_evidence` 保留多主题与来源侧。
4. **板与业务 tip 绑定：PASS。** 交接板 HEAD、执行指针 code_tip 均为 `2d18ab6`；新增交接前负向检查阻断 pending_review 指向开环基线。

#### 回归证据

- B1 Gate 1：**64/64 PASS**；
- B1 Gate 2：**33/33 PASS**；
- B1 Gate 3：**20/20 PASS**；
- B1 Gate 4：**14/14 PASS**；
- 板绑定负向检查：**5/5 PASS**；
- A1：**106/106 PASS**；A2：**152/152 PASS**；A4：**25/25 PASS**；
- 正式 `data/` 未写入，既有生产入口语义未扩展。

#### 判定边界

Codex 对 `POLICY_TEXT_DIFF_B1` 工程实现给出 **PASS**，交接板可转为 `done / human`。该 PASS 表示 B1 已具备 Human 确认条件，不代替 Human 正式声明，也不自动开启 Batch C/D；未声明 `EVENT_POLICY_INTELLIGENCE_V1`、研究、数据质量或发布级 PASS。

### B1 R2 · Codex 聚焦复审结论：CHANGES_REQUIRED

复审目标提交：`e2b496f`。既有 B1 四门 **109/109 PASS**（57 + 24 + 14 + 14），回归 A1 **106/106**、A2 **152/152**、A4 **25/25**；正式 `data/` 未写入。现有测试未覆盖以下会造成事实错误或审计失真的反例。

#### P1-1：差异引擎信任外部 SHA，可把不同文本标为 UNCHANGED

`normEntry()` 直接采用调用方传入的 `p.sha256`。独立反例令 prior=`Inflation remains elevated.`、current=`Employment declined sharply.`，但两者携带相同陈旧 SHA；结果被判为 `UNCHANGED / FACT_ONLY`，同时两个 excerpt 明显不同。

最小关闭：始终从规范化文本独立计算 SHA；若输入 SHA 存在则校验一致，不一致必须显式 warning/ABSTAIN/BLOCKED，不能参与 UNCHANGED 对齐。补“同 SHA 不同文本”和“文本相同但输入 SHA 错误”反例。

#### P1-2：决策事实跨段拼接且动作正则过宽，可凭空生成政策事实

三个独立反例成立：

1. `Some participants maintained the target range projection in their discussion.` 被提取为 `action=HOLD`，但这不是委员会决定；
2. 第一段只含 `target range for the federal funds rate was discussed`、第二段只含 `3 to 4 percent`，拼接后被提取为 3–4 区间，证据却只指向第一段；
3. 段落缺 `id/sha256` 时仍生成事实，`evidence_refs` 中 `paragraph_id/sha256` 缺失，无法定位审计。

最小关闭：各事实必须在**单一正式段落内**完成匹配并返回该次匹配的 paragraph；动作只接受明确的委员会决定句式，不能把 participants/history/discussion 当决定；证据身份缺失或不一致时该事实 ABSTAIN；区间同时校验有限数、lower <= upper 和合理范围。补上述三个反例及否定/讨论/历史措辞。

#### P1-3：主题定位使用裸子串且 MODIFIED 只看 current，会误标与漏标

- `priceless artwork` 被分类为 `inflation`（命中 `price` 子串）；
- `laboratory equipment` 被分类为 `employment`（命中 `labor` 子串）；
- prior=`Inflation remains elevated.`、current=`Conditions have improved.` 的 MODIFIED 项被标为 `ABSTAIN`，虽然 prior 侧有明确 inflation 证据。

最小关闭：采用词/短语边界匹配；MODIFIED 必须审视 prior 与 current 两侧并明确主题证据来自哪一侧。若一项涉及多个主题，不得仅凭固定优先级无声覆盖，应保留多主题或显式冲突/ABSTAIN。补上述反例。

#### P1-4：交接板与执行指针未绑定实际 B1 业务 tip

当前仓库业务提交为 `e2b496f`，但交接板 §2 `HEAD` 与执行指针 `code_tip` 仍为 A2 基线 `50b88aa`。因此机器校验虽通过，却没有把本次复审对象绑定到 B1 实现。

最小关闭：修复后将交接板 HEAD、执行指针 code_tip 与实际 B1 业务 tip 统一，再交 Codex；增加交接前检查，禁止 `pending_review` 指向开环基线。

#### 边界

只关闭以上四组 P1 及对应负向测试，不扩展 Batch C/D，不改生产入口语义，不声明 `POLICY_TEXT_DIFF_B1` 或 `EVENT_POLICY_INTELLIGENCE_V1`。

聚焦复审目标（本环为纯派生计算，范围收敛到五子机制与四类风险）：

1. **B_TEXT_DIFF 确定性 / 可复算 / 可定位** —— 复核 `computeTextChanges` 三阶段算法（sha256 精确匹配 → 同 ordinal MODIFIED → 余量 ADDED/REMOVED）；重点：同输入同版本字节级同输出、跨页重排不误判、`excerptOf` 截断确定性、`normEntry` 派生 id 稳定性、`evidence_refs[]` 可解析到真实段落。
2. **B_DECISION_FACTS 不伪造** —— 复核 `extractDecisionFacts` 三提取器（target_range / action / vote）正则边界：区间锚定不吞 "to"、动作动词覆盖不误报、投票仅在明确计数时提取；`derived_decision_facts` 是否绝对不继承输入 `decision_facts`（H1 反例）、拒绝新闻/缓存事实源（H2/H3）。
3. **B_TOPIC_LOCATION 可追溯** —— 复核 `classifyTopic` 优先级（inflation > employment > economic_activity）与关键词边界；每个非 ABSTAIN 的 topic 是否都能在 change 自身 excerpt 中定位关键词。
4. **B_INTERPRETATION_BOUNDARY** —— 复核禁止字段断言（score / similarity / confidence / hawk / dove / market_*）是否覆盖顶层与逐项；`HYPOTHESIS` 是否不自动伪造。
5. **B_DATA_PROTECTION** —— 复核 build 前后 `data/` 树 hash 零变化、`bundle_sha256` 幂等、A1/A2 透传 `decision_facts` + `missing_fields` 语义不变（A1:325 断言仍绿）。

请就以上给出 **PASS / CHANGES_REQUIRED** 裁决；如 CHANGES_REQUIRED 需列可复现反例与最小关闭要求，不扩展 Batch B/C/D。

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
