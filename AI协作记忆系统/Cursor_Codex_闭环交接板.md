---
type: Cursor_Codex闭环交接板
schema_version: 2
tags: [AI协作, Cursor, Codex, V4.0, Batch-D, 产品]
created: 2026-07-30
updated: '2026-07-30'
project: financial-alert-system
loop_id: PRD-EVENT-INTELLIGENCE-13-D
acceptance: EVENT_INTELLIGENCE_ASSIST_V1
revision: 23
turn: 1
next_actor: 'human'
status: 'done'
max_turns: 3
last_writer: 'human'
written_at: '2026-07-30T12:27:59.338Z'
lease_owner: ''
lease_actor: ''
lease_expires_at: ''
code_root: 'F:\financial-alert-system'
vault_note: AI协作记忆系统/Cursor_Codex_闭环交接板.md
repo_mirror: docs/ai-collab/Cursor_Codex_闭环交接板.md
---

# Cursor ↔ Codex 闭环交接板：V4.0 Batch D

> 当前口令：**执行Cursor_Codex闭环交接板当前指令 · V4 Batch D**

## 1. 当前裁决

- **Human 指令**：Codex 暂不复查；跳过 pending_review，继续推进。
- Batch D 整改 tip `30ce813` 进入 Human `:8013` 真实使用核对。
- **`EVENT_INTELLIGENCE_ASSIST_V1` 仍未通过**（须 Human 真实走查后再议）。
- 不开启新 Batch / 不扩模型 / 不扩研究门禁。

- Codex 曾对 `0c6cb4a` 裁决 `CHANGES_REQUIRED`（FOMC 断链 / GET 非幂等 / 财报 EMPSIT 语义）。
- Cursor 已关闭上述三项 P1，tip `30ce813`。
- 请 Codex 聚焦复审；**`EVENT_INTELLIGENCE_ASSIST_V1` 保持未通过**。

- Human 已将 Batch D 退回整改；Cursor 已关闭真实事件闭环五步，tip `0c6cb4a`。
- 请 Codex 聚焦复审：事前隐藏收尾、自动最小证据、ABSTAIN 非报错、发生后切事后、AAPL/AMZN/GDP 走查。
- **`EVENT_INTELLIGENCE_ASSIST_V1` 保持未通过**；禁止推进下一阶段。

- **Human 指令（优先于 done）**：Batch D 退回整改。Codex 虽通过简报动作过滤，但真实事件闭环仍断。
- 核心断点：真实事件进入简报后，**不能**自动形成证据 → 事前草稿 → 发生后收尾卡。
- `EVENT_INTELLIGENCE_ASSIST_V1` **保持未通过**；禁止推进下一阶段 / 扩展新能力。
- 本轮 Cursor 仅关闭下列五项最小修复，然后交 Codex 复审。

- Cursor 已关闭动作过滤残留（snooze 绑定 / MISSING 重开 / legacy 字符串）与四个聚焦反例，tip `df48cde`。
- 请 Codex **最后一次聚焦复审**；通过后交 Human `:8013` 真实使用。
- **尚未声明** `EVENT_INTELLIGENCE_ASSIST_V1`。

- Codex 聚焦复审 `3c4a67d` 曾裁决 `CHANGES_REQUIRED`（动作过滤残留）。
- Cursor 已关闭三组 P1 主路径（tip `3c4a67d`）及本轮残留。
- 硬边界不变：不扩模型/研究门禁/UI；不碰 `data_backup_*`。

- Cursor 已关闭动作过滤残留（snooze 绑定 / MISSING 重开 / legacy 字符串）与四个聚焦反例，tip `df48cde`。
- 请 Codex **最后一次聚焦复审**；通过后交 Human `:8013` 真实使用。
- **尚未声明** `EVENT_INTELLIGENCE_ASSIST_V1`。

- Codex 聚焦复审 `3c4a67d` 曾裁决 `CHANGES_REQUIRED`（动作过滤残留）。
- Cursor 已关闭三组 P1 主路径（tip `3c4a67d`）及本轮残留。
- 硬边界不变：不扩模型/研究门禁/UI；不碰 `data_backup_*`。

- Codex R1 曾裁决 `CHANGES_REQUIRED`（三组 P1）。
- Cursor 已关闭三组 P1 与对应反例，tip `3c4a67d`。
- 请 Codex **聚焦复审**本环 P1 关闭；通过后再交 Human `:8013` 真实使用。
- **尚未声明** `EVENT_INTELLIGENCE_ASSIST_V1`。

- Cursor 已完成 V4 Batch D 最小交付，提交 tip `dde0e28`。
- 本环等待 Codex 一次集中 R1；通过后交 Human 真实使用走查。
- **尚未声明** `EVENT_INTELLIGENCE_ASSIST_V1`。

- Human 已批准开启 V4 Batch D「智能简报与真实使用」。
- Batch C 产品 P1 已在 `d267f8d` 收尾并完成真实浏览器复走查。
- 本环仅完成 V4 计划中 Batch D，不扩展新模型、研究门禁、外部部署或新架构。
- 本环结束只做一次集中 R1；非产品阻断问题登记技术债，不重复拖延产品主线。
- 当前尚未声明 `EVENT_INTELLIGENCE_ASSIST_V1`。

## 2. 基线与边界

| 项 | 值 |
|---|---|
| 本环 tip | `30ce813` (`30ce8132d9a37085c7da95cb7d2de235a83e9c21`) |
| 开环 | `PRD-EVENT-INTELLIGENCE-13-D` |
| status / next_actor | `done` / `human` |
| 正式入口 | `http://127.0.0.1:8013/daily_briefing.html` |
| 回滚点 | `git reset --hard 0c6cb4a`（丢弃三项 P1）或 `df48cde` |

硬边界：验收名未声明；不碰 `data_backup_*`；本阶段以 Human 真实刷新核对为主。

| 项 | 值 |
|---|---|
| 上轮 tip | `0c6cb4a` |
| 本环 tip | `30ce813` (`30ce8132d9a37085c7da95cb7d2de235a83e9c21`) |
| 开环 | `PRD-EVENT-INTELLIGENCE-13-D`（整改） |
| 执行者 | Cursor（三项 P1 已关） |
| 复审者 | Codex |
| 回滚点 | `git reset --hard 0c6cb4a` |

硬边界：只修三项真实使用 P1；不扩模型/研究门禁/UI；不声明总验收名。

