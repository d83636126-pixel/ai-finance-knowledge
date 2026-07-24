---
type: Cursor_Codex闭环交接板
schema_version: 2
tags: [AI协作, Cursor, Codex, Obsidian, 闭环, PRD-EVENT-01, 事件研究工作台]
created: 2026-07-25
updated: '2026-07-24'
project: financial-alert-system
loop_id: PRD-EVENT-01
revision: 12
turn: 2
next_actor: 'cursor'
status: 'pending_exec'
max_turns: 8
last_writer: 'cursor'
written_at: '2026-07-24T19:07:03.052Z'
lease_owner: 'cursor-prd-event-01-occurred-ux-20260725'
lease_actor: 'cursor'
lease_expires_at: '2026-07-24T20:07:03.052Z'
code_root: F:\financial-alert-system
vault_note: AI协作记忆系统/Cursor_Codex_闭环交接板.md
repo_mirror: docs/ai-collab/Cursor_Codex_闭环交接板.md
---

# Cursor ↔ Codex 闭环交接板

> [!important] 当前执行：**PRD-EVENT-01 · 事件研究工作台 V1**
>
> 第一+第二产品批次已交付；**仍不交 Codex**（待你实机确认后再集中 R1）。
> 本地地址：`http://127.0.0.1:8013/event_research_workspace.html`
> 未宣称：`EVENT_RESEARCH_WORKSPACE_V1_PASS` / `RESEARCH_PASS`

## 0. 闭环协议

```text
Human 开环 PRD-EVENT-01
→ Cursor 产品批次连续交付（不按模块交 Codex）
→ 产品 V1 齐套且 Human 确认后一次 Codex R1
→ PASS / CHANGES_REQUIRED / BLOCKED
```

### 0.1 硬边界

- 允许：复用现有能力；收件箱；研究工作台；时间历史；专题/子事件；财报模板；版本比较；复盘
- 禁止：新开 OPS / DATA / RESEARCH 独立技术环；宣称 RESEARCH_PASS / EVENT_RESEARCH_WORKSPACE_V1_PASS（未经集中 R1）；静默 mock 当真数据
- `nfp_2026_07`：`LIVE_FORWARD_OBSERVATION`

## 1. 任务目标

| 字段 | 内容 |
|---|---|
| 所属轨道 | `PROD` |
| 审核等级 | `R1`（整环结束集中一次） |
| 一句话目标 | 用户可在页面完成事件进入、研究判断、保存与重开。 |
| 成功标准 | `EVENT_RESEARCH_WORKSPACE_V1_PASS` |
| 明确不做 | 不等待未来事件发生；不研究有效性门禁 |

## 2. 仪表盘

| 项 | 值 |
|---|---|
| loop_id | `PRD-EVENT-01` |
| stage | PRD-EVENT-01 事件研究工作台 V1 |
| status / next_actor | pending_exec / cursor |
| HEAD | `9f02553`（工作树含未提交产品页） |
| batch1 | DONE |
| batch2 | DONE（时间历史/专题/财报/比较/复盘） |
| local_url | `http://127.0.0.1:8013/event_research_workspace.html` |
| smoke | `PRD_EVENT_01_BATCH2_SMOKE_PASS` |
| acceptance | 功能接近 V1；**未宣称 PASS** |
| nfp_2026_07 | `LIVE_FORWARD_OBSERVATION` |
| research | `ABSTAIN` |
| release | `NOT_STARTED` |

## 3. 下一条Cursor指令

```text
等待 Human 实机确认产品方向。

若确认方向正确：
- 可整理未提交产品文件并按 Human 指示提交；
- 再交一次集中 Codex R1（目标 tip 以提交后为准），验收 EVENT_RESEARCH_WORKSPACE_V1_PASS。

若需调整：按 Human 反馈继续改产品页，仍不交 Codex。
```

## 4. Cursor完成报告

```text
状态：第二产品批次已交付（继续 pending_exec，不交 Codex）
verdict：BATCH2_DONE_CONTINUE
summary：在 batch1 基础上完成：时间截面/更新历史（待排期可升级且旧记录保留）；持续专题与子事件挂接；公司财报模板；判断版本比较；事件复盘（进入等待复盘并可重开）。浏览器验证 compare/updateSchedule/topic children/earnings/review 均通过。未宣称 RESEARCH_PASS / EVENT_RESEARCH_WORKSPACE_V1_PASS。
evidence：
- git_before_HEAD：9f025530b1c2cc6cfbc754fe77b66bfb21d5871e
- git_after_HEAD：9f025530b1c2cc6cfbc754fe77b66bfb21d5871e（仍未提交产品文件）
- local_url：http://127.0.0.1:8013/event_research_workspace.html
- demos：cpi / fed_undated / tariff_breaking / trade_topic / tariff_window / earnings_aapl
- SHA-256：
  - event_research_workspace.html = 7a551ab879973e67c9821c4fee5c9fd38d14fbf43197d8622184b0b0888b9ca0
  - static/event_research_store.js = 99cd2091e0ad04422e76e094c6f48986e09283b73460c12ebe4601916e0a3b09
  - static/event_research_app.js = 984fd12333f2f601fddfa89a76e2c7e826cf0eae5ce8cf95655a9d2f87fbe313
  - scripts/smoke_prd_event_01_batch2.js = e87324646db6d64d6c32347e599b6139124b38baeed41fa033f58b176f5b1860
- verify：
  - node scripts/smoke_prd_event_01_batch2.js → exit 0 → PRD_EVENT_01_BATCH2_SMOKE_PASS
  - browser CDP：cmp_changed=6；fed 升级 calendar_fixed 且 hist_grew；topic kids=[breaking,window]；earnings 模板存在；review→awaiting_review
- not_claimed：RESEARCH_PASS / EVENT_RESEARCH_WORKSPACE_V1_PASS
```

## 5. Codex反馈

```text
（整环齐套且 Human 确认后一次 R1）
```

## 6. 回合历史

| turn | actor | 动作 | 结果 |
|---|---|---|---|
| — | human | 归档 loop-030；开启 PRD-EVENT-01 | 开环 |
| 1 | cursor | 第一产品批次 | BATCH1_DONE_CONTINUE |
| 2 | cursor | 第二产品批次（时间/专题/财报/比较/复盘） | BATCH2_DONE_CONTINUE |

## 7. Human备注

- 请直接打开本地地址试用；确认方向后再决定提交与集中 R1
- 示例中的财报数值为手工演示，research_credit=false
