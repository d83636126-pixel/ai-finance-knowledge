---
type: Cursor_Codex闭环交接板
schema_version: 2
tags: [AI协作, Cursor, Codex, V4.0, R2]
created: 2026-07-30
updated: '2026-07-30'
project: financial-alert-system
loop_id: PRD-EVENT-INTELLIGENCE-13-R2
acceptance: V4_EVIDENCE_DRAFT_INTEGRATION_R2
revision: 14
turn: 2
next_actor: 'human'
status: 'done'
max_turns: 4
last_writer: 'codex'
written_at: '2026-07-30T06:28:43.355Z'
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
> 当前状态：`pending_exec / cursor`（P1 已修，准备移交）
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
| 分级 | `C2 / R2` · **Human 特批极小收尾**（非新技术循环） |
| stage | V4.0 R2 三码点特批收尾 → 聚焦复审 |
| status / next_actor | `pending_review` / `codex` |
| HEAD | `959b326` |
| 基线 | `3ef428e` + 特批 micro-fix `959b326` |
| 范围 | 仅三个代码点 + 对应反例；不做完整技术循环 |

| 字段 | 内容 |
|---|---|
| 所属轨道 | `PROD_INTELLIGENCE` |
| 分级 | `C2 / R2` |
| stage | V4.0 R2 P1 最终关闭后集中复审（第 3 回合） |
| status / next_actor | `pending_exec` / `cursor`（即将 DONE→pending_review/codex） |
| HEAD | `3ef428e` |
| 基线 tip | `50eee41` → P1 修复 commit `3ef428e` |
| 计划 | `docs/ai-collab/产品发展执行计划_V4.0_证据驱动事件智能闭环_2026-07-30.md` |
| 回滚 | `git revert 3ef428e`（或重置该 commit） |


| 字段 | 内容 |
|---|---|
| 所属轨道 | `PROD_INTELLIGENCE` |
| 分级 | `C2 / R2` |
| stage | V4.0 R2 P1 关闭后集中复审 |
| status / next_actor | `pending_exec` / `cursor`（即将 DONE→pending_review/codex） |
| HEAD | `731adc5`（工作树含 P1 修复，未新 commit） |
| 基线 tip | `50eee41` |
| 计划 | `docs/ai-collab/产品发展执行计划_V4.0_证据驱动事件智能闭环_2026-07-30.md` |
| 回滚 | 丢弃工作树 P1 改动即可回到 `731adc5` / `50eee41` 链 |


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

必须分别报告以下子机制（相对 R2 CHANGES_REQUIRED 的关闭证据）：

| 子机制 | 必须证明 |
|---|---|
| `ACQUISITION` | 正式模式不回退 fixtures；官方刷新 A3 无真实数据时 ABSTAIN |
| `IDENTITY_BINDING` | 邻月错绑仍拒绝（回归） |
| `DETERMINISTIC_ANALYSIS` | 时间截断 + NFP revision_delta 在无 first print 时为 null |
| `INFERENCE_TRACEABILITY` | 合成历史仅 development；正式 hist 不得 READY |
| `DRAFT_PERSISTENCE` | 读取验 SHA；损坏≠not_found；同版本冲突 |
| `HUMAN_OVERRIDE_AUDIT` | 人工修订不覆盖自动稿（回归） |
| `FORMAL_INTEGRATION` | `--source official` 默认 `a3-mode=formal` |
| `DATA_ISOLATION` | smoke/负向均用临时数据根；未碰 backups |

任一 fail-open 复发均为 P1。通过前禁止 V4 产品级 PASS / Batch D。


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

**Human 特批收尾后的聚焦复审（非完整循环）**

1. 只核对 tip `959b326` 相对 Codex 第 3 回合指出的三个残存点；
2. 复跑：`npm run smoke:event-evidence-r2-p1`（含 micro_* 反例）与 A3 中 `missing_evaluated_at`；
3. 通过 → `done / human`，可进入轻量产品走查；
4. 仍失败 → 停止 V4 扩展，`3ef428e`/`959b326` 均视为未获正式集成通过的候选；
5. 禁止 Batch D / 产品 PASS 声明。

1. 只复审 commit `3ef428e` 相对四组 P1 / 七个反例的关闭证据，不扩展 Batch D；
2. 独立复跑 A1/A2/A3/Batch C + `npm run smoke:event-evidence-r2-p1`；
3. 核对七个残存反例均已 fail-closed；
4. 确认未提交 backups、未宣称产品/研究 PASS；
5. **本回合为 max_turns 内最终集中复审**：`PASS` → `done/human`；仍未通过 → 不再延长技术循环，交 Human。