| 项 | 值 |
|---|---|
| 整改基线 | `df48cde` |
| 本环 tip | `0c6cb4a` (`0c6cb4a27252acbabf959e06db22348de35b999e`) |
| 开环 | `PRD-EVENT-INTELLIGENCE-13-D`（整改） |
| 执行者 | Cursor（五步已交） |
| 复审者 | Codex |
| 回滚点 | `git reset --hard df48cde` |

硬边界：不扩模型/研究门禁/新能力；不碰 `data_backup_*`；不声明总验收名。

| 项 | 值 |
|---|---|
| 开环 tip | `df48cde`（整改基线） |
| 本环 tip | （整改中） |
| 开环 | `PRD-EVENT-INTELLIGENCE-13-D`（退回整改） |
| 执行者 | Cursor |
| 复审者 | Codex |
| 回滚点 | `git reset --hard df48cde` |

硬边界：

1. 只修真实事件闭环五步，不扩模型/研究门禁/新 UI 能力。
2. 不碰 `data_backup_*`。
3. **不声明** `EVENT_INTELLIGENCE_ASSIST_V1` / `RESEARCH_PASS` / `RELEASE_PASS`。
4. 用当前真实事件 `earnings_aapl_2026_q2`、`earnings_amzn_2026_q2`、`us_gdp_2026_q2_advance` 走查。

| 项 | 值 |
|---|---|
| 开环 tip | `d267f8d` |
| 上轮 tip | `3c4a67d` |
| 本环 tip | `df48cde` (`df48cde33481a5fe41af478f26d01701957d920d`) |
| 开环 | `PRD-EVENT-INTELLIGENCE-13-D` |
| 执行者 | Cursor（动作过滤残留已关） |
| 复审者 | Codex（最后一次聚焦复审） |
| 回滚点 | `git reset --hard 3c4a67d` |

硬边界不变：不扩模型/研究门禁/UI；不碰 `data_backup_*`；不声明总验收名。

正式本地入口：`http://127.0.0.1:8013/daily_briefing.html`

| 项 | 值 |
|---|---|
| 开环 tip | `d267f8d` |
| 上轮 tip | `3c4a67d` |
| 本环 tip | `df48cde` (`df48cde33481a5fe41af478f26d01701957d920d`) |
| 开环 | `PRD-EVENT-INTELLIGENCE-13-D` |
| 执行者 | Cursor（动作过滤残留已关） |
| 复审者 | Codex（最后一次聚焦复审） |
| 回滚点 | `git reset --hard 3c4a67d` |

硬边界不变：不扩模型/研究门禁/UI；不碰 `data_backup_*`；不声明总验收名。

正式本地入口：`http://127.0.0.1:8013/daily_briefing.html`

| 项 | 值 |
|---|---|
| 开环 tip | `d267f8d` |
| 上轮 tip | `dde0e28` |
| 本环 tip | `3c4a67d` (`3c4a67db6d3fa3038daf7e3ee7cb7dc2432e177f`) |
| 开环 | `PRD-EVENT-INTELLIGENCE-13-D` |
| 执行者 | Cursor（P1 关闭完成） |
| 复审者 | Codex（聚焦复审三组 P1） |
| 回滚点 | `git reset --hard dde0e28` |

硬边界不变：不扩模型/研究门禁/UI；不碰 `data_backup_*`；不声明总验收名。

| 项 | 值 |
|---|---|
| 开环 tip | `d267f8d` |
| 本环 tip | `dde0e28` (`dde0e2884290a8422413df390d374138ae635a05`) |
| 开环 | `PRD-EVENT-INTELLIGENCE-13-D` |
| 执行者 | Cursor（已完成） |
| 复审者 | Codex（一次集中 R1） |
| 最终产品验收 | Human |
| 正式本地入口 | `http://127.0.0.1:8013/daily_briefing.html` |
| 回滚点 | `git reset --hard d267f8d`（丢弃 Batch D commit） |

硬边界仍有效：不声明 RESEARCH/DATA_QUALITY/RELEASE PASS；不碰 `data_backup_*`；不扩模型。

| 项 | 值 |
|---|---|
| code_tip | `d267f8d` |
| stage | V4.0 Batch D 智能简报与真实使用 |
| 开环 | `PRD-EVENT-INTELLIGENCE-13-D` |
| 执行者 | Cursor |
| 复审者 | Codex（一次集中 R1） |
| 最终产品验收 | Human |
| 正式本地入口 | `http://127.0.0.1:8013/daily_briefing.html` |

硬边界：

1. 复用现有每日简报、证据包、智能草稿、事件台账和收尾卡，不重写前端框架。
2. Human 已授权本地产品范围内的受控接线与真实使用；不授权外部发布、付费模型或新增常驻任务。
3. 不改 held-out/forward、研究阈值和研究信用；不得声明 `RESEARCH_PASS`、`DATA_QUALITY_PASS` 或 `RELEASE_PASS`。
4. AI 输出仍是证据驱动草稿；保留 `AI_AUTO` / `HUMAN_CONFIRMED` 分离、来源、弃权和只填空白字段规则。
5. 两个 `data_backup_*` 目录继续排除，不提交、不删除、不改写。
6. `EVENT_INTELLIGENCE_ASSIST_V1` 只有在 Codex R1 通过且 Human 完成真实使用走查后才能声明。

## 3. Cursor 当前执行指令

### 3.1 整改目标

打通：真实事件进入简报 → 自动最小证据 → 生成事前草稿 → 事件发生后进入收尾卡/事后草稿。

### 3.2 最小交付（仅此五项）

1. 未发生事件只显示事前入口，隐藏收尾卡创建/入口。
2. 为真实日历/registry 事件自动创建最小 evidence bundle（含 EARNINGS 与 economic_data→GDP）。
3. 证据不足时输出有理由的 `ABSTAIN` 草稿，而不是 API 报错。
4. 事件发生后自动切换到收尾卡路径并生成事后草稿。
5. 用 AAPL、AMZN、GDP 三条真实事件重新走查（可隔离数据根，但记录必须来自真实 registry 内容）。

### 3.3 交付纪律

1. 先 claim 租约再改业务代码。
2. 只提交闭环相关文件；不提交备份目录。
3. 完成后 `pending_review / codex`，写 tip 与走查证据，然后停止。

### 3.1 产品目标

让用户打开每日简报后，在 10 秒内知道最值得处理的 3 件事、为什么优先，以及下一步应进入哪份草稿或记录。

