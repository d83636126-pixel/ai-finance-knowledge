---
type: Cursor_Codex闭环交接板
schema_version: 2
tags: [AI协作, Cursor, Codex, V4.3, AUTOMATION, WORK_A_D]
created: 2026-08-06
updated: '2026-08-06'
project: financial-alert-system
loop_id: PRD-EVENT-AUTOMATION-16
acceptance: EVENT_RESEARCH_AUTOMATION_V1
umbrella_acceptance: EVENT_RESEARCH_AUTOMATION_V1
revision: 3
turn: 1
next_actor: 'codex'
status: 'pending_review'
max_turns: 2
last_writer: 'cursor'
written_at: '2026-08-06T03:11:54.122Z'
lease_owner: ''
lease_actor: ''
lease_expires_at: ''
code_root: 'F:\financial-alert-system'
vault_note: AI协作记忆系统/Cursor_Codex_闭环交接板.md
repo_mirror: docs/ai-collab/Cursor_Codex_闭环交接板.md
---

# Cursor ↔ Codex 闭环交接板：V4.3 自动化运营与反馈校准

> 当前口令：**执行Cursor_Codex闭环交接板当前指令 · V4.3 Work A–D 单一产品环**

## 1. 当前裁决

- Human 于 2026-08-06 明确授权开启 V4.3。
- 允许读取现有 registry、证据包、草稿和简报状态。
- 正式新增写入仅限 `AutomationRun` 与 `HumanDecisionRecord`；C2 正式接线前必须先在隔离数据根完成验证。
- 首批样本锁定为宏观、财报、FOMC 各两条，见 §2 和 `fixtures/v43/v43_work_a_sample_manifest_v1.json`。
- 不启用后台定时调度；不新增外部来源；不改变现有研究、数据质量或发布结论。
- Work A–D 是同一个产品切片，不逐包审核。全部完成后只做一次 Codex 集中复审；仅真正阻断项允许一次最小修复和最终复审。
- **Cursor（rev3）已完成 Work A–D 完整产品切片并交审**（业务 tip 见 §3.6；本板 status=`pending_review / codex`）。隔离自检：Work A **128/0**、Work B **73/0**、Work C **28/0**、Work D **59/0**；相邻回归 V4.0 23/23+12/12、V4.1 OK、V4.2 a1 0 FAIL / d1 106/0 保持通过。六条正式 `AutomationRun` 已按 §2 授权写面写入正式 `data/automation_runs/`（幂等重跑零新增）。详见 §4。
- 本轮 0 条合格样本（六条均无已批准正式证据）→ `HUMAN_EFFORT_REDUCTION` 结论为 `ABSTAIN`（按计划 §6 不降低目标补成 PASS）。未声明 `EVENT_RESEARCH_AUTOMATION_V1`、`RESEARCH_PASS`、`DATA_QUALITY_PASS` 或 `RELEASE_PASS`。

## 2. 范围、基线与不变量

| 字段 | 值 |
|---|---|
| stage | `V4.3 自动化运营与反馈校准 · Work A–D` |
| HEAD | `53d4e44` |
| 开环基线 | `1ea3fd6` |
| 计划 | `docs/ai-collab/产品发展执行计划_V4.3_自动化运营与反馈校准_2026-08-06.md` |
| 验收合同 | `docs/ai-collab/V4.3_Work_A_开环与验收合同_2026-08-06.md` |
| 样本清单 | `fixtures/v43/v43_work_a_sample_manifest_v1.json` |
| 正式读面 | registry、event evidence bundles、event intelligence drafts、briefing state |
| 正式写面 | 仅 AutomationRun、HumanDecisionRecord；接线前先隔离验证 |
| 外部调用 | 本环未授权；已有缓存不足时 `ABSTAIN/BLOCKED` |
| 后台调度 | 禁止 |

首批六条：

1. 宏观：`us_employment_2026_07`（当前未来事件，事前路径）；
2. 宏观：`us_gdp_2026_q2_advance`（已发生，事后路径）；
3. 财报：`earnings_aapl_2026_q2`；
4. 财报：`earnings_msft_2026_q2`；
5. FOMC：`fed_fomc_2026_06`；
6. FOMC：`fed_fomc_2026_07`。

不变量：不覆盖人工内容；不把 fixture/development-only 证据冒充正式事实；错误身份、版本、时间、proof/hash 必须 fail-closed；测试不写正式 `data/`；不声明 `RESEARCH_PASS`、`DATA_QUALITY_PASS` 或 `RELEASE_PASS`。

## 3. Cursor 当前执行指令

1. 领取本板 revision 1。
2. 先完成 Work A：以锁定清单形成可复算的人工动作/空白手填 baseline，并实现候选 `AutomationRun`、`HumanDecisionRecord` schema 与隔离 store；不得接正式 API、页面或 `data/`。
3. Work A 隔离自检通过后直接连续推进 Work B–D，不为内部工作包另开复审环：
   - Work B：复用既有三类入口的一键编排与统一例外队列；
   - Work C：自动稿/人工稿差异和只读校准摘要；
   - Work D：六条样本真实产品走查与人工减负量化。
