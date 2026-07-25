---
type: Cursor_Codex闭环交接板
schema_version: 2
tags: [AI协作, Cursor, Codex, Obsidian, 闭环, PRD-EVENT-QUEUE-03, V2.4]
created: 2026-07-25
updated: '2026-07-25'
project: financial-alert-system
loop_id: PRD-EVENT-QUEUE-03
revision: 1
turn: 1
next_actor: 'cursor'
status: 'pending_exec'
max_turns: 8
last_writer: 'cursor'
written_at: '2026-07-25T10:25:00.000Z'
lease_owner: ''
lease_actor: ''
lease_expires_at: ''
code_root: 'F:\financial-alert-system'
vault_note: AI协作记忆系统/Cursor_Codex_闭环交接板.md
repo_mirror: docs/ai-collab/Cursor_Codex_闭环交接板.md
---
# Cursor ↔ Codex 闭环交接板

> [!important] 当前执行：**PRD-EVENT-QUEUE-03 · V2.4 已纳入研究待办**
>
> 前环 `PRD-EVENT-VALUE-02` 已 PASS 归档（产品 tip `fcf0450`）。
> 本环最终验收：`EVENT_RESEARCH_QUEUE_V1_PASS`（齐套后一次 R1）。
> batch1 已交付；**暂不交 Codex**。

## 0. 闭环协议

```text
VALUE-02 PASS → 开 QUEUE-03
→ Cursor 连续切片（不拆审）
→ Human「开」→ 一次 Codex R1
```

### 0.1 硬边界

- 禁止宣称 RESEARCH_PASS / DATA_QUALITY_PASS / RELEASE_PASS
- 不重复宣称 INTEGRATION / VALUE PASS
- 本环唯一 PASS 名：`EVENT_RESEARCH_QUEUE_V1_PASS`（未宣称）

## 1. 任务目标

| 字段 | 内容 |
|---|---|
| 所属轨道 | `PROD` |
| 审核等级 | `R1`（整环一次） |
| 一句话目标 | 日历展示已纳入记录的缺口待办（事前/证据/可做事后），一键深链执行。 |
| 成功标准 | `EVENT_RESEARCH_QUEUE_V1_PASS` |
| 明确不做 | 自动全量刷证据；扩工作台表单；研究门禁；上云 |
| tip（VALUE） | `fcf0450`（前环） |
| tip（本环） | 未提交 |

## 2. 仪表盘

| 项 | 值 |
|---|---|
| loop_id | `PRD-EVENT-QUEUE-03` |
| stage | V2.4 batch1 待办队列已落地 · pending_exec |
| status / next_actor | pending_exec / cursor |
| batch1 | `PRD_EVENT_QUEUE_03_BATCH1_SMOKE_PASS` |
| acceptance | 未宣称 |
| research | `ABSTAIN` |
| release | `NOT_STARTED` |

## 3. 下一条指令（Cursor）

```text
继续 V2.4：实机走查日历「研究待办」；按计划补 batch2（空态/负向/READY）或按 Human 指示调整。
不强制交 Codex，直至齐套且 Human「开」。
```

## 4. Cursor完成报告

```text
开环 PRD-EVENT-QUEUE-03；归档 VALUE-02 镜像 → docs/ai-collab/闭环归档/PRD-EVENT-VALUE-02.md
计划：产品发展执行计划_V2.4_已纳入研究待办队列_2026-07-25.md
batch1：
- listAdoptedActionQueue + nextAction 事后门禁（解锁才 open_post）
- calendarQueuePrompt UI + 空态
- focus=open_post
- smoke：scripts/smoke_prd_event_queue_03_batch1.js → PASS
未宣称 QUEUE / RESEARCH / DATA_QUALITY / RELEASE PASS
本地：http://127.0.0.1:8013/propagation.html?tab=calendar
```

## 5. Codex反馈

```text
（本批次不交审）
```

## 6. 回合历史

| turn | actor | 动作 | 结果 |
|---|---|---|---|
| — | human | 「继续后续工作」 | 授权开新环 |
| 1 | cursor | 开 QUEUE-03 + batch1 | smoke PASS；pending_exec |

## 7. Human备注

- VALUE-02 已结案；当前唯一主环 = QUEUE-03
