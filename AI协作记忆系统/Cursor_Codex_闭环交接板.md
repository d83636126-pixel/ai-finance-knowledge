---
type: Cursor_Codex闭环交接板
schema_version: 2
tags: [AI协作, Cursor, Codex, V4.2, B1, FOMC]
created: 2026-08-01
updated: '2026-08-02'
project: financial-alert-system
loop_id: PRD-EVENT-POLICY-15-B1
acceptance: POLICY_TEXT_DIFF_B1
revision: 12
turn: 0
next_actor: 'cursor'
status: 'pending_exec'
max_turns: 3
last_writer: 'human'
written_at: '2026-08-02T08:40:03.491Z'
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
- 当前执行者：Cursor；完成 Batch B 交付后交 Codex 做一次聚焦 R2。
- 本环不做政策倾向/鹰鸽解释、不把文本差异压成不可解释的单一分数、不接新外部网络、不改既有生产入口语义；不声明 `EVENT_POLICY_INTELLIGENCE_V1`。

## 2. 基线、授权与边界

| 项 | 值 |
|---|---|
| stage | `V4.2 B1 确定性文本差异与政策事实` |
| B1 计划 | `docs/ai-collab/产品发展执行计划_V4.2_B_确定性文本差异与政策事实_2026-08-02.md` |
| HEAD | `50b88aa` |
| 开环基线 | `50b88aa`（A2 业务 tip） |
| A1 / A2 业务 tip | `b1abce5` / `50b88aa` |
| change class | `C2` |
| review | `R2`（聚焦） |
| status / next_actor | `pending_exec / cursor` |
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

（待 Cursor 完成 Batch B 后填写。）

## 5. Codex 集中 R2 指令

（待 Cursor 交回后填写聚焦复审目标。）

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