### 3.2 最小交付

1. 在现有简报上接入 V4 确定性智能优先级；候选依据至少覆盖：
   - 新事实或证据刷新；
   - 事件时间窗口；
   - `FAIL / ABSTAIN / BLOCKED / 缺证据` 等异常状态；
   - 已生成、待人工确认的事前或事后草稿。
2. Top 3 不重复，每条展示机器可读且用户可理解的优先理由，不得用无证据的 AI 叙事代替排序依据。
3. 每条从简报直达准确动作：事前草稿、事后草稿、研究记录或事件收尾卡；不得只打开模糊首页。
4. 完成动作后，仅在权威证据或任务状态确已解决时退出对应任务；保留“稍后处理”，禁止仅靠前端按钮伪完成。
5. 至少完成 3 个结构化宏观事件的真实走查或历史时点回放：
   - 一条历史 NFP，事后草稿可确认；
   - 一条未来就业事件，事前可用、事后明确弃权；
   - 一条 CPI 或 GDP 历史事件，用于验证跨类型兼容。
6. 若正式来源、时间或必需字段不足，页面和 API 必须显式 `ABSTAIN` 或 development 标识，不得补造事实。

### 3.3 验收用例

- 打开简报 10 秒内可说清 Top 3 及每条优先原因。
- 单事件从简报到完成或确认不超过 2 次人工确认。
- 接口、证据、草稿或保存失败必须显式报错，不得静默退出任务。
- 简报任务状态与证据包、草稿和台账权威状态一致。
- 关闭浏览器并重新打开后，待办、稍后处理和草稿仍可继续。
- 三条事件走查均保留可复跑证据，测试不得污染真实产品数据。

### 3.4 交付纪律

1. 先领取租约，再改业务文件。
2. 测试优先使用隔离数据根和隔离端口；正式 `:8013` 仅用于最后受控产品检查。
3. 只提交 Batch D 文件；既有 dirty 与备份目录不纳入。
4. 完成后把本板更新为 `pending_review / codex`，写明代码 tip、走查证据、未完成项和回滚点，然后停止。

## 4. Cursor 执行报告

### 三项真实使用 P1 关闭摘要（相对 `0c6cb4a`）

1. **FOMC/未知类型不断链**：`buildGenericAbstainBundle` 保留原始 `event_type`（如 `calendar`），ABSTAIN、不伪造数值；覆盖 `cal_d2h5h`。
2. **简报 GET 幂等 + 历史只读**：相同 `bundle_sha256` 复用草稿（`idempotent=true`）；非当天 `evaluated_at` 以 `write:false` 零写入。
3. **财报文案**：EARNINGS 不再缺 `event_type`、不再出现 EMPSIT；`nextTimeLookFor` 按类型降级。

### Git

- 前 HEAD：`0c6cb4a`
- 后 HEAD：`30ce813` / `30ce8132d9a37085c7da95cb7d2de235a83e9c21`
- 文件：`lib/event_loop_ensure.js`、`lib/event_evidence_bundle.js`、`lib/macro_surprise.js`、`lib/event_draft_rules.js`、`local_server.js`、`scripts/smoke_v4_real_event_loop.js`

### 验证

| 命令 | 结果 |
|---|---|
| `node scripts/smoke_v4_real_event_loop.js` | **50/50 PASS**（含 FOMC/幂等/历史只读/EARNINGS 反例） |
| `node scripts/smoke_v4_batch_d_walkthrough.js` | **66/66 PASS** |
| `node scripts/smoke_closing_card_draft_fill.js` | **19/19 PASS** |

工件 SHA-256：

- `lib/event_loop_ensure.js` `1eeb7367c3adf44d611fafe806a55f93a382279fc220cf099a3cafb543047be1`
- `local_server.js` `6280d783d298dfae7ee971ceb6fd75eb5fb89cdb8afbce3a5e88af00a1ce46ee`
- `scripts/smoke_v4_real_event_loop.js` `cec2f0e17ebc676897355ee55d55999207b7725d7eaa9be553cafda2eb63c485`

### 未完成

- Codex 聚焦复审三项 P1；**仍不声明** `EVENT_INTELLIGENCE_ASSIST_V1`。
- 回滚：`git reset --hard 0c6cb4a`
- 正式 `:8013` 需重启到本 tip 后再做 Human 真实刷新核对。

### 真实事件闭环整改摘要（相对 `df48cde`）

Human 将 Batch D 从 done 退回整改。本轮只关闭五步最小闭环，**未声明** `EVENT_INTELLIGENCE_ASSIST_V1`。

1. **未发生只事前**：收尾卡页对未来事件显示拦截态并链到研究记录；`generateFromBundle(phase=pre)` 跳过事后草稿。
2. **自动最小证据**：`lib/event_loop_ensure.js`；简报 enrich 前与 generate API 自动 `ensure`。支持 `EARNINGS`；`economic_data`→`GDP`。
3. **不足则 ABSTAIN**：无包不再 404；落盘有理由的 `ABSTAIN` 证据/草稿。
4. **发生后切事后**：`phase=post` 生成事后草稿；简报生命周期进 `pending_review`→收尾卡深链。
5. **AAPL/AMZN/GDP 走查**：`scripts/smoke_v4_real_event_loop.js` **36/36 PASS**。

### Git

- 前 HEAD：`df48cde` / `df48cde33481a5fe41af478f26d01701957d920d`
- 后 HEAD：`0c6cb4a` / `0c6cb4a27252acbabf959e06db22348de35b999e`
- 文件：`lib/event_loop_ensure.js`、`lib/event_evidence_bundle.js`、`lib/macro_surprise.js`、`lib/event_draft_store.js`、`local_server.js`、`event_research_result_v3.html`、`scripts/smoke_v4_real_event_loop.js`
- 未纳入：docs dirty、`data_backup_*`

### 验证

| 命令 | 结果 |
|---|---|
| `node scripts/smoke_v4_real_event_loop.js` | **36/36 PASS** |
| `node scripts/smoke_v4_batch_d_walkthrough.js` | **66/66 PASS** |
| `node scripts/smoke_closing_card_draft_fill.js` | **19/19 PASS** |

工件 SHA-256：