1. 只复审本轮四组 P1 修复（工作树 diff），不扩展 Batch D；
2. 独立复跑：A1/A2/A3/Batch C + `npm run smoke:event-evidence-r2-p1`；
3. 确认四组反例均已 fail-closed（时间门控、版本不可变、正式无 fixture READY、revision≠0 伪造）；
4. 确认未改 backups、未宣称产品/研究 PASS；
5. 输出 `PASS` / `CHANGES_REQUIRED` / `BLOCKED`。


1. 独立检查三笔提交的精确 diff、依赖和回滚边界；
2. 审查来源解析、证据包 hash/版本、事件身份和时间语义；
3. 审查市场窗口、历史样本、ABSTAIN/BLOCKED 和非法输入；
4. 审查推理评估、路径假设、人工修订与草稿存储；
5. 用临时数据根复跑 A1、A2、A3、Batch C；
6. 在独立端口复跑证据读取、草稿生成和草稿读取；
7. 检查正式 `data/` 未被测试逻辑作为 fallback；
8. 输出 `PASS`、`CHANGES_REQUIRED` 或 `BLOCKED`，并区分 P1 与技术债。

## 4. Cursor完成报告

### Human 特批极小收尾已执行

决策：采纳 Codex 退出项 1（特批三码点收尾），不开启完整技术循环
commit：`959b3268b1273e513201e00391a5f1e7afd821f2`
基线：`3ef428e`

#### 三点关闭

1. P1-1 `computeMarketWindows`：缺失 `evaluated_at` → `evaluated_at_required` ABSTAIN
2. P1-2 `save()`：读取 current/version 后先 validateBundle + fingerprint；篡改有效 JSON 拒绝幂等/回放/覆盖
3. P1-3 `buildPreEventDraft`：`development_only` → ABSTAIN（与事后稿对齐）

#### 聚焦验证（exit 0）

| 命令 | 结果 |
|---|---|
| smoke A1 | 28/28 |
| smoke A2 | 36/36 |
| smoke A3 | 24/24（含 missing_evaluated_at） |
| smoke Batch C | 22/22 |
| smoke r2-p1 | 46/46（含 micro_p1_1/2/3） |

未提交 backups；未开 Batch D；未宣称产品 PASS。

### Cursor 最终 P1 收口（七反例）完成

```text
状态：DONE → pending_review / codex（第 3 / 最终回合）
loop_id：PRD-EVENT-INTELLIGENCE-13-R2
lease_owner：cursor-v4-r2-p1-final-20260730
commit：3ef428e3d13d6f7362da9c90f4fb33c2084287e4
未开启 Batch D；未宣称 EVENT_INTELLIGENCE_ASSIST_V1 / RESEARCH_PASS / RELEASE_PASS
未提交 data_backup_*
```

#### Git

| 项 | 值 |
|---|---|
| HEAD before claim | `d4284d5539c68c2fc4e5e8c3b140e4e65a24ff0a` |
| HEAD after | `3ef428e3d13d6f7362da9c90f4fb33c2084287e4` |
| 提交信息 | `fix: close V4 R2 P1 fail-open evidence and draft gates` |
| 工作树 | 仅交接板镜像/入口未提交；backups 仍未跟踪 |

#### 七反例关闭

1. **P1-1 pre**：`as_of` 必须严格早于 `release_at/scheduled_at`（无 actual 也不能 READY）。
2. **P1-1 windows**：非法 `evaluated_at` → 顶层 ABSTAIN。
3. **P1-1 A3**：official 刷新先 `buildBundle` 门控，再用 `surprise_vs_forecast` 做历史匹配。
4. **P1-2 save**：传入 SHA mismatch 拒绝 reseal；损坏 current/version 拒绝覆盖。
5. **P1-2 draft**：`draft_sha256` 覆盖 `generated_at` 等审计时间；篡改/损坏拒绝 overwrite。
6. **P1-3**：A3 使用同一 `data_root`；`official+development` → `development_only` 且草稿 ABSTAIN。
7. **P1-4**：`prior_first_print` 必须同时具备 source + available_at + version/hash，并写入 `prior_first_print` source_ref。

#### 验证（exit 0）

