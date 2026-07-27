---
type: Cursor_Codex闭环交接板
schema_version: 2
tags: [AI协作, Cursor, Codex, Obsidian, 产品路线图, V3.1, PRD-EVENT-REGISTRY-09]
created: 2026-07-26
updated: '2026-07-27'
project: financial-alert-system
loop_id: PRD-EVENT-REGISTRY-09
acceptance: EVENT_RESEARCH_REGISTRY_V1_PASS
revision: 4
turn: 4
next_actor: 'human'
status: 'done'
max_turns: 4
last_writer: 'human'
written_at: '2026-07-27T02:27:05.111Z'
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
| stage | V3.1 已完成并归档 |
| status / next_actor | done / human |
| HEAD | `8b4f576` |
| batch_a (视图契约) | `DONE` |
| batch_b (台账页面) | `DONE` |
| batch_c (真实走查) | `DONE` |
| acceptance | `EVENT_RESEARCH_REGISTRY_V1_PASS` |
| deferred | BADGE / 技术加固 → V3.2+ |

## 3. 最终验收

```text
结论：EVENT_RESEARCH_REGISTRY_V1_PASS。

产品 tip：8b4f576。

最终验证：
- 事件台账视图单元测试 58/58 PASS；
- 真实数据走查 34/34 PASS；
- check suite 7/7 PASS；
- 浏览器内联台账逻辑语法通过，并与 Node 视图保持 DATA_REVIEW / 身份冲突规则一致。

当前 Top 3：
1. US Reciprocal Tariff Announcement — 已发生 481 天；
2. 美国2月非农就业 — 已发生 143 天；
3. 谷歌(GOOGL) 季度财报 — 已发生 5 天。

数据边界：
- 两条旧 Inbox 测试残留继续非破坏性隔离；
- nfp_2026_04 因来源日期矛盾进入 DATA_REVIEW；
- nfp_2026_02 是 2 月参考期、3 月 6 日发布的正常产品事件，不再误报；
- 不宣称 RESEARCH_PASS / DATA_QUALITY_PASS / RELEASE_PASS。

PRD-EVENT-REGISTRY-09 完成，V3.1 归档。后续产品阶段须另行规划，不自动开环。
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

### Human 集中产品验收 R1（turn 1）

```text
结论：CHANGES_REQUIRED。

已确认：页面和六类生命周期走查完成；51/51 view tests、35/35 walkthrough 通过。
阻断：正式优先队列 Top 1 为旧测试残留 A|B，不是真实金融事件。
退回 Cursor 做一次最小数据可见性修复；不扩大范围。
```
## 5. 审核预留

本环无 Codex 预审核。Batch A–C 内部执行后直接进入 Human 集中产品验收。
最大审核回合：3（若 REVISE）。

## 6. 回合历史

| turn | actor | 动作 | 结果 |
|---|---|---|---|
| — | human | 批准 V3.1 计划 | 开 PRD-EVENT-REGISTRY-09 |
| 0 | cursor | Batch A: lib/event_registry_view.js 创建，51/51 测试通过 | batch_a ✅ → Batch B 就绪 |
| 1 | cursor | Batch B: event_research_registry.html 台账页面创建，导航入口加入各页面，searchParams bug 修复，check suite 7/7 通过 | batch_b ✅ → Batch C 就绪 |
| 2 | cursor | Batch C: 真实事件集中走查 35/35 PASS，生命周期全覆盖（CANDIDATE/TRACKING_PRE/ONGOING/OCCURRED_PENDING_RESULT/REVIEWED/NEEDS_REVIEW），FOMC 通过日历正常入口纳入作为持续事件 | batch_c ✅ → 集中产品验收就绪 |
| 3 | cursor | R2 三处修复：写入源隔离（POST 入口合成检测）+ 命名前缀冲突检测 + Top 3 断言加强。53/53 + 35/35 + 7/7 全部 PASS | CHANGES_REQUIRED 修复 → 待 Human 复核 |
| 4 | human/codex | 最终事实修正：仅显式标记 nfp_2026_04；保留正常的 2 月非农发布滞后；58/58 + 34/34 + 7/7 | `EVENT_RESEARCH_REGISTRY_V1_PASS` → done/human |

## 7. Human 备注

- V3.0 全线归档（RESULT_UX_V1_PASS）
- V3.1 执行计划已冻结，不重新讨论范围
- FORWARD / RESEARCH_PASS / DATA_QUALITY_PASS / RELEASE_PASS 禁止在本环声称
- 真实持续事件必须在 Batch C 前通过正常入口纳入 registry