4. 正式接线只允许本板 §2 已授权写面；外部网络、正式后台调度、新来源、新阈值或自动修改规则必须停下交 Human。
5. 测试全部使用临时数据根并证明正式 registry、六份 bundle 与当前草稿哈希不变。
6. 全切片完成后提交业务 tip，并将本板交 `pending_review / codex` 做唯一一次集中复审。

## 4. Cursor 完成报告

rev3 / 2026-08-06。Work A–D 单一产品切片完成，交 Codex 唯一一次集中复审。

### 4.1 六子机制

| 子机制 | 状态 | 依据 |
|---|---|---|
| `AUTO_ELIGIBILITY` | **PASS** | 六条全部 fail-closed ABSTAIN（唯一主原因：5× `development_only_evidence_not_formal`、1× `fixture_evidence_not_formal`）；身份/阶段/来源/版本/冲突逐项判定，无一因文件存在而显示为可确认。 |
| `PIPELINE_ORCHESTRATION` | **PASS** | 一键编排按 ELIGIBILITY→EVIDENCE_REFRESH→ANALYSIS→DRAFT_GENERATION→QUEUE_ROUTING→COMPLETION 顺序执行；同 asOf 重跑幂等（6 条 run 不变、无重复）；证据版本变化→版本化新 run，旧版保留。 |
| `EXCEPTION_ROUTING` | **PASS** | 六条全部进入统一例外队列（`source_unavailable_or_unapproved` / 主动作“查看来源”），每项单一主动作，可从持久化 run 重放派生。 |
| `HUMAN_EFFORT_REDUCTION` | **ABSTAIN** | 本轮 0 条合格样本，减负基线无法形成，按计划 §6 不得降低目标补成 PASS；机制指标事实可追溯 100% PASS、异常可见 100% PASS。 |
| `REVISION_AUDIT` | **PASS** | 自动稿/人工稿字段级差异（忽略元数据/身份/来源）、HumanDecisionRecord 原因码与 changed_fields 交叉校验、校准摘要只读派生、人工内容不被覆盖（auto sha 不变）。 |
| `PRODUCT_CONTINUITY` | **PASS** | 关闭后重开 run store 全部状态可见；失败显式 ABSTAIN/BLOCKED；既有 V4.0/V4.1/V4.2 单类型回归保持通过；六条样本与 manifest SHA 逐一吻合。 |

### 4.2 六条真实样本

| event_id | 类别 | 阶段 | 标签 | final_status | 自动完成步骤 | 人工动作 | 异常主动作 | 证据类别 |
|---|---|---|---|---|---|---|---|---|
| `us_employment_2026_07` | MACRO | PRE_EVENT | CURRENT | ABSTAIN | QUEUE_ROUTING+COMPLETION | 1 | 查看来源 | FIXTURE_NOT_FORMAL |
| `us_gdp_2026_q2_advance` | MACRO | POST_EVENT | RETROSPECTIVE | ABSTAIN | QUEUE_ROUTING+COMPLETION | 1 | 查看来源 | DEVELOPMENT_ONLY_NOT_FORMAL |
| `earnings_aapl_2026_q2` | EARNINGS | POST_EVENT | RETROSPECTIVE | ABSTAIN | QUEUE_ROUTING+COMPLETION | 1 | 查看来源 | DEVELOPMENT_ONLY_NOT_FORMAL |
| `earnings_msft_2026_q2` | EARNINGS | POST_EVENT | RETROSPECTIVE | ABSTAIN | QUEUE_ROUTING+COMPLETION | 1 | 查看来源 | DEVELOPMENT_ONLY_NOT_FORMAL |
| `fed_fomc_2026_06` | FOMC | POST_EVENT | RETROSPECTIVE | ABSTAIN | QUEUE_ROUTING+COMPLETION | 1 | 查看来源 | DEVELOPMENT_ONLY_NOT_FORMAL |
| `fed_fomc_2026_07` | FOMC | POST_EVENT | RETROSPECTIVE | ABSTAIN | QUEUE_ROUTING+COMPLETION | 1 | 查看来源 | DEVELOPMENT_ONLY_NOT_FORMAL |

- 三类各两条、总六条；`us_employment_2026_07` 为当前 registry 真实待处理事件（事前路径，无 RETROSPECTIVE 标签），其余五条历史回放均带明确 `RETROSPECTIVE` 标签。
- 每条记录含自动完成步骤、人工动作、异常（例外队列）与最终状态；证据绑定含 event_id/source_version/file_sha256/scheduled_at 且与清单 SHA 一致。

### 4.3 人工动作 baseline / diff