| 命令 | 结果 |
|---|---|
| `smoke:event-evidence-bundle` | 28/28 |
| `smoke:event-evidence-a2` | 36/36 |
| `smoke:event-evidence-a3` | 23/23 |
| `smoke:event-evidence-batch-c` | 22/22 |
| `smoke:event-evidence-r2-p1` | 39/39 |
| 合计 | **148**（含原 130 回归口径 + 本轮新增反例） |

#### 关键 SHA-256

```text
3c2ee173ac1077773a5b20df052e774a1a3cd8ad25dd3c7a4004588b60b31354  lib/event_evidence_bundle.js
9452d52dff648bf0bea14d403f48adf41a55c7089e5630be8ca45b54db27f0a5  lib/event_evidence_a3.js
1fd3a45ebaa1c41cbdf41b855bc62181fb558892aa2ac80b38c5453f6ee01f08  lib/macro_market_windows.js
087754deeba40a4179eb30b4561180ef8c6d9e58223efd50763aeafb8c45bf1c  lib/nfp_official_source.js
8373885d91510f2f3e7fe6282d4a854153480df94e9ddf91961396c6a275dd57  lib/event_draft_rules.js
e4c2356d1b324f186414d4e5986e519aa5ecc77b88ef001ec73209a4de21dc4b  lib/event_draft_store.js
09592e793859f4116ae1801e971fa80e8c9f5be2284b9fc38d9f4963929aef3f  scripts/refresh_event_evidence_bundle.js
877e88d2348749785476641b18075fe83468c5e05a40869e7677d25c1cd5ccb7  scripts/smoke_event_evidence_r2_p1.js
```

### Cursor P1 修复完成（待 Codex 集中复审）

```text
状态：DONE → pending_review / codex
loop_id：PRD-EVENT-INTELLIGENCE-13-R2
acceptance：V4_EVIDENCE_DRAFT_INTEGRATION_R2
lease_owner：cursor-v4-r2-p1-20260730
未提交业务代码（工作树修改，未 git commit）
未开启 Batch D；未宣称 EVENT_INTELLIGENCE_ASSIST_V1 / RESEARCH_PASS / RELEASE_PASS
未读取/删除/提交 data_backup_* 目录
```

#### Git 前后

| 项 | 值 |
|---|---|
| HEAD（领取时 / 仍未新 tip） | `731adc5f47ba5db6e843debf810bd9ec0cad0d9d`（ahead origin/master 5；tip 业务仍为 `50eee41` 链） |
| 工作树范围 | 仅四组 P1 相关 lib/scripts/fixtures/package.json + 交接板；不含 backups |
| 说明 | 本轮未建 commit；Codex 按工作树 diff 复审即可 |

#### 四组 P1 关闭要点

1. **P1-1 时间边界**：`buildBundle` 按 `available_at<=evaluated_at` 门控事实；窗口按 `evaluated_at` 截断 bars；历史匹配要求 `as_of` 并过滤样本；含 `actual` 的 bundle 不得生成 READY 事前草稿（`BLOCKED`）。
2. **P1-2 版本/完整性**：缺 `source_version` 拒绝；同版本异内容 `source_version_conflict`；bundle/草稿读取验 SHA；损坏 JSON → `corrupt_json`（≠ not_found）。
3. **P1-3 fixture 隔离**：A3 `mode=formal|development`；official 默认 formal，禁止 fixtures 回退；合成历史/bars 标 `development_only`。
4. **P1-4 NFP 修订**：Summary B 仅作 `revised_previous`；`previous` 需绑定 first print；否则 `revision_delta=null` + abstain reason，绝不填 0。

#### 验证命令与退出码

| 命令 | 退出码 | 结果 |
|---|---|---|
| `npm run smoke:event-evidence-bundle` | 0 | 28/28 |
| `npm run smoke:event-evidence-a2` | 0 | 36/36 |
| `npm run smoke:event-evidence-a3` | 0 | 23/23 |
| `npm run smoke:event-evidence-batch-c` | 0 | 22/22 |
| `npm run smoke:event-evidence-r2-p1` | 0 | 21/21（四组 P1 负向） |
| 正向合计 | 0 | 109（原 115 口径已随断言语义调整；另加 21 负向） |

#### 关键工件 SHA-256

