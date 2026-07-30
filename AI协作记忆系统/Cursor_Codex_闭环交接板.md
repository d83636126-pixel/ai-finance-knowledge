---
type: Cursor_Codex闭环交接板
schema_version: 2
tags: [AI协作, Cursor, Codex, V4.0, Batch-D, 产品]
created: 2026-07-30
updated: '2026-07-30'
project: financial-alert-system
loop_id: PRD-EVENT-INTELLIGENCE-13-D
acceptance: EVENT_INTELLIGENCE_ASSIST_V1
revision: 3
turn: 1
next_actor: 'codex'
status: 'pending_review'
max_turns: 3
last_writer: 'cursor'
written_at: '2026-07-30T09:57:46.487Z'
lease_owner: ''
lease_actor: ''
lease_expires_at: ''
code_root: 'F:\financial-alert-system'
vault_note: AI协作记忆系统/Cursor_Codex_闭环交接板.md
repo_mirror: docs/ai-collab/Cursor_Codex_闭环交接板.md
---

# Cursor ↔ Codex 闭环交接板：V4.0 Batch D

> 当前口令：**执行Cursor_Codex闭环交接板当前指令 · V4 Batch D**

## 1. 当前裁决

- Cursor 已完成 V4 Batch D 最小交付，提交 tip `dde0e28`。
- 本环等待 Codex 一次集中 R1；通过后交 Human 真实使用走查。
- **尚未声明** `EVENT_INTELLIGENCE_ASSIST_V1`。

- Human 已批准开启 V4 Batch D「智能简报与真实使用」。
- Batch C 产品 P1 已在 `d267f8d` 收尾并完成真实浏览器复走查。
- 本环仅完成 V4 计划中 Batch D，不扩展新模型、研究门禁、外部部署或新架构。
- 本环结束只做一次集中 R1；非产品阻断问题登记技术债，不重复拖延产品主线。
- 当前尚未声明 `EVENT_INTELLIGENCE_ASSIST_V1`。

## 2. 基线与边界

| 项 | 值 |
|---|---|
| 开环 tip | `d267f8d` |
| 本环 tip | `dde0e28` (`dde0e2884290a8422413df390d374138ae635a05`) |
| 开环 | `PRD-EVENT-INTELLIGENCE-13-D` |
| 执行者 | Cursor（已完成） |
| 复审者 | Codex（一次集中 R1） |
| 最终产品验收 | Human |
| 正式本地入口 | `http://127.0.0.1:8013/daily_briefing.html` |
| 回滚点 | `git reset --hard d267f8d`（丢弃 Batch D commit） |

硬边界仍有效：不声明 RESEARCH/DATA_QUALITY/RELEASE PASS；不碰 `data_backup_*`；不扩模型。

| 项 | 值 |
|---|---|
| code_tip | `d267f8d` |
| stage | V4.0 Batch D 智能简报与真实使用 |
| 开环 | `PRD-EVENT-INTELLIGENCE-13-D` |
| 执行者 | Cursor |
| 复审者 | Codex（一次集中 R1） |
| 最终产品验收 | Human |
| 正式本地入口 | `http://127.0.0.1:8013/daily_briefing.html` |

硬边界：

1. 复用现有每日简报、证据包、智能草稿、事件台账和收尾卡，不重写前端框架。
2. Human 已授权本地产品范围内的受控接线与真实使用；不授权外部发布、付费模型或新增常驻任务。
3. 不改 held-out/forward、研究阈值和研究信用；不得声明 `RESEARCH_PASS`、`DATA_QUALITY_PASS` 或 `RELEASE_PASS`。
4. AI 输出仍是证据驱动草稿；保留 `AI_AUTO` / `HUMAN_CONFIRMED` 分离、来源、弃权和只填空白字段规则。
5. 两个 `data_backup_*` 目录继续排除，不提交、不删除、不改写。
6. `EVENT_INTELLIGENCE_ASSIST_V1` 只有在 Codex R1 通过且 Human 完成真实使用走查后才能声明。

## 3. Cursor 当前执行指令

### 3.1 产品目标

让用户打开每日简报后，在 10 秒内知道最值得处理的 3 件事、为什么优先，以及下一步应进入哪份草稿或记录。

### 3.2 最小交付

1. 在现有简报上接入 V4 确定性智能优先级；候选依据至少覆盖：
   - 新事实或证据刷新；
   - 事件时间窗口；
   - `FAIL / ABSTAIN / BLOCKED / 缺证据` 等异常状态；
   - 已生成、待人工确认的事前或事后草稿。
2. Top 3 不重复，每条展示机器可读且用户可理解的优先理由，不得用无证据的 AI 叙事代替排序依据。
3. 每条从简报直达准确动作：事前草稿、事后草稿、研究记录或事件收尾卡；不得只打开模糊首页。
4. 完成动作后，仅在权威证据或任务状态确已解决时退出对应任务；保留“稍后处理”，禁止仅靠前端按钮伪完成。
5. 至少完成 3 个结构化宏观事件的真实走查或历史时点回放：
   - 一条历史 NFP，事后草稿可确认；
   - 一条未来就业事件，事前可用、事后明确弃权；
   - 一条 CPI 或 GDP 历史事件，用于验证跨类型兼容。
6. 若正式来源、时间或必需字段不足，页面和 API 必须显式 `ABSTAIN` 或 development 标识，不得补造事实。

### 3.3 验收用例

