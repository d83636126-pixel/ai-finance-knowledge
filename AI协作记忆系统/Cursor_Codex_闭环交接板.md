---
type: Cursor_Codex闭环交接板
schema_version: 2
tags: [AI协作, Cursor, Codex, V4.0, R2]
created: 2026-07-30
updated: '2026-07-30'
project: financial-alert-system
loop_id: PRD-EVENT-INTELLIGENCE-13-R2
acceptance: V4_EVIDENCE_DRAFT_INTEGRATION_R2
revision: 3
turn: 1
next_actor: 'cursor'
status: 'pending_exec'
max_turns: 3
last_writer: 'codex'
written_at: '2026-07-30T04:11:13.288Z'
lease_owner: ''
lease_actor: ''
lease_expires_at: ''
code_root: 'F:\financial-alert-system'
vault_note: AI协作记忆系统/Cursor_Codex_闭环交接板.md
repo_mirror: docs/ai-collab/Cursor_Codex_闭环交接板.md
---

# Cursor ↔ Codex 闭环交接板

> [!important] **评审闭环交接板 · V4.0 集中 R2**
>
> 当前状态：`pending_exec / cursor`
> 只审查提交链 `7600cc0 → a1c2775 → 50eee41`，不扩展 Batch D。

## 0. 硬边界

- 本环为 `C2 / R2`，只做独立复审；
- 不运行正式后台调度，不向正式产品数据根执行刷新；
- 所有运行验证使用 fixture、临时数据根和独立端口；
- 不修改页面、今日简报 Top 3、研究门槛或 REAL-USE 事件记录；
- 不宣称 `EVENT_INTELLIGENCE_ASSIST_V1`、`RESEARCH_PASS`、`DATA_QUALITY_PASS` 或 `RELEASE_PASS`；
- 既有两个 `data_backup_*` 目录不属于本环，不读取、不删除、不提交；
- 若发现阻断，只给出最小修复范围，不在 Codex 审核角色中直接扩大实现。

## 1. 当前任务

| 字段 | 内容 |
|---|---|
| 所属轨道 | `PROD_INTELLIGENCE` |
| 分级 | `C2 / R2` |
| stage | V4.0 A1–A3 + Batch C + 正式 API 集中复审 |
| status / next_actor | `pending_review` / `codex` |
| HEAD | `50eee412fac07c528e686a9e7147d75284050ee8` |
| 提交 1 | `7600cc0` — A1–A3 证据分析基础 |
| 提交 2 | `a1c2775` — Batch C 证据约束草稿 |
| 提交 3 | `50eee41` — 正式证据与草稿服务入口 |
| 计划 | `docs/ai-collab/产品发展执行计划_V4.0_证据驱动事件智能闭环_2026-07-30.md` |
| 回滚 | 三笔提交可按倒序分别撤销 |

## 2. 验收合同

必须分别报告以下子机制：

| 子机制 | 必须证明 |
|---|---|
| `ACQUISITION` | 正式来源解析、失败停止、来源版本可追溯 |
| `IDENTITY_BINDING` | 月份、发布时间、event_id 和来源不会错配 |
| `DETERMINISTIC_ANALYSIS` | 偏差、市场窗口和历史统计可复算，样本不足弃权 |
| `INFERENCE_TRACEABILITY` | 草稿事实有证据，路径不冒充因果，缺口可见 |
| `DRAFT_PERSISTENCE` | 自动草稿、版本、重开和幂等成立 |
| `HUMAN_OVERRIDE_AUDIT` | 人工修订不覆盖自动草稿且可追溯 |
| `FORMAL_INTEGRATION` | 正式 API 只接批准能力，隔离数据根可运行 |
| `DATA_ISOLATION` | smoke、API 冒烟和测试不写正式产品数据 |

任一事实错误、身份错配、隐藏失败、正式数据污染、草稿越权或回滚失效均为 P1。

## 3. Codex 复审指令

1. 独立检查三笔提交的精确 diff、依赖和回滚边界；
2. 审查来源解析、证据包 hash/版本、事件身份和时间语义；
3. 审查市场窗口、历史样本、ABSTAIN/BLOCKED 和非法输入；
4. 审查推理评估、路径假设、人工修订与草稿存储；
5. 用临时数据根复跑 A1、A2、A3、Batch C；
6. 在独立端口复跑证据读取、草稿生成和草稿读取；
7. 检查正式 `data/` 未被测试逻辑作为 fallback；
8. 输出 `PASS`、`CHANGES_REQUIRED` 或 `BLOCKED`，并区分 P1 与技术债。

## 4. 已有执行证据（待独立复核）

- A1：28/28；
- A2：33/33；
- A3：23/23；
- Batch C：21/21；
- contracts：271/271，`tsc` 通过；
- 独立端口 18139 API 冒烟：证据、生成、读取均成功；
- 暂存区为空；仅两个既有备份目录未跟踪。

这些结果是执行者证据，不自动等于 Codex R2 通过。

## 5. Codex复审报告

### 结论：CHANGES_REQUIRED

目标 tip `50eee41` 的 A1/A2/A3/Batch C 正向 smoke 共 **115/115 PASS**，提交范围也未触及既有运行数据；但独立反例证明正式入口仍存在会制造事实错误或错误 READY 的 fail-open，因此本轮不能声明 V4 集成通过。