```text
1a87fb6394426ca606742f663d45a1f0f7b679165ec9e610750d8d8d0d28f837  lib/event_evidence_bundle.js
f9adfcf3def8f835f6e0350361f622f5beba0e98cfb82db69567a742db19738b  lib/event_evidence_a3.js
fee485a6065d41496eddca3fcf3edc5b1467721992443c495c3f5330d7c51893  lib/macro_market_windows.js
80d1211214a39be0c40984ad66895ce6db8809f5fd52337f2d9aeff27eb53f0a  lib/macro_historical_stats.js
eb704a29dd81a32e2e5c8106dcf99f19b7b5242030bd9015ea287dd589abec7c  lib/macro_surprise.js
dfa5879e6677dd6656de2906090dd39c49818d56cf824c37f640f8992b430d63  lib/nfp_empsit_parser.js
0fd0c6bdc0f2f002556c3a4277cef175f88844edc2f276d880973a98a9dd3ae7  lib/nfp_official_source.js
038186d1d109c37d4afd93df44f72469a354d188d89497eaf3ed676ed20383cb  lib/event_draft_rules.js
fd1b5a77eba16a66c019931eee463cf84626aad6deef3c2057365db1330523ed  lib/event_draft_store.js
c2c79fad4661919d27e742805ca4c56622a3fa9058a4f1fb9785d599af0f8bc9  scripts/refresh_event_evidence_bundle.js
533cb5d1ababf9901171017e0fc170cae8637ab8d7a7f3c33a491bfb75529296  scripts/smoke_event_evidence_r2_p1.js
535f7b578f8970dc3d6a772129fa2aace8703eeda77c372f6f4fd5666ba0afe1  fixtures/event_evidence/history/nfp_surprise_history.json
4a5858d039bb09b161f4d428c6428dd556dd0d2ff570f8256befa1fbde5ec6ec  fixtures/event_evidence/market_bars/nfp_2025_12.bars.json
9660dfc8b92526e07d54a0c0bbc5b4853eb0ebfd0b55a489c323bce89d159dc7  fixtures/event_evidence/us_employment_2026_07.fixture.json
```

#### 修改文件清单

- `lib/event_evidence_bundle.js` / `event_evidence_a3.js` / `macro_market_windows.js` / `macro_historical_stats.js` / `macro_surprise.js`
- `lib/nfp_empsit_parser.js` / `nfp_official_source.js` / `event_draft_rules.js` / `event_draft_store.js`
- `scripts/refresh_event_evidence_bundle.js` + A2/A3/Batch C smokes + 新增 `smoke_event_evidence_r2_p1.js`
- fixtures：history/bars `development_only`；pre-release 补 `*_available_at`
- `package.json`：`smoke:event-evidence-r2-p1`

- A1：28/28；
- A2：33/33；
- A3：23/23；
- Batch C：21/21；
- contracts：271/271，`tsc` 通过；
- 独立端口 18139 API 冒烟：证据、生成、读取均成功；
- 暂存区为空；仅两个既有备份目录未跟踪。

这些结果是执行者证据，不自动等于 Codex R2 通过。

## 5. Codex复审报告

### Human 特批三码点聚焦复审：PASS

目标 tip：`959b3268b1273e513201e00391a5f1e7afd821f2`

本次只复审 Human 指定的三个代码点及其相邻回归，没有扩展 Batch D 或重新开启全量技术审计。

#### 三点结论

| 代码点 | 独立结果 | 判定 |
|---|---|---|
| 市场窗口缺 `evaluated_at` | `ABSTAIN`，reason=`evaluated_at_required` | PASS |
| 有效 JSON 篡改 current/version | 分别拒绝为 `tampered_current_refuse_use` / `tampered_version_refuse_use` | PASS |
| development-only 事前草稿 | `ABSTAIN` 且保留 `development_only=true` | PASS |

#### 验证证据

- `smoke:event-evidence-a3`：24/24 PASS；
- `smoke:event-evidence-batch-c`：22/22 PASS；
- `smoke:event-evidence-r2-p1`：46/46 PASS；
- 聚焦回归合计：92/92；
- Codex 独立临时根复现四项输出全部符合 fail-closed；
- `git diff --check 4e017c3..959b326` 通过；
- 五个改动 JS 文件 `node --check` 通过；
- 提交范围仅：
  - `lib/event_draft_rules.js`
  - `lib/event_evidence_bundle.js`
  - `lib/macro_market_windows.js`
  - `scripts/smoke_event_evidence_a3.js`
  - `scripts/smoke_event_evidence_r2_p1.js`

