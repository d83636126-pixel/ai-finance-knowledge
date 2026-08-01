---
type: Cursor_Codex闭环交接板
schema_version: 2
tags: [AI协作, Cursor, Codex, V4.2, A1, FOMC]
created: 2026-08-01
updated: '2026-08-01'
project: financial-alert-system
loop_id: PRD-EVENT-POLICY-15-A1
acceptance: EVENT_POLICY_INTELLIGENCE_V1
revision: 27
turn: 0
next_actor: 'cursor'
status: 'pending_exec'
max_turns: 3
last_writer: 'human'
written_at: '2026-08-01T05:21:56.154Z'
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
| HEAD | `6519efd` |
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

待执行。

## 5. Codex 聚焦 R2 指令

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