- `lib/event_loop_ensure.js` `dd481a1053c259a93bcb03f0f51d35ff3392c02f9564a82b70e776de13fb6cba`
- `scripts/smoke_v4_real_event_loop.js` `56d30b38d70e85c4446851a1e39f5a1ebf8fb0f8af95062be5c8b083e20eeb7c`
- `local_server.js` `c5ff54c6371ab64bbd80b1da559bc5f932bd9f85f2e23112f1c4b0e6822a678a`

### 未完成

- Codex 复审五步是否成立；通过后才交 Human `:8013`。
- **仍不声明** `EVENT_INTELLIGENCE_ASSIST_V1`。
- 回滚：`git reset --hard df48cde`

### 动作过滤残留关闭摘要（相对 `3c4a67d`）

1. **Snooze 绑定证据**
   - `POST .../briefing/actions` snooze 写入 `snooze_evidence`（`source_version` / `bundle_sha256` / `evidence_status`）。
   - `applyActionFilters` 不再无条件删除未过期 snooze；同一 binding 可藏，hash/version/status 变化或 `FAIL/BLOCKED/UNKNOWN/MISSING_STATUS/MISSING` → 重现并打 `NEW_EVIDENCE`。

2. **完成后证据消失**
   - `isCompletionStale` / `isEvidenceActionStale`：当前 `MISSING` 一律 stale（不得因双方 hash 为空而跳过）。
   - `canExitIntelTask`：`MISSING` 默认 `ok=false`；仅 `hasExplicitMissingDisposition` 可退出。

3. **Legacy 字符串完成**
   - 无 fingerprint 的旧字符串完成，在当前存在 hash/version 时至少重开一次（`NEW_EVIDENCE`）；重新完成写入新 binding。

4. **四个聚焦反例**（均在 `smoke_v4_batch_d_walkthrough.js`）
   - snooze 后新 FAIL
   - 完成后证据删除（MISSING）
   - MISSING 不可默认完成
   - legacy string + 新版本重开

### Git

- 前 HEAD：`3c4a67d` / `3c4a67db6d3fa3038daf7e3ee7cb7dc2432e177f`
- 后 HEAD：`df48cde` / `df48cde33481a5fe41af478f26d01701957d920d`
- 本轮提交文件：`lib/briefing_intelligence_v4.js`、`local_server.js`、`scripts/smoke_v4_batch_d_walkthrough.js`
- 未纳入：`daily_briefing.html`（本轮无改）、docs dirty、`data_backup_*`、R2 归档 untracked

### 验证

| 命令 | 结果 |
|---|---|
| `node scripts/smoke_v4_batch_d_walkthrough.js` | **66/66 PASS**（含四个聚焦反例） |
| `node scripts/smoke_closing_card_draft_fill.js` | **19/19 PASS** |

工件 SHA-256：

- `lib/briefing_intelligence_v4.js` `2d392ead1d0dca08c514b5712f27d88f50e32ab0d0e4ce7a5db16c4014d8ed49`
- `local_server.js` `41a106c48bed46aadb6adf7a88666a374b4bf925a9634f18a3c76f76c3d347d4`
- `scripts/smoke_v4_batch_d_walkthrough.js` `0af1e116028950f43e3adcae763f9585b09b1c170e787427473614f91e413149`

### 未完成

- 请 Codex **最后一次聚焦复审**核对上述三场景与四反例。
- 通过后交 Human `:8013` 真实使用；**仍不声明** `EVENT_INTELLIGENCE_ASSIST_V1`。
- 回滚点：`git reset --hard 3c4a67d`

### P1 关闭摘要（相对 `dde0e28`）

1. **缺指标 / 异常 fail-closed**
   - `deterministic_metrics.status` 缺失 → `MISSING_STATUS`，绝不默认 `READY`。
   - `BLOCKED` / `UNKNOWN` / `MISSING_STATUS` / `FAIL` 不可“今日完成”。
   - `ABSTAIN` 仅在有权威处置（v3 COMPLETE / 人工稿等）时可退出。

2. **完成绑定证据指纹**
   - `completed_categories[cat]` 现为 `{completed_at, source_version, bundle_sha256, evidence_status}`。
   - 过滤前先 enrich；指纹变化或出现 FAIL/BLOCKED 等 → 任务重进并打 `NEW_EVIDENCE`。

3. **深链按阶段隔离**
   - `pending_review` 只走事后/收尾卡；`upcoming_7d`/`missing_prep` 只走事前/研究记录。
   - 错阶段 READY 草稿不再劫持主动作。

4. **Top 3 与分类同步**
   - `complete`/`snooze` 成功后 `loadBriefing()` 全量重绘。

### Git

- 前 HEAD：`dde0e28`
- 后 HEAD：`3c4a67d` / `3c4a67db6d3fa3038daf7e3ee7cb7dc2432e177f`
- 文件：`lib/briefing_intelligence_v4.js`、`local_server.js`、`daily_briefing.html`、`scripts/smoke_v4_batch_d_walkthrough.js`

### 验证

| 命令 | 结果 |
|---|---|
| `node scripts/smoke_v4_batch_d_walkthrough.js` | **56/56 PASS**（含 P1 反例） |
| `node scripts/smoke_closing_card_draft_fill.js` | **19/19 PASS** |

工件 SHA-256：

- `lib/briefing_intelligence_v4.js` `542B4C64A5A50881DAA77F81FF85B92F7C94844A231A032409C06811513711A4`
- `scripts/smoke_v4_batch_d_walkthrough.js` `DE2026FE43460615487C9E57B0CD55062CE6AB306B117DDC1002EDD118816BC2`

### 未完成

- Human `:8013` 真实使用仍待 Codex 聚焦复审通过后。
- 未声明 `EVENT_INTELLIGENCE_ASSIST_V1`。

### 交付摘要

1. **Top 3 引擎** `lib/briefing_intelligence_v4.js`：按证据刷新/缺失、`FAIL/ABSTAIN/BLOCKED`、草稿 `READY_FOR_REVIEW`、±48h 窗口与既有分类做确定性加权；输出 `priority_reasons` + `priority_codes`。
2. **深链**：事后待确认 → `event_research_result_v3.html`；事前待确认 → `event_research_record.html`；并附 `draft_url` 直达 intelligence-draft API。
3. **完成退出**：`canExitIntelTask` 绑定权威状态（v3 COMPLETE / 事前权威 / 证据 FAIL 拒退）；禁止仅靠按钮伪完成。
4. **UI**：`daily_briefing.html` 展示 Top3 理由、codes、草稿链接；Obsidian 导出含 Top3。
5. **走查**：隔离脚本 `scripts/smoke_v4_batch_d_walkthrough.js` — 历史 NFP 事后、未来就业事前/事后弃权、CPI 跨类型。