#### 不变量

- 未写正式产品数据；
- 两个 `data_backup_*` 未提交；
- 未开启 Batch D；
- 未接模型、页面或后台调度；
- 未声明 `EVENT_INTELLIGENCE_ASSIST_V1`、`RESEARCH_PASS`、`DATA_QUALITY_PASS` 或 `RELEASE_PASS`。

#### 验收语义

`V4_EVIDENCE_DRAFT_INTEGRATION_R2 = PASS` 仅表示本环证据包、确定性分析、formal/development 隔离和规则草稿机制通过 C2/R2 工程复审。它不等于产品价值、研究质量、外部发布或正式后台运行获批。

按 Human 指令，本环转为 `done / human`，下一步只进行轻量产品走查与后续产品方向决策。

（待 Codex **聚焦**复审 tip `959b326` 三码点后填写。此前第 3 回合结论为 BLOCKED / HUMAN_DECISION_REQUIRED，现由 Human 特批收尾。）

### 第 3 回合最终结论：BLOCKED / HUMAN_DECISION_REQUIRED

tip `3ef428e` 的修复范围符合约定，Codex 独立复跑五组检查共 **148/148 PASS**，且两个 `data_backup_*` 未提交、未开启 Batch D、未出现越权 PASS 声明。但独立于现有 smoke 的四个反例仍复现同范围 P1，故 `V4_EVIDENCE_DRAFT_INTEGRATION_R2` 不能 PASS。

#### 已确认关闭

- 事后 bundle（含或不含 actual）按合法 `as_of >= release_at` 已阻止事前稿；
- 非法字符串 `evaluated_at` 已令市场窗口 ABSTAIN；
- 正式刷新先做事实时间门控，再把门控后的 surprise 交给 A3；
- 传入 bundle SHA mismatch 已拒绝重新封签；
- 草稿审计时间戳已纳入 SHA，损坏 current 已拒绝覆盖；
- A3 已使用同一 `data_root`；
- official + development 的事后草稿已降为 ABSTAIN；
- 缺少完整来源绑定的 NFP first print 不再产生 revision `-8`。

#### 剩余 P1-1：缺失 evaluated_at 仍 fail-open

`computeMarketWindows()` 只拒绝“提供但非法”的 `evaluated_at`；完全不提供时仍使用所有 bars，实测聚合与 `dxy.t_plus_30m` 均为 `READY`。

这与本环“来源版本、evaluated_at、可知时间可追溯”和“未知时间 fail-closed”不变量冲突。正式市场窗口必须要求合法的显式评估时间；缺失同样 ABSTAIN/BLOCKED。

#### 剩余 P1-2：有效 JSON 篡改的 current/version 被信任

`save()` 只拒绝 JSON 解析损坏，没有在使用既有 current/version 前执行 `validateBundle()`：

- 修改 current 的 `notes`、保留旧 SHA 后，再保存原 bundle，返回 `ok=true`，并返回被篡改内容；
- 修改 version 的 `notes`、保留旧 SHA，移除 current 后再保存，仍返回 `ok=true`，并把被篡改 version 提升为 current。

版本不可变性因此仍未成立。读取任何既有 current/version 后，必须先验证 bundle SHA、schema 与 content fingerprint；失败时拒绝幂等、拒绝回放、拒绝覆盖。

#### 剩余 P1-3：development-only 事前草稿仍可 READY

`buildPostEventDraft()` 已对 `bundle.development_only` 降级，但 `buildPreEventDraft()` 没有同等门禁。对发布前的 development-only bundle，实测 `pre_event_prep = READY_FOR_REVIEW`。

这仍允许 fixture/synthetic 数据形成看似正式的事前草稿。两种 draft 都必须继承 `DEVELOPMENT_ONLY/ABSTAIN`；不得只保护事后稿。

#### 子机制最终判定

| 子机制 | 状态 |
|---|---|
| ACQUISITION | PASS |
| IDENTITY_BINDING | PASS |
| DETERMINISTIC_ANALYSIS | BLOCKED（缺 evaluated_at 可 READY） |
| INFERENCE_TRACEABILITY | BLOCKED（development-only pre 可 READY） |
| DRAFT_PERSISTENCE | BLOCKED（有效 JSON 篡改版本被信任） |
| HUMAN_OVERRIDE_AUDIT | PASS |
| FORMAL_INTEGRATION | BLOCKED |
| DATA_ISOLATION | PASS |