- 打开简报 10 秒内可说清 Top 3 及每条优先原因。
- 单事件从简报到完成或确认不超过 2 次人工确认。
- 接口、证据、草稿或保存失败必须显式报错，不得静默退出任务。
- 简报任务状态与证据包、草稿和台账权威状态一致。
- 关闭浏览器并重新打开后，待办、稍后处理和草稿仍可继续。
- 三条事件走查均保留可复跑证据，测试不得污染真实产品数据。

### 3.4 交付纪律

1. 先领取租约，再改业务文件。
2. 测试优先使用隔离数据根和隔离端口；正式 `:8013` 仅用于最后受控产品检查。
3. 只提交 Batch D 文件；既有 dirty 与备份目录不纳入。
4. 完成后把本板更新为 `pending_review / codex`，写明代码 tip、走查证据、未完成项和回滚点，然后停止。

## 4. Cursor 执行报告

### 交付摘要

1. **Top 3 引擎** `lib/briefing_intelligence_v4.js`：按证据刷新/缺失、`FAIL/ABSTAIN/BLOCKED`、草稿 `READY_FOR_REVIEW`、±48h 窗口与既有分类做确定性加权；输出 `priority_reasons` + `priority_codes`。
2. **深链**：事后待确认 → `event_research_result_v3.html`；事前待确认 → `event_research_record.html`；并附 `draft_url` 直达 intelligence-draft API。
3. **完成退出**：`canExitIntelTask` 绑定权威状态（v3 COMPLETE / 事前权威 / 证据 FAIL 拒退）；禁止仅靠按钮伪完成。
4. **UI**：`daily_briefing.html` 展示 Top3 理由、codes、草稿链接；Obsidian 导出含 Top3。
5. **走查**：隔离脚本 `scripts/smoke_v4_batch_d_walkthrough.js` — 历史 NFP 事后、未来就业事前/事后弃权、CPI 跨类型。

### Git

- 前 HEAD：`d267f8d`
- 后 HEAD：`dde0e28` / `dde0e2884290a8422413df390d374138ae635a05`
- 本环提交文件：`lib/briefing_intelligence_v4.js`、`local_server.js`、`daily_briefing.html`、`scripts/smoke_v4_batch_d_walkthrough.js`
- 未纳入：既有 docs dirty、`data_backup_*`、R2 归档 untracked

### 验证

| 命令 | 结果 |
|---|---|
| `node scripts/smoke_v4_batch_d_walkthrough.js` | **41/41 PASS**（隔离 `FAS_PRODUCT_DATA_ROOT` + 随机端口） |
| `node scripts/smoke_closing_card_draft_fill.js` | **19/19 PASS**（回归） |

工件：

- `scripts/smoke_v4_batch_d_walkthrough.js` SHA-256 `1ABEFEADAD133D81DB40AE5DDBD36F38A8136AD28E913AB1274D84F47A99C5E1`
- `lib/briefing_intelligence_v4.js` SHA-256 `126D0D8C7A8AA4DE0FCA70EE1191F8AB7FC67C804092286B14C9484EFF5373C1`

### 未完成 / 非阻断

- 正式 `:8013` Human 真实使用走查仍待 Codex R1 后执行。
- 日历候选仍可能进入 Top3（既有 V3.4 行为）；V4 已叠加证据/草稿权重，未删除候选通道。
- 未声明 `EVENT_INTELLIGENCE_ASSIST_V1`。

### 六子机制（本环自报，供 R1 复核，非最终验收）

| 子机制 | 状态 |
|---|---|
| ACQUISITION | 沿用既有（本环未新开采集） |
| IDENTITY_BINDING | 沿用 |
| DETERMINISTIC_ANALYSIS | 沿用 + Top3 可复算 |
| INFERENCE_TRACEABILITY | Top3 codes/reasons 可追踪 |
| DRAFT_PERSISTENCE | 深链到既有 draft store |
| HUMAN_OVERRIDE_AUDIT | complete 门控 + 收尾卡只填空既有规则 |


待填写。

## 5. Codex 集中 R1 指令

只集中复审以下五点：

1. Top 3 是否由可复算证据与状态驱动，且理由真实可见。
2. 深链和任务退出是否绑定权威状态，而非前端假完成。
3. 三事件走查是否覆盖历史事后、未来事前/事后弃权、跨类型兼容。
4. 失败、弃权、来源和人工覆盖是否保持 fail-loud。
5. 重开连续性及真实数据不受测试污染。

裁决：

- 产品阻断、数据错误、错误完成或隐瞒失败：`CHANGES_REQUIRED`。
- 仅命名、更多测试、性能优化或非阻断体验问题：登记技术债，不开启新一轮扩展。
- 通过：更新为 `done / human`，交 Human 做最终真实使用走查；Codex 不提前声明产品总验收名。
- 仍存在无法在本环最小修复的问题：`BLOCKED / human`，停止 V4 扩展。

## 6. 历史

- 2026-07-30T09:46:35.077Z：Human 批准“开启 D”；归档 R2，开启 `PRD-EVENT-INTELLIGENCE-13-D`。
- 2026-07-30T09:57:45.924Z：Cursor 完成 Batch D 最小交付 tip `dde0e28`，移交 `pending_review / codex`。

- 2026-07-30T09:46:35.077Z：Human 批准“开启 D”；归档 R2，开启 `PRD-EVENT-INTELLIGENCE-13-D`。
