---
type: Cursor_Codex闭环交接板
schema_version: 2
tags: [AI协作, Cursor, Codex, Obsidian, 产品路线图, V3.2, PRD-EVENT-DAILY-10]
created: 2026-07-27
updated: '2026-07-27'
project: financial-alert-system
loop_id: PRD-EVENT-DAILY-10
acceptance: EVENT_DAILY_LOOP_V1_PASS
revision: 2
turn: 3
next_actor: 'human'
status: 'done'
max_turns: 4
last_writer: 'human'
written_at: '2026-07-27T05:05:44.934Z'
lease_owner: ''
lease_actor: ''
lease_expires_at: ''
code_root: 'F:\financial-alert-system'
vault_note: AI协作记忆系统/Cursor_Codex_闭环交接板.md
repo_mirror: docs/ai-collab/Cursor_Codex_闭环交接板.md

---
# Cursor ↔ Codex 闭环交接板

> [!important] 当前执行：**PRD-EVENT-DAILY-10 · V3.2 真实事件摄入与日常推进**
>
> 前环 `PRD-EVENT-REGISTRY-09` 已归档（`EVENT_RESEARCH_REGISTRY_V1_PASS`）。
> 本环：用户在台账中发现候选事件，确认后进入 registry，按时间形态进入正确生命周期。
> 不重建事件系统，不建第二套存储。
> 验收：`EVENT_DAILY_LOOP_V1_PASS`。

## 0. 闭环协议

```text
V3.2 执行计划已批准（docs/ai-collab/产品发展执行计划_V3.2_真实事件摄入与日常推进_2026-07-27.md）
产品基线：8b4f576（V3.1 归档 HEAD）。
→ Batch A: 候选合流（日历 + Inbox 统一候选区）
→ Batch B: 台账内确认纳入与原地反馈
→ Batch C: 真实事件日常走查 → EVENT_DAILY_LOOP_V1_READY
→ 集中产品验收 → PASS / REVISE
```

### 0.1 硬边界

- 不重写 registry
- 不新增数据库
- 不做复杂抓取平台
- 不自动纳入未确认新闻
- 不做 AI 事件评分
- 不做跨事件比较
- 不做日报推送
- 不做研究有效性验证
- 禁止宣称 `RESEARCH_PASS` / `DATA_QUALITY_PASS` / `RELEASE_PASS`

## 1. 任务目标

| 字段 | 内容 |
|---|---|
| 所属轨道 | `PROD` |
| 审核等级 | `R1`（整环一次集中产品验收） |
| 一句话目标 | 用户在台账中发现候选事件，确认后进入 registry，按时间形态进入正确生命周期 |
| 成功标准 | `EVENT_DAILY_LOOP_V1_PASS` |
| 计划文档 | 产品发展执行计划 V3.2：真实事件摄入与日常推进 |
| 核心页面 | `event_research_registry.html`（已有台账） |
| 产品基线 | `8b4f576` |
| max_turns | 4 |

## 2. 仪表盘

| 项 | 值 |
|---|---|
| loop_id | `PRD-EVENT-DAILY-10` |
| stage | V3.2 已完成并归档 |
| status / next_actor | done / human |
| HEAD | `73ebbce` |
| batch_a (候选合流) | `DONE` |
| batch_b (确认纳入) | `DONE` |
| batch_c (P1 阻断修复) | `DONE` |
| acceptance | `EVENT_DAILY_LOOP_V1_PASS` |
| deferred | 跨事件对比、日报推送、研究验证 → V3.3+ |

## 3. 最终验收

```text
结论：EVENT_DAILY_LOOP_V1_PASS。

产品 tip：73ebbce。

Human 产品走查：
- 在 8013 日常入口完成候选发现、确认纳入、原地反馈、打开研究记录和返回台账；
- 日历与 Inbox 来源可区分；
- 重复纳入保持幂等；
- 时间未知、突发/持续与待核验事件保持诚实生命周期；
- 候选加载失败显示错误与重试，不再静默隐藏。

自动证据：
- 台账单元测试 69/69 PASS；
- V3.2 集中走查在候选消费前 41/41 PASS；
- V3.1 回归走查通过。

收口说明：
- Human 走查正常消费了现有日历候选，事后重跑旧脚本不再满足“至少一条未消费候选”的前置条件；
- 该问题登记为测试可重复性技术债，不影响用户主路径，不开启新审核环；
- 未宣称 RESEARCH_PASS / DATA_QUALITY_PASS / RELEASE_PASS；
- V3.3 未开环。
```
## 4. 执行记录