#### 退出决定

本轮已是约定的第 3 / 最终集中复审，不再自动切回 Cursor 开启新技术循环。交 Human 在以下两项中决策：

1. 特批一次严格限于上述三个最小代码点及对应反例的收尾修复；或
2. 停止 V4 扩展，保留 `3ef428e` 为未通过正式集成的工程候选。

在 Human 决定前：不声明 `EVENT_INTELLIGENCE_ASSIST_V1`、不启动 Batch D、不启用正式后台调度。

（待 Codex 第 3 回合最终集中复审后填写。）


### 本轮结论：CHANGES_REQUIRED

工作树相对 `731adc5` 的 P1 修复方向正确，执行者五组 smoke 由 Codex 独立复跑后共 **130/130 PASS**（28 + 36 + 23 + 22 + 21），`git diff --check` 与全部改动 JS 的语法检查也通过；但额外反例仍复现七个与原四组 P1 同类的 fail-open，因此不能判定关闭。

#### 已确认关闭或保持

- 邻月身份错绑仍会拒绝；
- 缺 `source_version` 的 `buildBundle` 已拒绝；
- 当前 bundle/草稿正文普通字段篡改可在读取时发现；
- 默认 `official` A3 模式不再自动回退仓库 fixtures；
- EMPSIT 当前发布表中的 prior cell 已不再冒充 first print；无 first print 的默认官方路径得到 `revision_delta=null`；
- 正向/现有负向 smoke 使用临时输出根，两个 `data_backup_*` 目录未纳入；
- 未开启 Batch D，未声明产品、研究或发布 PASS。

#### P1-1 仍未关闭：时间边界与事前/事后隔离

1. `evaluated_at=15:00`、`release_at=13:30`、actual 缺失的事后 bundle，仍能生成 `pre_event_prep = READY_FOR_REVIEW`。当前只检查 actual 是否存在，没有检查 `as_of < release_at`。
2. `computeMarketWindows(evaluated_at="not-an-iso-time")` 会忽略非法时间并返回 `READY`，而不是 ABSTAIN/BLOCKED。
3. 正式刷新在 `buildBundle` 时间门控之前，直接用原始 actual/forecast 计算 A3 surprise；时间倒置时仍可能把事后 surprise 送入历史匹配。

**最小关闭：** 事前草稿必须强制 `as_of < scheduled_at/release_at`，未知或非法时间 fail-closed；市场窗口必须要求合法 `evaluated_at`；A3 surprise 必须来自已通过时间门控的确定性结果，不能从原始输入提前计算。增加对应三个负向用例。

#### P1-2 仍未关闭：版本与完整性

1. 对已封签 bundle 修改 actual 而不更新 SHA 后调用 `save()`，store 会把 SHA 不匹配视为可修复并重新封签，实测保存成功且 actual=999。
2. `draft_sha256` 明确排除了 `generated_at/updated_at/saved_at`；把 `generated_at` 改为 1999 后读取仍 `ok=true`，人工修订审计时间不能防篡改。
3. `save()` 对损坏的 current/version 读取结果未 fail-closed，存在后续写入覆盖损坏证据的路径；同类问题也存在于 `saveAuto()` 对损坏 current 的处理。

**最小关闭：** 写入口遇到既有损坏或传入 SHA mismatch 必须拒绝，不得重新封签或覆盖；完整性 SHA 覆盖审计时间等全体持久化字段（仅排除 SHA 字段本身），内容幂等继续使用独立 fingerprint。补传入 bundle 篡改、时间戳篡改、损坏 current/version 后再保存的负向用例。

#### P1-3 仍未关闭：formal/development 与数据根

1. `--data-root <isolated>` 只传给 bundle store；A3 仍固定读取 `ROOT/data`。在隔离根放入完整正式 bars/history 后，CLI 仍 ABSTAIN，证明该数据根被忽略；反向也意味着隔离 smoke 可能读取正式 `ROOT/data`。
2. `--source official --a3-mode development` 会采用 fixture/synthetic A3，得到 market/history `READY`，随后 `post_event_closing = READY_FOR_REVIEW`。只有 A3 子对象带 `development_only`，bundle/草稿未被整体降级。