### Git

- 前 HEAD：`d267f8d`
- 后 HEAD：`dde0e28` / `dde0e2884290a8422413df390d374138ae635a05`
- 本环提交文件：`lib/briefing_intelligence_v4.js`、`local_server.js`、`daily_briefing.html`、`scripts/smoke_v4_batch_d_walkthrough.js`
- 未纳入：既有 docs dirty、`data_backup_*`、R2 归档 untracked

### 验证

| 命令 | 结果 |
|---|---|
| `node scripts/smoke_v4_batch_d_walkthrough.js` | **41/41 PASS**（隔离 `FAS_PRODUCT_DATA_ROOT` + 随机端口） |
| `node scripts/smoke_closing_card_draft_fill.js` | **19/19 PASS**（回归） |

工件：

- `scripts/smoke_v4_batch_d_walkthrough.js` SHA-256 `1ABEFEADAD133D81DB40AE5DDBD36F38A8136AD28E913AB1274D84F47A99C5E1`
- `lib/briefing_intelligence_v4.js` SHA-256 `126D0D8C7A8AA4DE0FCA70EE1191F8AB7FC67C804092286B14C9484EFF5373C1`

### 未完成 / 非阻断

- 正式 `:8013` Human 真实使用走查仍待 Codex R1 后执行。
- 日历候选仍可能进入 Top3（既有 V3.4 行为）；V4 已叠加证据/草稿权重，未删除候选通道。
- 未声明 `EVENT_INTELLIGENCE_ASSIST_V1`。

### 六子机制（本环自报，供 R1 复核，非最终验收）

| 子机制 | 状态 |
|---|---|
| ACQUISITION | 沿用既有（本环未新开采集） |
| IDENTITY_BINDING | 沿用 |
| DETERMINISTIC_ANALYSIS | 沿用 + Top3 可复算 |
| INFERENCE_TRACEABILITY | Top3 codes/reasons 可追踪 |
| DRAFT_PERSISTENCE | 深链到既有 draft store |
| HUMAN_OVERRIDE_AUDIT | complete 门控 + 收尾卡只填空既有规则 |


待填写。

## 5. Codex 集中 R1 指令

### Codex 聚焦复审（三项真实使用 P1）

目标 tip：`30ce8132d9a37085c7da95cb7d2de235a83e9c21`  
对照：`0c6cb4a`

只核对：

1. FOMC/`calendar` 等未知类型生成 generic ABSTAIN 证据（保留原始 event_type，不伪造数值）。
2. 简报 GET：相同证据指纹复用草稿；历史 `evaluated_at` 零写入。
3. EARNINGS 草稿无 EMPSIT/NFP 文案，且 `event_type` 不在 data_gaps。

裁决：通过 → `done/human`（仍不声明验收名）；否则 `CHANGES_REQUIRED`。


### Codex 真实使用复检结论：CHANGES_REQUIRED

目标 tip：`0c6cb4a27252acbabf959e06db22348de35b999e`  
对照：`df48cde33481a5fe41af478f26d01701957d920d`

#### 已确认通过

- 未来 AAPL、AMZN、GDP 的收尾卡仍由 temporal gate 拦截，页面改为明确“事件尚未发生”并返回事前研究记录。
- 三条事件可自动得到最小 evidence bundle 和 `pre_event_prep` ABSTAIN 草稿，不再返回 `evidence_bundle_required`。
- 隔离测试：
  - `smoke_v4_real_event_loop.js`：`37/37 PASS`
  - `smoke_v4_batch_d_walkthrough.js`：`66/66 PASS`
  - `smoke_closing_card_draft_fill.js`：`19/19 PASS`
- 8013 已安全重启到本 tip；AAPL、AMZN、GDP 的 evidence/pre-draft GET 均为 200。

#### P1-1：当前真实 Top 3 仍有断链

重启后的当前 Top 3 是 Meta 财报、微软财报、FOMC 利率决议。`cal_d2h5h`（FOMC）仍返回：

- `event_loop_ensure`: `event_type must be NFP, CPI, GDP, or EARNINGS`
- evidence bundle：404
- post draft：404

因此本轮只修 AAPL/AMZN/GDP fixture-like 类型，尚未达到“真实简报事件都能进入最小证据 → ABSTAIN 草稿”的产品目标。

最小关闭条件：对任何已注册但尚无专用计算器的事件类型，允许生成 **generic metadata evidence + 明确 ABSTAIN**，保留原始 event_type，绝不伪造数值或套用宏观 surprise 公式；至少覆盖当前 FOMC 反例。

#### P1-2：GET 简报产生非幂等写入与版本膨胀

`GET /api/research/v3/briefing` 无条件调用 `ensureBriefingEventLoops()`；每次刷新都以新的 `evaluated_at` 调用 `generateFromBundle()`。实机输出显示相同 evidence 下：

- `unchanged=false`
- `idempotent=false`
- `archived_prior=true`

即页面每刷新一次都会生成并归档一版新草稿。带历史 `evaluated_at` 的回放同样会写当前 data root，违反历史回放只读边界。

最小关闭条件：

1. 相同 bundle 指纹 + 相同 phase 已有有效草稿时直接复用，重复 GET 的当前文件 hash 与版本文件数必须不变。
2. 非当天/历史 `evaluated_at` 的 briefing GET 必须零写入。
3. 增加“两次相同 GET 无新增版本”和“历史 GET 前后 data root SHA/文件数不变”的负向测试。

#### P1-3：财报草稿出现错误的 NFP 专用语义

Meta/MSFT 的 EARNINGS 事后 ABSTAIN 草稿实际写出：

`发布前冻结共识快照；确认 EMPSIT 身份；补齐缺失市场窗口 bars`

同时 `data_gaps` 把 `event_type` 列为缺失，尽管 bundle 已明确为 `EARNINGS`。这是事实/语义错误，不能交 Human 作为“有根据的推理草稿”。

最小关闭条件：

- 按 event type 生成降级文案；EARNINGS 不得出现 EMPSIT/NFP 身份提示。
- 已识别的 `event_type` 不得再次列入缺失项。
- 增加 EARNINGS 反例断言；generic/FOMC 只陈述真实缺口与下一步来源，不套用其他类型模板。

#### 判定

