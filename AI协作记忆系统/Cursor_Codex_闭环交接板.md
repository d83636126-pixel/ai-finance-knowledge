---
type: Cursor_Codex闭环交接板
schema_version: 2
tags: [AI协作, Cursor, Codex, Obsidian, 产品路线图, V3.1, PRD-EVENT-REGISTRY-09]
created: 2026-07-26
updated: '2026-07-26'
project: financial-alert-system
loop_id: PRD-EVENT-REGISTRY-09
acceptance: EVENT_RESEARCH_REGISTRY_V1_PASS
revision: 0
turn: 0
next_actor: 'cursor'
status: 'pending_exec'
max_turns: 4
last_writer: 'human'
written_at: '2026-07-26T21:45:00.000Z'
lease_owner: ''
lease_actor: ''
lease_expires_at: ''
code_root: 'F:\financial-alert-system'
vault_note: AI协作记忆系统/Cursor_Codex_闭环交接板.md
repo_mirror: docs/ai-collab/Cursor_Codex_闭环交接板.md

---
# Cursor ↔ Codex 闭环交接板

> [!important] 当前执行：**PRD-EVENT-REGISTRY-09 · V3.1 事件运营台账**
>
> 前环 `PRD-EVENT-RESULT-UX-08` 已归档（`RESULT_UX_V1_PASS`）。
> 本环：建立事件运营台账，用户在 60 秒内找到当前最该处理的事件。
> 复用现有 registry、日历、研究记录、收尾卡。不建第二套存储。
> 验收：`EVENT_RESEARCH_REGISTRY_V1_PASS`。

## 0. 闭环协议

```text
V3.1 执行计划已形成（docs/ai-collab/产品发展执行计划_V3.1_事件运营台账_2026-07-26.md）
→ Batch A: 台账视图契约（可见性分类 + 生命周期 + 优先级）
→ Batch B: 台账页面（event_research_registry.html）
→ Batch C: 真实事件集中走查 → EVENT_RESEARCH_REGISTRY_V1_READY
→ 集中产品验收 → PASS / REVISE
```

### 0.1 硬边界

- 不创建第二个 registry
- 不重写研究记录、收尾卡或六子机制
- 不引入 AI 自动优先级
- 不删除现有 registry 记录
- 不根据标题自动合并事件
- 测试记录默认隐藏，验证样本不进入活跃优先级
- 身份冲突和时间缺失必须显示为待核验，不得静默通过
- 禁止宣称 `RESEARCH_PASS` / `DATA_QUALITY_PASS` / `RELEASE_PASS`

## 1. 任务目标

| 字段 | 内容 |
|---|---|
| 所属轨道 | `PROD` |
| 审核等级 | `R1`（整环一次集中产品验收） |
| 一句话目标 | 用户在 60 秒内找到当前最该处理的事件，一次点击进入正确步骤 |
| 成功标准 | `EVENT_RESEARCH_REGISTRY_V1_PASS` |
| 计划文档 | 产品发展执行计划 V3.1：事件运营台账 |
| 新页面 | `event_research_registry.html` |
| 产品基线 | `73f5ce4` |
| max_turns | 4 |

## 2. 仪表盘

| 项 | 值 |
|---|---|
| loop_id | `PRD-EVENT-REGISTRY-09` |
| stage | Batch A ✅ → Batch B — 台账页面 |
| status / next_actor | pending_exec / cursor |
| HEAD | `73f5ce4` |
| batch_a (视图契约) | `DONE` |
| batch_b (台账页面) | `PENDING` |
| batch_c (真实走查) | `PENDING` |
| acceptance | `NOT_STARTED` |
| deferred | BADGE / 技术加固 → V3.2+ |

## 3. 当前指令（Cursor — Batch B：台账页面）