**最小关闭：** A3 显式接收并只读取同一个 `dataRoot`；formal CLI/API 不得读取隔离根之外数据。若允许 official+development 回放，整个 bundle 与所有派生草稿必须显式 `DEVELOPMENT_ONLY/ABSTAIN`，不得 READY；否则直接拒绝该组合。补自定义数据根正反例和 official+development 草稿反例。

#### P1-4 仍未关闭：NFP first print 来源绑定

默认缺 first print 时 `revision_delta=null` 已正确；但只需在 binding 填入 `prior_first_print=64` 和时间、不给任何来源/版本/hash，解析仍 `ok=true`，并生成 `revision_delta=-8`。`source_refs` 中没有 prior/previous 来源。

**最小关闭：** 使用 first print 前必须同时验证其来源、可知时间和不可变版本/hash，并写入独立 source ref；任一缺失则忽略该数值并保持 revision 子结论 ABSTAIN。新增“只有数值和时间、没有来源版本不得得到 -8”的负向用例。

#### 子机制判定

| 子机制 | 状态 |
|---|---|
| ACQUISITION | CHANGES_REQUIRED |
| IDENTITY_BINDING | PASS |
| DETERMINISTIC_ANALYSIS | CHANGES_REQUIRED |
| INFERENCE_TRACEABILITY | CHANGES_REQUIRED |
| DRAFT_PERSISTENCE | CHANGES_REQUIRED |
| HUMAN_OVERRIDE_AUDIT | CHANGES_REQUIRED |
| FORMAL_INTEGRATION | CHANGES_REQUIRED |
| DATA_ISOLATION | CHANGES_REQUIRED |

#### 下一轮边界

只关闭上述同范围反例；不扩展 Batch D、不接模型、不改页面、不写正式产品数据。修复后复跑 130 项现有检查，加上本轮七个反例；通过前继续禁止 V4 产品级 PASS。

（待 Codex 领取 `pending_review` 后填写。上轮结论 CHANGES_REQUIRED 见回合历史。）


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

## 6. 退出规则与回合历史

- `PASS` → `done / human`，进入轻量产品走查；
- `CHANGES_REQUIRED` → **不再自动延长技术循环**，交 Human 决定修订或停止 V4 扩展；
- `BLOCKED` → `blocked / human`；
- R2 通过前不得开启 Batch D 或正式后台调度。

### 回合历史

| 时间 (UTC) | actor | 事件 |
|---|---|---|
| 2026-07-30 | codex | R2 tip `50eee41` → CHANGES_REQUIRED（四组 P1） |
| 2026-07-30T05:21Z | cursor | claim 修四组 P1（工作树） |
| 2026-07-30T05:30Z | cursor | 移交 Codex；smoke 130 口径 |
| 2026-07-30T05:46Z | codex | 复审工作树 → **仍 CHANGES_REQUIRED**（七个残存反例）；rev7 pending_exec |
| 2026-07-30T05:53Z | cursor | claim `cursor-v4-r2-p1-final-20260730`，关闭七反例 |
| 2026-07-30T06:00Z | cursor | commit `3ef428e`；148 项（130 回归口径 + 新增反例）PASS；移交最终复审 |


- `PASS` → `done / human`，Human 决定是否轻量产品走查；
- `CHANGES_REQUIRED` → `pending_exec / cursor`，只修复明确 P1；
- `BLOCKED` → `blocked / human`；
- R2 通过前不得开启 Batch D 或正式后台调度；
- 本环结束后 REAL-USE 仍维持原有产品试运行语义。

### 回合历史

| 时间 (UTC) | actor | 事件 |
|---|---|---|
| 2026-07-30 | codex | R2 复审 tip `50eee41` → **CHANGES_REQUIRED**（四组 P1）；交接 `731adc5` / rev3→claim rev4 |
| 2026-07-30T05:21Z | cursor | claim `cursor-v4-r2-p1-20260730`，开始仅修四组 P1 |
| 2026-07-30T05:30Z | cursor | P1 修复完成：正向 smoke + `smoke:event-evidence-r2-p1` 21/21；移交 Codex 集中复审 |


- `PASS` → `done / human`，Human 决定是否进行轻量产品走查；
- `CHANGES_REQUIRED` → `pending_exec / cursor`，只修复明确 P1；
- `BLOCKED` → `blocked / human`；
- R2 通过前不得开启 Batch D 或正式后台调度；
- 本环结束后 REAL-USE 仍维持原有产品试运行语义，不因 V4 工程通过而升级结论。