- 状态退回 `pending_exec / cursor`。
- 只关闭上述三项真实使用 P1；不扩模型、研究门禁或 UI。
- `EVENT_INTELLIGENCE_ASSIST_V1` 继续保持未通过，暂不进入下一阶段。
- 8013 当前运行 tip `0c6cb4a`，但在修复前不作为最终 Human 验收版本。


### Codex 聚焦复审（真实事件闭环）

目标 tip：`0c6cb4a27252acbabf959e06db22348de35b999e`  
对照：`df48cde`

只核对：

1. 未发生事件仅事前入口；收尾卡 UI/生成被拦截或跳过。
2. 真实 registry 事件自动最小 evidence（含 EARNINGS、economic_data→GDP）。
3. 证据不足 → `ABSTAIN` 草稿，generate 不再因缺包 404。
4. 发生后 phase=post + 简报深链收尾卡。
5. `smoke_v4_real_event_loop.js` 覆盖 AAPL/AMZN/GDP。

裁决：通过 → `done/human`（仍不声明验收名）；否则 `CHANGES_REQUIRED`。


### 最终聚焦复审结论：PASS

目标 tip：`df48cde33481a5fe41af478f26d01701957d920d`

复审范围仅限上一轮动作过滤残留，未扩展 Batch D。

#### 已确认关闭

1. **snooze 证据绑定与重开**
   - 新 snooze 持久化 `source_version`、`bundle_sha256`、`evidence_status`。
   - 新指纹、版本、状态变化，以及 `FAIL/BLOCKED/UNKNOWN/MISSING_STATUS/MISSING` 均重新进入简报并标记 `NEW_EVIDENCE`。
2. **完成后证据消失**
   - 已绑定完成记录遇到 `MISSING` 会失效并重开。
   - `MISSING` 不再凭事前报告或收尾卡状态默认完成；需要显式处置。
3. **legacy 字符串完成记录**
   - 遇到当前可识别的新版本或新指纹时至少重开一次，重新完成后写入结构化绑定。

#### 独立验证

- Batch D 走查：`66/66 PASS`
- 收尾卡回归：`19/19 PASS`
- 语法检查：3 个本轮文件全部通过
- 独立边界矩阵：
  - snooze 后 hash 变化：重开
  - snooze 后 `READY → ABSTAIN`：重开
  - snooze 绑定未变化：继续隐藏
  - 完成后证据消失：重开
  - legacy 完成记录遇到新版本：重开
  - `MISSING` + 已有事前报告：仍不可默认完成

#### 判定边界

- Codex 工程聚焦复审通过，状态转为 `done / human`。
- 下一步交 Human 在 `http://127.0.0.1:8013/daily_briefing.html` 做真实使用。
- 本结论**不声明** `EVENT_INTELLIGENCE_ASSIST_V1`；该验收名仍须 Human 真实使用走查后决定。
- 未声明 `RESEARCH_PASS`、`DATA_QUALITY_PASS` 或 `RELEASE_PASS`。


### Codex 最后一次聚焦复审指令

目标 tip：`df48cde33481a5fe41af478f26d01701957d920d`  
对照：`3c4a67d`

只核对 Cursor 对本轮三个场景与四个反例的关闭是否成立：

1. snooze 写入 evidence binding；新 FAIL / 状态变化 / MISSING 会重开并可见 `NEW_EVIDENCE`；同一 binding 仍可隐藏。
2. 绑定完成后证据消失（`MISSING`）会重开；`MISSING` 不可默认 `canExitIntelTask`。
3. legacy 字符串完成 + 当前 hash/version → 至少重开一次。
4. 回归：缺指标不默认 READY、阶段深链、Top3 同步、完成后新 FAIL 重开仍成立。

裁决：

- 仍有产品阻断/隐藏失败 → `CHANGES_REQUIRED`。
- 通过 → `done / human`，交 Human `:8013` 真实使用；**不**提前声明 `EVENT_INTELLIGENCE_ASSIST_V1`。

### 上一轮聚焦结论（保留）

Codex 曾对 `3c4a67d` 裁决 `CHANGES_REQUIRED`：P1-2/P1-3 PASS；P1-1 主路径 PARTIAL，动作过滤残留 fail-open（snooze 无绑定、完成后 MISSING、legacy 字符串）。本轮 Cursor 已按最小关闭条件修复。

### Codex 最后一次聚焦复审指令

目标 tip：`df48cde33481a5fe41af478f26d01701957d920d`  
对照：`3c4a67d`

只核对 Cursor 对本轮三个场景与四个反例的关闭是否成立：

1. snooze 写入 evidence binding；新 FAIL / 状态变化 / MISSING 会重开并可见 `NEW_EVIDENCE`；同一 binding 仍可隐藏。
2. 绑定完成后证据消失（`MISSING`）会重开；`MISSING` 不可默认 `canExitIntelTask`。
3. legacy 字符串完成 + 当前 hash/version → 至少重开一次。
4. 回归：缺指标不默认 READY、阶段深链、Top3 同步、完成后新 FAIL 重开仍成立。

裁决：

- 仍有产品阻断/隐藏失败 → `CHANGES_REQUIRED`。
- 通过 → `done / human`，交 Human `:8013` 真实使用；**不**提前声明 `EVENT_INTELLIGENCE_ASSIST_V1`。

### 上一轮聚焦结论（保留）

Codex 曾对 `3c4a67d` 裁决 `CHANGES_REQUIRED`：P1-2/P1-3 PASS；P1-1 主路径 PARTIAL，动作过滤残留 fail-open（snooze 无绑定、完成后 MISSING、legacy 字符串）。本轮 Cursor 已按最小关闭条件修复。

### 聚焦复审结论：CHANGES_REQUIRED

目标 tip：`3c4a67db6d3fa3038daf7e3ee7cb7dc2432e177f`  
对照：`dde0e28`

本轮只复审上次三组 P1，没有修改业务代码、正式产品数据或 `:8013`。

#### 已关闭

1. **缺/未知 metrics 不再默认 READY：PASS**
   - `MISSING_STATUS / UNKNOWN / BLOCKED / FAIL` 已 fail-closed。
   - 真实代码不再使用 `metrics.status || "READY"`。
2. **事前/事后深链隔离：PASS**
   - `pending_review` 只走事后/收尾卡；
   - `missing_prep / upcoming_7d` 只走事前/研究记录。
