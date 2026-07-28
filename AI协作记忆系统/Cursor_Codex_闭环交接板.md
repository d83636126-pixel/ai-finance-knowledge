---
type: Cursor_Codex闭环交接板
schema_version: 2
tags: [AI协作, Cursor, Codex, Obsidian, 真实运营, REAL-USE-01]
created: 2026-07-28
updated: '2026-07-28'
project: financial-alert-system
loop_id: REAL-USE-01
acceptance: REAL_EVENT_OPERATION_PILOT_V1
revision: 16
turn: 1
next_actor: 'human'
status: 'idle'
max_turns: 3
last_writer: 'cursor'
written_at: '2026-07-28T19:44:00+08:00'
lease_owner: ''
lease_actor: ''
lease_expires_at: ''
code_root: 'F:\financial-alert-system'
vault_note: AI协作记忆系统/Cursor_Codex_闭环交接板.md
repo_mirror: docs/ai-collab/Cursor_Codex_闭环交接板.md
---

# Cursor ↔ Codex 闭环交接板

> [!important] **执行Cursor_Codex闭环交接板当前指令** · REAL-USE-01 Day 0
>
> 当前状态：`idle / human`
> 本环不是新功能开发，而是 14 天真实事件运营试运行的启动与 Day 0 数据准备。

## 0. 硬边界

- 试运行期：2026-07-29 至 2026-08-11；
- 仅使用现有产品能力，不扩建新模块；
- 每个事件不做 Codex 审核；
- 只有真实 P1、数据损坏、安全或事实错误才开最小修复；
- 历史样本只作 `RETROSPECTIVE`，不得包装成事前判断；
- 不宣称 `RESEARCH_PASS`、`DATA_QUALITY_PASS` 或 `RELEASE_PASS`。

## 1. 当前任务

| 字段 | 内容 |
|---|---|
| 所属轨道 | `PROD_USE` |
| stage | REAL-USE-01 Day 0 事件纳入与事前冻结 |
| status / next_actor | `pending_exec` / `cursor` |
| HEAD | `73ebe59` |
| 产品基线 | `e50c46c` |
| 执行计划 | `docs/ai-collab/真实事件运营试运行计划_REAL-USE-01_2026-07-28.md` |
| 事件篮子与日志 | `docs/ai-collab/真实事件运营试运行_REAL-USE-01_事件篮子与执行日志_2026-07-29.md` |

## 2. Day 0 只执行以下内容

1. 启动现有本地产品并确认今日简报可打开；
2. 通过现有受支持入口纳入缺失事件：
   - `us_gdp_2026_q2_advance`
   - `us_employment_2026_07`
   - `us_qoz_proposed_rules_2026`
3. 为六项核心事件绑定交接日志中列出的权威来源；
4. 核对事件身份，不得错误合并；
5. 在发布前为以下三项冻结 checkpoint，并保留不可变证据：
   - `fed_fomc_2026_07`
   - `us_gdp_2026_q2_advance`
   - `us_employment_2026_07`
6. QOZ 事件必须使用 `SOURCE_TIME_UNCERTAIN`，不得填造精确发布时间；
7. 记录 Day 1 数据根和资产数量。

## 3. 明确不做

- 不新增接口、页面或数据库；
- 不补跑全量技术验收；
- 不把微软、谷歌财报计入本轮核心证据；
- 不对历史事件补写事前预测；
- 不为完成 checkpoint 而绕过现有产品入口；
- 不提前声明 `REAL_EVENT_OPERATION_PILOT_V1`。

## 4. Day 0 完成条件

- 三项缺失事件已由受支持入口纳入并能重新打开；
- 六项事件身份与来源无错配；
- 三项未来日历事件在正式发布前冻结 checkpoint；
- QOZ 时间状态诚实为不确定；
- 日志只记录进展，不复制产品事实；
- 无数据损坏或 P1 产品阻断。

Day 0 完成后把本板切为 `idle / human`，Human 从 2026-07-29 开始按每日简报真实使用。中途不设集中技术 PASS。

## 5. 退出与升级

- 若 Day 0 只出现文案、布局、排序、更多测试等问题：登记观察并继续；
- 若事件无法保存/重开、身份错配、checkpoint 可被无痕改写或数据损坏：停止并交 Human；
- Day 7 只做轻量产品复盘；
- Day 14 才集中判定 `REAL_EVENT_OPERATION_PILOT_V1`。