#### 已确认通过

- 四组既有 smoke：28/28、33/33、23/23、21/21。
- `a86863b..50eee41` 仅包含 V4 计划、fixtures、证据/草稿模块、contracts 导出、API/CLI 接线和 smoke。
- 测试使用临时数据根；未修改 `data/`，两个既有备份目录未纳入。
- 未开启 Batch D，未声明 `EVENT_INTELLIGENCE_ASSIST_V1`、`RESEARCH_PASS` 或 `RELEASE_PASS`。

#### P1-1：时间边界与事前/事后隔离 fail-open

- `evaluated_at < release_at` 且已有 actual 时，bundle 仍返回 `READY`。
- 市场窗口可以在 13:31 的评估中使用 14:00 才结束的 bar，并返回 `READY`。
- 历史统计不按 `evaluated_at/as_of` 截断，未来样本可进入匹配并返回 `READY`。
- 同一个事后 bundle 可生成标为 `pre_event_prep` 的草稿；其中 `previous/revised_previous` 也可能是发布后才可知信息。

**最小关闭条件：** 所有事实、bar、历史样本必须带并校验 `available_at/released_at <= evaluated_at/as_of`；未知或倒置一律 `ABSTAIN/BLOCKED`。正式生成入口不得把已知结果的数据冻结成“事前”草稿。补四个对应负向用例。

#### P1-2：版本不可变性与完整性 fail-open

- 缺失 `source_version` 时会用当前时间自动生成，未 fail-closed。
- 相同 `source_version`、不同内容可覆盖旧版本；回放得到新值，原证据丢失。
- 草稿文件被修改后，`loadAuto/loadHuman` 不核验已记录 SHA-256，仍返回 `ok=true`。
- 损坏 JSON 会被读路径吞掉并表现成 `not_found`，无法区分损坏与不存在。

**最小关闭条件：** 正式证据缺版本即 BLOCKED；同版本不同内容拒绝写入；版本文件不可变（或绑定内容哈希）；bundle/草稿读取强制验 SHA，损坏返回明确的完整性失败。补缺版本、同版本冲突、文件篡改、损坏 JSON 负向用例。

#### P1-3：fixture / 合成历史会泄漏到正式证据

- A3 路径解析优先搜索 `fixtures/`，正式 `--source official --with-a3` 在没有真实数据时仍自动采用 fixture market bars 和合成历史。
- 实机反例中正式 CLI 返回：`status=READY`、`market source_kind=market_bars_fixture`、`history status=READY`、`n=10`。
- `nfp_surprise_history.json` 为机械构造样本，却能支持历史统计 READY 和后续草稿判断。

**最小关闭条件：** 显式区分 `fixture/development` 与 `formal` 模式；正式模式绝不回退 fixtures；fixture/合成数据只能 `DEVELOPMENT_ONLY/ABSTAIN`，不得使正式 bundle 或草稿 READY。补“磁盘仅有 fixtures 时正式模式不得 READY”的负向用例。

#### P1-4：NFP previous / revision 语义错误

- 官方解析路径把 `previous=56` 与 `revised_previous=56` 设为同值，进而得到 `change_vs_previous=-6`、`revision_delta=0`。
- A1 证明口径却是原始 previous `64`、修订后 `56`，即 `change=-14`、`revision=-8`。当前正式路径将“拿不到原始前值”误写成“没有修订”。

**最小关闭条件：** 区分 prior first print 与 revised prior；无法从绑定来源取得 first print 时，`revision_delta=null` 且该子结论 `ABSTAIN`，不得填 0。若要保留 `-8`，必须绑定可复算的原始来源及版本。补正式入口语义负向用例。

#### 六子机制状态

| 子机制 | 状态 | 说明 |
|---|---|---|
| ACQUISITION | CHANGES_REQUIRED | 正式入口可回退 fixture |
| IDENTITY_BINDING | PASS | 邻月错绑反例已拒绝 |
| DETERMINISTIC_ANALYSIS | CHANGES_REQUIRED | 时间截断与 NFP 修订语义错误 |
| INFERENCE_TRACEABILITY | CHANGES_REQUIRED | 合成历史可支持 READY |
| DRAFT_PERSISTENCE | CHANGES_REQUIRED | SHA 记录存在但读取不验证 |
| HUMAN_OVERRIDE_AUDIT | PASS_WITH_DEBT | 自动稿/人工稿分离成立；完整性归 P1-2 |
| FORMAL_INTEGRATION | CHANGES_REQUIRED | 正式 API/CLI 已接通，但继承上述 fail-open |
| DATA_ISOLATION | PASS | 正向与反例均使用临时数据根 |

#### 下一轮边界

只关闭以上四组 P1，不扩展 Batch D、不新增模型能力、不继续技术美化。修复后集中复审这些反例与原 115 项回归；通过前继续禁止 V4 产品级 PASS 声明。

## 6. 退出规则

- `PASS` → `done / human`，Human 决定是否进行轻量产品走查；
- `CHANGES_REQUIRED` → `pending_exec / cursor`，只修复明确 P1；
- `BLOCKED` → `blocked / human`；
- R2 通过前不得开启 Batch D 或正式后台调度；
- 本环结束后 REAL-USE 仍维持原有产品试运行语义，不因 V4 工程通过而升级结论。