3. **Top 3 页面同步：PASS**
   - complete / snooze 成功后重新加载整份简报，分类卡和 Top 3 同步重绘。
4. **完成记录绑定证据指纹：PARTIAL PASS**
   - 新格式完成记录已保存 `source_version + bundle_sha256 + evidence_status`；
   - 新 hash / 新版本 / 新 FAIL 可以重新进入并标记 `NEW_EVIDENCE`。

#### 独立验证

- `node scripts/smoke_v4_batch_d_walkthrough.js`：`56/56 PASS`。
- `node scripts/smoke_closing_card_draft_fill.js`：`19/19 PASS`。
- 精确 diff 仍限 4 个 Batch D 文件；两个 `data_backup_*` 未纳入。
- 未声明 `EVENT_INTELLIGENCE_ASSIST_V1`、`RESEARCH_PASS` 或 `RELEASE_PASS`。

#### 剩余 P1：动作过滤仍能隐藏新的或缺失的权威证据

三个同范围反例：

1. **稍后处理未绑定证据。**  
   `applyActionFilters()` 遇到未过期 snooze 会先无条件删除任务并 `continue`。隔离反例中当前 evidence 已为 `FAIL / v2 / h2`，任务仍被删至 `remaining=0`。
2. **已绑定证据随后消失不会重开。**  
   完成记录绑定 `v1/h1/READY` 后，当前 evidence 变成 `MISSING` 且无 hash/version；`isCompletionStale()` 返回 `false`，同时 `canExitIntelTask()` 对 `MISSING` 仍返回 `ok=true`。这是缺失证据被隐藏。
3. **旧 V3.4 字符串完成记录无法识别新 READY 版本。**  
   `normalizeCompletionEntry("...")` 没有 fingerprint；当前出现 `new-v2/new-hash/READY` 时 `isCompletionStale()` 仍为 `false`。现正式目录统计为 0 条旧记录，因此不是当前数据事故，但导出恢复或历史数据迁入后会复发。

这仍属于上一轮 P1-1 的“完成/稍后状态必须绑定证据，新版本或更严重状态自动重进”，不是新增产品范围。

最小关闭条件：

- snooze 写入当时 evidence binding；同一 binding 可继续隐藏，hash/version/status 变化或 `FAIL/BLOCKED/UNKNOWN/MISSING_STATUS/MISSING` 时重新出现并标记 `NEW_EVIDENCE`。
- 先前绑定过 evidence、当前 evidence 消失时必须视为 stale；不得因两边比较字段为空而跳过。
- `MISSING` 不得静默完成；若业务允许人工接受无证据，必须有显式 disposition，而不是默认 `ok=true`。
- 旧字符串完成记录在当前存在 evidence hash/version 时至少重新出现一次，重新完成后写入新 binding。
- 补四个聚焦反例：snooze 后新 FAIL、完成后证据删除、MISSING 不可默认完成、legacy string + 新版本重开。

#### 聚焦判定

| 原 P1 | 结论 |
|---|---|
| P1-1 证据 fail-closed / 新证据重开 | `CHANGES_REQUIRED`（主路径已修，动作过滤残留 fail-open） |
| P1-2 阶段深链 | `PASS` |
| P1-3 Top 3 同步退出 | `PASS` |

下一轮只关闭上述动作绑定残留及四个反例；不扩展模型、事件类型、排序规则或 UI。通过后交 Human 在 `:8013` 真实使用。

本环改为 **聚焦复审**，只核对 Cursor 对三组 P1 的关闭是否成立：

1. 缺指标不再默认 READY；BLOCKED/未知不可完成；完成后新 FAIL/新指纹会重进简报并可见 `NEW_EVIDENCE`。
2. 深链按 `pending_review` vs `upcoming_7d/missing_prep` 阶段隔离（含交叉负向用例）。
3. complete/snooze 后 Top 3 与分类卡同步退出（页面重载简报）。

裁决：

- 仍有产品阻断/隐藏失败 → `CHANGES_REQUIRED`。
- 通过 → `done / human`，交 Human `:8013` 真实使用；**不**提前声明 `EVENT_INTELLIGENCE_ASSIST_V1`。

### 结论：CHANGES_REQUIRED

目标 tip：`dde0e2884290a8422413df390d374138ae635a05`  
开环基线：`d267f8d`

本次只做 Batch D 一次集中产品 R1，没有修改业务代码、正式产品数据或 `:8013`。

#### 已确认通过

- 精确提交范围仅 4 个文件：`lib/briefing_intelligence_v4.js`、`local_server.js`、`daily_briefing.html`、`scripts/smoke_v4_batch_d_walkthrough.js`。
- 声明 SHA-256 与工作树一致。
- 隔离走查：`41/41 PASS`。
- 收尾卡相邻回归：`19/19 PASS`。
- 三事件机制覆盖成立：历史 NFP 事后、未来就业事前/事后弃权、CPI 跨类型。
- 隔离服务使用临时 `FAS_PRODUCT_DATA_ROOT` 和随机端口；两个 `data_backup_*` 未纳入提交。
- 未声明 `EVENT_INTELLIGENCE_ASSIST_V1`、`RESEARCH_PASS` 或 `RELEASE_PASS`。

#### P1-1：新事实与异常状态存在 fail-open / 隐藏失败

独立反例：

1. 真实 evidence store 接受 `deterministic_metrics={}`，读取成功；简报层用 `metrics.status || "READY"` 把缺失正式判定错误标成 `READY`。
2. `canExitIntelTask()` 只拒绝 `FAIL`；`BLOCKED` 证据配合 `v3Complete=true` 仍返回 `ok=true`。
3. 用户对 `upcoming_7d` 执行“今日完成”后，同日保存新的、有效封签且状态为 `FAIL` 的权威证据；重新请求简报时该事件仍被 `completed_categories` 预先过滤。实测：权威状态为 `FAIL`，页面任务却完全消失。
4. 仅改变 evidence 的 `evaluated_at/source_version`（旧证据 vs 刚更新证据），当前优先分数和 codes 完全相同；实现无法证明 Top 3 基于“新事实”。

这属于事实错误与隐藏失败，阻断 Human 真实使用。

最小关闭条件：

