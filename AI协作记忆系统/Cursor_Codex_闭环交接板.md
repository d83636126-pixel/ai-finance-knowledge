---
type: Cursor_Codex闭环交接板
schema_version: 2
tags: [AI协作, Cursor, Codex, V4.3, AUTOMATION, WORK_A]
created: 2026-08-06
updated: '2026-08-06'
project: financial-alert-system
loop_id: PRD-EVENT-AUTOMATION-16
acceptance: EVENT_RESEARCH_AUTOMATION_V1
umbrella_acceptance: EVENT_RESEARCH_AUTOMATION_V1
revision: 2
turn: 0
next_actor: 'cursor'
status: 'pending_exec'
max_turns: 2
last_writer: 'human'
written_at: '2026-08-06T02:42:04.039Z'
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

待执行。报告必须分别列出六子机制、六条真实样本、人工动作 baseline/diff、数据保护哈希、正式接入文件和回滚开关。

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