- Work A 静态 baseline：事前路径 4 处理 + 1 队列动作；事后路径 5 处理 + 1 队列动作；8 个空白手填字段（facts/market_window/propagation_path/conclusion_1..5）。
- Work D 真实走查：六条自动完成路由+完成两步，异常集中为单一条目单一主动作（查看来源），无确认动作（0 条合格样本）；正式记录 6 条 `AutomationRun`（`validateAutomationRun` 全部通过）。
- 减负量化 `status=ABSTAIN`、`reason=no_eligible_samples_this_round`、`eligible_count=0`；机制指标 `facts_traceable_ratio`=100% PASS、`exception_visibility_ratio`=100% PASS；减负指标（无需手工刷新/生成 ≥80%、正常路径确认 ≤2、空白手填减少 ≥70%）因无合格样本为 ABSTAIN。报告：`logs/acceptance/PRD-EVENT-AUTOMATION-16/v43_work_d_walkthrough_{dryrun,commit}_*.json`。

### 4.4 数据保护哈希

- registry index SHA-256：`6EA02CA06E9A9446A9BF3C4EBE070E4115D6FE400DEC7B6E4B8478C0EDFB7E0C`（前后一致）。
- 六份 bundle 文件 SHA、六份 current draft SHA 与 manifest 逐一完全一致（全部 OK）。
- 隔离自检（Work A/B/C/D smoke）前后正式 `data/` 树 hash 不变。
- 正式接线仅新增 `data/automation_runs/`（`index.json` + 六条 run）；幂等重跑 `formal_data_unchanged=true`、零新增文件。

### 4.5 正式接入文件

- `lib/v43_auto_eligibility.js`（资格判定，fail-closed）
- `lib/v43_human_effort_baseline.js`（Work A 基线，可复算）
- `lib/v43_run_records.js`（AutomationRun/HumanDecisionRecord 隔离 store + 严格校验）
- `lib/v43_orchestration.js`（一键编排）
- `lib/v43_exception_queue.js`（统一例外队列）
- `lib/v43_revision_diff.js`（差异 + 校准摘要）
- `lib/v43_walkthrough.js`（Work D 走查 + 减负量化 + 正式写闸门）
- `scripts/smoke_v43_work_a/b/c/d.js`（隔离自检 288 断言全绿）
- `scripts/v43_daily_walkthrough.js`（真实产品走查入口：dry-run 默认 / `--commit`）
- 正式记录：`data/automation_runs/v43_daily_20260806_*.json`（六条，`validateAutomationRun` 全通过；本轮无人工决策，`human_decision_records/` 不写入）

### 4.6 回滚开关

- 正式写闸门：未设置 `FAS_V43_WRITE=authorized-20260806` 或去掉 `--commit` → 拒绝正式写（dry-run 默认）。
- 删除 `data/automation_runs/` 即移除本轮新增运行记录；现有 registry / 证据包 / 草稿 / 人工修订全部不动，V4.0/V4.1/V4.2 单类型路径继续可用。
- 不新增后台调度、不联网、不接外部来源；`research_claim / data_quality_claim / release_claim` 均为 `prohibited`。

## 5. Codex 集中复审

只在 Work A–D 完整产品切片交审后执行。聚焦：

1. `AUTO_ELIGIBILITY`：身份、阶段、正式来源和版本判断 fail-closed；
2. `PIPELINE_ORCHESTRATION`：复用既有能力、顺序正确、重复运行幂等；
3. `EXCEPTION_ROUTING`：缺失/冲突/过期/验签失败全部进入统一例外队列；
4. `HUMAN_EFFORT_REDUCTION`：符合资格样本至少 80% 无手工刷新/生成，正常路径不超过 2 次确认，空白手填减少至少 70%；
5. `REVISION_AUDIT`：自动稿、人工稿、差异和原因可追溯，人工内容不被覆盖；
6. `PRODUCT_CONTINUITY`：重开、失败恢复、六条样本和既有 V4.0–V4.2 路径可用；
7. 数据保护、权限边界和声明隔离。

PASS 后转 `done / human` 做产品验收；CHANGES_REQUIRED 只允许真正阻断项的一次最小修复，其他登记技术债。

## 6. Human 验收

当前：未验收。不得声明 `EVENT_RESEARCH_AUTOMATION_V1`。

## 7. 回合历史

- rev1 / 2026-08-06 / Human：明确授权开启 V4.3；锁定六条样本、正式读写面和“不启用后台调度”边界；交 Cursor 连续完成 Work A–D。
- rev2 / 2026-08-06 / Human：固定开环业务 tip 并交 Cursor（Work A 首步）。
- rev3 / 2026-08-06 / Cursor：完成 Work A–D 单一产品切片；隔离自检 A 128/0、B 73/0、C 28/0、D 59/0，相邻回归 V4.0/V4.1/V4.2 保持通过；正式写入六条 AutomationRun（幂等）；本板交 `pending_review / codex` 做唯一一次集中复审。未声明任何验收名。