### 开环（turn 0）

```text
V3.1 全线已归档（EVENT_RESEARCH_REGISTRY_V1_PASS）。
V3.2 执行计划已批准（产品发展执行计划_V3.2_真实事件摄入与日常推进_2026-07-27.md）。
产品基线：8b4f576。
拟定 acceptance：EVENT_DAILY_LOOP_V1_PASS（不代表研究有效性或数据质量通过）。
等待执行 Batch A。
```

### Batch A（候选合流 — 完成）

```text
- 服务端新增 GET /api/research/candidates：统一返回日历+Inbox候选
- 视图契约新增 findUnifiedCandidates()：合并、去重、过滤测试、排序
- 台账页面顶部新增统一候选区（来源标签、时间状态、确认纳入按钮）
- 11 个新增单元测试，69/69 PASS，34/34 走查 PASS
```

### Batch B（台账内确认与原地反馈 — 完成）

```text
- “确认纳入”按钮接通日历和 Inbox 权威纳入入口
- 纳入成功后卡片原地变为生命周期卡片（含生命周期标签 + “打开研究记录”链接）
- 重复确认保持幂等：显示“已在研究列表中”+ 查看现有记录链接
- 失败卡片显示原因 + 重试按钮
- 生命周期组和优先级在后台静默刷新，不重新加载候选区
- 时间未知事件纳入后自动进入 NEEDS_REVIEW 生命周期
```

### Batch C（最小收尾 — P1 四项阻断修复）

```text
- POST /api/research/adopt-from-calendar: 服务端权威纳入端点，candidate_id → calendarEvents 解析
- POST /api/research/adopt-from-inbox: 扩展支持客户端 InboxStore 内联回退
- 统一候选区错误状态：候选加载失败显示错误+重试按钮，不再静默隐藏
- 日历纳入改为服务端权威端点（客户端只提交 candidate_id，不从 DOM 拼装）
- loadData() 从客户端 InboxStore 读取真实 Inbox 项，与日历候选合并展示
- V3.2 集中走查 scripts/smoke_v32_walkthrough.js: 12 场景 41 PASS
- V3.1 回归 36/36，单元测试 69/69
```

### 等待 Human 产品验收

```text
P1 四项阻断已全部修复：
1. ✅ Inbox 候选接通：仪表板从 InboxStore 读取真实项
2. ✅ 日历权威纳入：服务端端点解析，客户端只提交 candidate_id
3. ✅ 候选加载失败错误状态：错误+重试按钮可见
4. ✅ V3.2 集中走查：41/41 PASS，覆盖完整主路径
等待 Human 验收 → EVENT_DAILY_LOOP_V1_PASS / REVISE
```

## 5. 审核预留

本环 Batch A-C 内部连续执行后直接进入 Human 集中产品验收。
最大审核回合：2（若 REVISE）。

## 6. 回合历史

| turn | actor | 动作 | 结果 |
|---|---|---|---|
| — | human | 批准 V3.2 计划，V3.1 归档 | 开 PRD-EVENT-DAILY-10 |
| 0 | cursor | Batch A 候选合流 | 统一候选区 + 11 测试，69 PASS |
| 1 | cursor | Batch B 原地反馈 | 原地生命周期过渡 + 幂等 + 失败可见 |
| 2 | cursor | Batch C P1 阻断修复 | 真实 Inbox + 权威纳入 + 错误状态 + V3.2 走查 41 PASS |
| 3 | human | 集中产品走查完成 | `EVENT_DAILY_LOOP_V1_PASS` → done/human |

## 7. Human 备注

- V3.1 全线归档（EVENT_RESEARCH_REGISTRY_V1_PASS）
- V3.2 执行计划已冻结，不重新讨论范围
- RESEARCH_PASS / DATA_QUALITY_PASS / RELEASE_PASS 禁止在本环声称
- Batch A-C 连续执行，不分批审核
- V3.3 仍未授权，须由 Human 另行开环