```text
Batch B 基于 Batch A 的视图契约，创建 event_research_registry.html 台账页面。

1. 页面结构（参考 V3.1 执行计划第 6 节）：
   - 顶部"现在最该处理"区域（最多 3 张行动卡）
   - 生命周期分组列表
   - 最小筛选（生命周期、事件类型、时间范围、来源、事前记录有无、收尾卡有无）
   - 每条记录卡片：名称+event_id、时间、主状态、最多两个辅助提示、一个主动作、"查看详情"次动作
   - 技术标签和完整 refs 默认折叠

2. 数据源：
   - registry API: GET /api/research/records → 全部 registry 记录
   - 日历 API: GET /api/calendar/upcoming?days=30 → 候选事件
   - V3 结果存在性检查（检查 data/event_result_v3/ 目录对应文件）
   - 使用 lib/event_registry_view.js 的 classifyVisibility / deriveLifecycle / sortByPriority

3. 页面行为：
   - 加载后调用 registry API 获取数据
   - 调用日历 API 获取候选事件
   - 使用视图契约分类/派生/排序
   - 渲染顶部 3 条优先行动
   - 渲染生命周期分组列表
   - 筛选器实时过滤
   - 点击主动作跳转到正确页面

4. 错误和空态（fail-loud）：
   - registry API 不可用 → 显示加载失败，不展示假数据
   - 没有活跃事件 → 显示如何从日历/Inbox 纳入
   - 候选源不可用 → 已纳入事件仍可显示
   - 状态无法判定 → 进入"信息待核验"

5. 集成到工作台：
   - 加入统一工作台主入口（navigation bar 或工作台首页）
   - 确认不破坏既有页面路由

Batch B 完成标志：event_research_registry.html 可加载、可筛选、三条优先行动可见。
```

## 4. 执行记录

### 开环（turn 0）

```text
V3.0 全线已归档（V3.0 工程 PASS → UX-08 产品 PASS → RESULT_UX_V1_PASS）。
V3.1 执行计划已落盘（产品发展执行计划_V3.1_事件运营台账_2026-07-26.md）。
产品基线：73f5ce4。
拟定 acceptance：EVENT_RESEARCH_REGISTRY_V1_PASS（不代表研究有效性或数据质量通过）。
等待执行 Batch A。
```

### Batch A 完成（turn 1）

```text
产物：lib/event_registry_view.js（约 420 行）
测试：lib/test_event_registry_view.js（51 项测试全部通过）
验证：真实 registry 23 条记录端到端走查通过
集成：加入 check suite（run_suite.js），7/7 PASS，无回归

分类结果：
- TEST 4（test_* 记录）
- VALIDATION 4（smoke_fixture 历史样本）
- PRODUCT 10（产品事件）
- TIME_REVIEW 2（cpi/ppi 无 scheduled_at）
- IDENTITY_REVIEW 1（inbox_reg_b4aff1d6dee1bd74 ↔ earnings_googl_2025_q2 重复）

生命周期关键判定：
- earnings_nvda_2026_q2 → TRACKING_PRE（未来 11 天）
- earnings_aapl_2026_q2 → TRACKING_PRE（未来 4 天）
- earnings_googl/msft/tsla_2026_q2 → OCCURRED_PENDING_RESULT（已发生 4 天）
- cpi/ppi → TIME_REVIEW → NEEDS_REVIEW

优先级 top 3：inbox 较旧事件（572天）→ 真实已发生待复盘 → NEEDS_REVIEW
```

## 5. 审核预留

本环无 Codex 预审核。Batch A–C 内部执行后直接进入 Human 集中产品验收。
最大审核回合：3（若 REVISE）。

## 6. 回合历史

| turn | actor | 动作 | 结果 |
|---|---|---|---|
| — | human | 批准 V3.1 计划 | 开 PRD-EVENT-REGISTRY-09 |
| 0 | cursor | Batch A: lib/event_registry_view.js 创建，51/51 测试通过 | batch_a ✅ → Batch B 就绪 |

## 7. Human 备注

- V3.0 全线归档（RESULT_UX_V1_PASS）
- V3.1 执行计划已冻结，不重新讨论范围
- FORWARD / RESEARCH_PASS / DATA_QUALITY_PASS / RELEASE_PASS 禁止在本环声称
- 真实持续事件必须在 Batch C 前通过正常入口纳入 registry