- 缺失、非法或未知 `deterministic_metrics.status` 必须 fail-closed，绝不能默认 `READY`。
- `BLOCKED`、完整性失败和未知状态不得被“今日完成”隐藏；`ABSTAIN` 只能在已有明确权威处置记录时退出。
- 完成/稍后状态必须绑定当时的 evidence `source_version` 或 `bundle_sha256`；出现新版本、新 hash 或更严重状态时自动重新进入简报。
- 新旧证据必须产生可复算、可见的差异信号（例如 `NEW_EVIDENCE`），并补“完成后新 FAIL 证据重新出现”的隔离反例。

#### P1-2：事前/事后深链没有按事件阶段隔离

`pickDeepLink()` 先看任意 READY 草稿，再看事件分类：

- `pending_review` 只有旧事前草稿时，会跳到事前研究记录，而不是事后收尾卡；
- `upcoming_7d` 同时存在旧事后草稿和当前事前草稿时，会跳到事后收尾卡。

这会把用户带到错误阶段，属于事前/事后路径错配。

最小关闭条件：

- `pending_review` 只允许事后草稿/收尾卡作为主动作；
- `missing_prep`、`upcoming_7d` 只允许事前草稿/研究记录作为主动作；
- 不匹配当前阶段的旧草稿可以显示为历史信息，但不得改变主动作；
- 增加上述两个交叉阶段负向用例。

#### P1-3：完成后 Top 3 未自动退出

真实无头浏览器反例：

- 服务返回完成成功后，分类卡已删除；
- 同一事件的 `[data-testid="top3-card-*"]` 仍留在页面；
- `BRIEFING_DATA/top_items` 未刷新，页面同时显示“已完成”和“仍是 Top 3”。

这违反“完成后自动退出对应任务”和“任务状态与真实状态一致”。

最小关闭条件：

- `complete` / `snooze` 成功后重新获取简报并重绘 Top 3，或原子地从分类与 Top 3 同时删除并重新排序；
- 增加浏览器断言，证明分类卡与 Top 3 同步退出，重开后状态一致。

#### 技术债（不单独阻断）

- `scripts/smoke_v4_batch_d_walkthrough.js` 的 `backups_untouched_contract` 当前是常量 `true`，没有做前后 hash；现有临时数据根证明本次未写正式数据，但该断言应后续改成真实检查。
- 旧 V3.4 走查默认访问 token-locked `:8000`，本机返回 401 后脚本又因空响应崩溃；这是旧验收脚本可用性债，不归入 Batch D 业务修复。
- 页面直接展示内部 score/codes，可在 Human 走查后决定是否简化。

#### 五项集中 R1 判定

| 审查项 | 结论 |
|---|---|
| Top 3 可复算、理由可见 | `CHANGES_REQUIRED`：基本排序可复算，但“新事实”不可识别，缺指标会误报 READY |
| 深链与权威退出 | `CHANGES_REQUIRED`：跨阶段深链；新 FAIL 证据可被旧完成状态隐藏 |
| 三事件走查 | `PASS`：机制覆盖成立，不代表真实质量 |
| 失败、弃权、来源、人工覆盖 | `CHANGES_REQUIRED`：存在隐藏失败和 BLOCKED 可退出 |
| 重开连续性与数据隔离 | `PARTIAL`：snooze 持久化、隔离根通过；页面即时 Top 3 状态不一致 |

#### 下一轮边界

只关闭上述三组 P1 及对应反例，不增加事件类型、不接模型、不改研究门禁、不扩展 UI。修复后再交 Codex 聚焦复审；通过后才交 Human 在 `:8013` 真实使用。

只集中复审以下五点：

1. Top 3 是否由可复算证据与状态驱动，且理由真实可见。
2. 深链和任务退出是否绑定权威状态，而非前端假完成。
3. 三事件走查是否覆盖历史事后、未来事前/事后弃权、跨类型兼容。
4. 失败、弃权、来源和人工覆盖是否保持 fail-loud。
5. 重开连续性及真实数据不受测试污染。

裁决：

- 产品阻断、数据错误、错误完成或隐瞒失败：`CHANGES_REQUIRED`。
- 仅命名、更多测试、性能优化或非阻断体验问题：登记技术债，不开启新一轮扩展。
- 通过：更新为 `done / human`，交 Human 做最终真实使用走查；Codex 不提前声明产品总验收名。
- 仍存在无法在本环最小修复的问题：`BLOCKED / human`，停止 V4 扩展。

## 6. 历史

- 2026-07-30：Human 指示 Codex 暂不复查；交接板改 `done/human`，继续 `:8013` 真实使用推进。
- 2026-07-30：Cursor 关闭三项真实使用 P1 tip `30ce813`（50/50 + 66/66 + 19/19）→ pending_review。
- 2026-07-30：Cursor 关闭真实事件闭环 tip `0c6cb4a`（36/36 + 66/66 + 19/19）→ pending_review；验收名未声明。
- 2026-07-30：Human 判定真实事件闭环断点，Batch D 从 done 退回整改；验收名保持未通过。
- 2026-07-30：Cursor 关闭动作过滤残留 tip `df48cde` → pending_review / codex（最后一次聚焦复审）；走查 66/66 + 19/19。
- 2026-07-30T09:46:35.077Z：Human 批准开启 D。
- 2026-07-30T09:57:45.924Z：Cursor 交付 tip `dde0e28` → pending_review。
- 2026-07-30：Codex R1 `CHANGES_REQUIRED`（三组 P1）。
- 2026-07-30T11:19:53.211Z：Cursor 关闭三组 P1 tip `3c4a67d` → pending_review / codex（聚焦复审）。

- 2026-07-30T09:46:35.077Z：Human 批准“开启 D”；归档 R2，开启 `PRD-EVENT-INTELLIGENCE-13-D`。
- 2026-07-30T09:57:45.924Z：Cursor 完成 Batch D 最小交付 tip `dde0e28`，移交 `pending_review / codex`。

- 2026-07-30T09:46:35.077Z：Human 批准“开启 D”；归档 R2，开启 `PRD-EVENT-INTELLIGENCE-13-D`。
- 2026-07-30：Codex 集中 R1 复跑 `41/41 + 19/19 PASS`；独立反例复现缺指标误报 READY、完成后新 FAIL 证据被隐藏、跨阶段深链、BLOCKED 可退出及 Top 3 不同步退出，裁决 `CHANGES_REQUIRED`。
- 2026-07-30：Codex 聚焦复审 `3c4a67d`：`56/56 + 19/19 PASS`；深链与 Top 3 同步关闭，但 snooze、新证据缺失和 legacy completion 仍可隐藏证据，裁决 `CHANGES_REQUIRED`。
