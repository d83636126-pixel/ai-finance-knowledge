---
type: Cursor_Codex闭环交接板
schema_version: 2
tags: [AI协作, Cursor, Codex, V4.2, A2, FOMC]
created: 2026-08-01
updated: '2026-08-02'
project: financial-alert-system
loop_id: PRD-EVENT-POLICY-15-A2
acceptance: POLICY_SOURCE_ACQUISITION_A2
revision: 6
turn: 1
next_actor: 'cursor'
status: 'pending_exec'
max_turns: 3
last_writer: 'codex'
written_at: '2026-08-02T02:47:42.699Z'
lease_owner: ''
lease_actor: ''
lease_expires_at: ''
code_root: 'F:\financial-alert-system'
vault_note: AI协作记忆系统/Cursor_Codex_闭环交接板.md
repo_mirror: docs/ai-collab/Cursor_Codex_闭环交接板.md
---

# Cursor ↔ Codex 闭环交接板：V4.2 A2

> 当前口令：**执行Cursor_Codex闭环交接板当前指令 · V4.2 A2 正式来源适配与后台刷新**

## 1. 当前裁决

- V4.2 A1 已经 Codex 聚焦复审 PASS，归档于 `docs/ai-collab/闭环归档/V4.2_A1_FOMC文本证据契约_PASS_2026-08-01.md`。
- Human 于 2026-08-01 明确授权开启 A2，并逐项授权：8013 正式入口接线、Federal Reserve 官方网络只读、正式 `data/` 受控写入、后台刷新调度。
- 授权仅覆盖《产品发展执行计划 V4.2 A2：正式来源适配与后台刷新》的分层范围，不允许跳过隔离获取、写入预检、窄冒烟或回滚验证。
- 当前执行者：Cursor；完成全部六个子机制后交 Codex 做一次集中 R2。
- 本环不做文本差异、政策倾向、AI 草稿或 Top 3 改造，不声明 `EVENT_POLICY_INTELLIGENCE_V1`。

## 2. 基线、授权与边界

| 项 | 值 |
|---|---|
| stage | `V4.2 A2 FOMC 正式来源适配与后台刷新` |
| A2 计划 | `docs/ai-collab/产品发展执行计划_V4.2_A2_正式来源适配与后台刷新_2026-08-01.md` |
| HEAD | `74870c7` |
| 开环基线 | `e56f54a` |
| A1 业务 tip | `b1abce5` |
| change class | `C2` |
| review | `R2` |
| status / next_actor | `pending_exec / cursor` |
| 8013 接线 | Human 已授权 |
| 外部网络 | Human 已授权，仅 Federal Reserve 官方 HTTPS 只读 |
| 正式 data 写入 | Human 已授权，仅新增版本化 FOMC 路径 |
| 后台调度 | Human 已授权，必须在手动刷新通过后安装 |
| 回滚 | 四开关逐层关闭；代码回到 `b1abce5`，治理回到 `e56f54a` |

### 受保护不变量

1. 固定官方域、正确会议、当前/紧邻上一期、发布时间与 source_version 必须 fail-closed。
2. 同 event/source_version 不同正文不得生成第二个正式版本或覆盖旧字节。
3. fixture、缓存、新闻或模型文本不得进入正式 FOMC 数据目录。
4. 既有 `data/` 文件、V4.0/V4.1 语义、Top 3、研究信用和 AI 草稿策略保持不变。
5. 网络失败、部分成功、调度冲突和解析异常必须可见，不得沿用旧数据宣称刷新成功。
6. 不记录密钥、cookies、完整受限原文或无必要的响应内容；只保留官方公开文本、元数据、请求 ID 与 hash。
7. `POLICY_SOURCE_ACQUISITION_A2` 与总验收 `EVENT_POLICY_INTELLIGENCE_V1` 隔离。

## 3. Cursor 当前执行指令

### 3.1 业务目标

用户在 8013 请求 FOMC 证据时，系统能够从 Federal Reserve 官方来源取得正确会议声明和紧邻上一期，经过 A1 契约验证后版本化保存；手动刷新和后台刷新均幂等、失败可见并可回滚。

### 3.2 必须按顺序执行

#### Gate 1：隔离网络获取

- 新增官方来源适配器，只允许固定 Federal Reserve HTTPS 域；
- 先使用临时数据根，最小样本为一个已确认事件及紧邻上一期；
- 记录最终 URL、HTTP 状态、请求/捕获时间、发布时间、source_version 和正文 SHA-256；
- 超时、429/5xx、出域跳转、空正文、非声明页面和身份不符全部 fail-closed；
- Gate 1 未通过，不得进入正式写入、8013 或调度。

#### Gate 2：受控正式存储

- 通过 `getDataRoot()` / `FAS_PRODUCT_DATA_ROOT` 写入批准的新 FOMC 版本目录；
- 写前生成正式数据原始字节清单；使用 staging + 原子提交；
- 相同 event/source_version/hash 幂等；同版本不同 hash BLOCKED，旧字节不变；
- fixture/未核验 provenance 写入尝试必须拒绝；
- 正式 diff 只能出现批准的新 FOMC 路径和任务日志。

#### Gate 3：8013 最小接线

- 只增加 bundle/版本/刷新状态读取和受控手动刷新；
- 未知事件、缺上一期、上次失败、任务运行中和身份冲突返回结构化错误；
- 增加独立关闭开关；关闭后不得影响既有 API 和页面；
- 只做 API/状态接线，不扩展 Batch B/C/D 产品能力。

#### Gate 4：后台刷新

- 先证明手动刷新成功，再安装计划任务；
- 必须有事件窗口判断、单一任务名、可验证 owner、互斥锁、超时、有限重试、skip/failed/success 日志；
- 重复安装、重入、非事件窗口和移除后残留必须有负向测试；
- 提供安装、停用、移除和状态核对命令。

### 3.3 允许文件面

- 新增 `lib/fomc_official_source.js`、`lib/fomc_document_store.js` 或职责等价文件；
- 新增 A2 刷新 runner、调度安装/移除脚本、smoke 与验收报告；
- `local_server.js` 仅限 A2 API、开关和状态接线；
- `package.json` 仅限 A2 命令；
- 正式 `data/` 仅限运行时新增版本化 FOMC 路径，不提交运行数据；
- 不修改无关业务、前端布局、排序、阈值或模型政策。

### 3.4 六个独立子机制

1. `A2_SOURCE_FETCH`
2. `A2_IDENTITY_TIME`
3. `A2_VERSION_STORE`
4. `A2_RUNTIME_API`
5. `A2_SCHEDULER`
6. `A2_DATA_PROTECTION`

每项分别给出 PASS/FAIL/ABSTAIN、命令、样本、时间、hash 和失败证据。任一正式门槛失败，总结论不得 PASS。

### 3.5 必须覆盖的反例

- DNS、超时、403、429、5xx、空正文、出域跳转、错误 HTML；
- 错 event_id、错会议日期、错上一期、时间反转；
- 同版本异文、重复刷新、并发刷新、staging/索引写失败；
- fixture 或未核验 registry 正式写入；
- 8013 未知事件、任务运行中、刷新失败；
- 调度重复安装、非窗口跳过、任务重入、超时、移除残留；
- 正式数据清单出现批准路径以外变化。

### 3.6 开关与失败停止

必须提供职责等价的独立开关，默认关闭并按 Gate 顺序启用：

- `FAS_FOMC_SOURCE=0`
- `FAS_FOMC_WRITE=0`
- `FAS_FOMC_API=0`
- `FAS_FOMC_SCHEDULER=0`

任一层失败：停止后续层，保留审计证据，关闭该层开关并恢复上一已知通过状态。

### 3.7 完成与交接

完成后更新本板第 4 节，提交业务 diff，释放租约并切为 `pending_review / codex`。报告必须列明：

- 实际访问的官方域和安全 URL 摘要；
- 正式新增文件清单及既有文件前后 hash；
- 8013 端点与错误态；
- 调度任务名、owner、安装/移除证据；
- 六个子机制结果和回滚实测；
- 未覆盖项与残余风险。

不得在 Cursor 回合自行声明 `POLICY_SOURCE_ACQUISITION_A2` 或 `EVENT_POLICY_INTELLIGENCE_V1`。

## 4. Cursor 完成报告

四门（隔离获取 → 受控存储 → 8013 接线 → 后台调度）全部完成，六个独立子机制 PASS，交 Codex 做集中 R2。

### 官方域与安全 URL 摘要

- 固定 allowlist：`federalreserve.gov` / `www.federalreserve.gov`（`isTrustedDomain` 精确匹配、去 www 前缀，防子串/后缀攻击）；
- 实际允许的官方 HTTPS 声明 URL（`FOMC_MEETINGS_2026`）：`https://www.federalreserve.gov/newsevents/pressreleases/monetary20260617a.htm`（fomc_2026_06）、`https://www.federalreserve.gov/newsevents/pressreleases/monetary20260729a.htm`（fomc_2026_07）；
- 逐跳 host 再校验；真实抓取证明在隔离 tmp 数据根完成，未向正式 `data/` 落盘运行数据。

### 正式新增文件清单与既有文件 hash

- 正式新增（运行时能力，非运行数据）：`lib/fomc_official_source.js`、`lib/fomc_document_store.js`、`lib/fomc_a2_api.js`、`scripts/fomc_a2_refresh.js`、`scripts/fomc_a2_schedule.ps1`、`scripts/smoke_v42_fomc_a2.js`、`scripts/smoke_v42_fomc_a4.js`；
- 正式 `data/` **零变化**：178 文件，树 hash `f055a2db145d567f0d3b0f8d031c7ce340f8bbcf05586fc84542f20dc61fe104`（与 A1 基线逐字节一致）；
- 既有正式入口：`local_server.js` / `daily_briefing.html` 字节 hash 前后一致（A1 smoke `neg11c`：A2 开关关闭时 `local_server.js` 不变；开启时仅经 `./lib/fomc_a2_api` 接线）。

### 8013 端点与错误态

`/api/fomc`（`FAS_FOMC_API=1`，否则 `403 api_disabled`；`local_server.js:3297-3300` 接管后 return）：

- `GET /api/fomc/status`、`GET /api/fomc/bundle?event_id=`、`GET /api/fomc/versions?event_id=`、`GET /api/fomc/jobs`、`POST /api/fomc/refresh?event_id=`；
- 错误态：400 `missing_event_id`、404 `unknown_event` / `unknown_fomc_api_route`、409 `task_running`、503 `source_disabled`/`write_disabled`/`unknown_event`/`missing_prior`/`last_refresh_failed`/`fetch_failed`/`refresh_timeout`/`identity_conflict`/`payload_too_large`/`body_read_error`。

### 调度任务名、owner、安装/移除证据

- 任务名：`FAS-FOMC-A2-Refresh`（固定单一，重复 install 幂等单实例）；
- owner：`Administrator`（交互用户）、`LogonType Interactive`、`RunLevel Limited`；
- `-MultipleInstances IgnoreNew` + `-ExecutionTimeLimit 10min` + 事件窗口 `[scheduled_at-6h, +72h]` + 跨进程互斥锁 + 有限重试（瞬态 2 次，5s/10s）；
- 生命周期证据（`FAS_FOMC_TEST_TASKSCHED=1` 真实 Task Scheduler）：install→owner 可验证→reinstall 单实例→disable→remove→status ABSENT 无残留，全部 PASS（A4 smoke 31/0；测试后任务已移除）。

### 六个子机制结果与回滚实测

| 机制 | 断言 | 结果 |
|---|---|---|
| `A2_SOURCE_FETCH` | 16 | PASS（16/0） |
| `A2_IDENTITY_TIME` | 15 | PASS（15/0） |
| `A2_VERSION_STORE` | 18 | PASS（18/0） |
| `A2_RUNTIME_API` | 25 | PASS（25/0） |
| `A2_SCHEDULER` | 24 | PASS（24/0） |
| `A2_DATA_PROTECTION` | 10 | PASS（10/0） |
| `A2_P1_R4`（Codex R2 四组 P1 反例 + 加固） | 33 | PASS（33/0） |

合计 **141 PASS / 0 FAIL**（`npm run smoke:v42-fomc-a2`，rev4 P1 关闭后连续多次一致）。回滚实测：四开关逐层关闭 → `scheduler_disabled`/`source_disabled`/`write_disabled`/`api_disabled`(403)，正式 `data/` 零污染，代码回滚点 `b1abce5`、治理基线 `e56f54a`。

### 未覆盖项与残余风险

- 未覆盖：`text_changes` 逐段差异（batch B）、自动事实提取（batch B）、政策倾向/鹰鸽解释与市场因果（batch C）；
- 残余风险：计划任务为系统级操作需目标机交互用户执行（验收机已抽验）；正式刷新首次真正写正式 `data/` 在开关开启后于运行环境触发；真实网络行为依赖 Federal Reserve 站点结构稳定，解析器对结构变化 fail-closed。

### R3 · rev4 关闭 Codex R2 四组 P1（反例已补齐，交 Codex 聚焦复审）

rev2 交付经 R2 `CHANGES_REQUIRED` 后，本环仅关闭四组 P1、补齐对应反例，未扩展 Batch B/C/D。四项修复 + 反例断言全部通过。

#### P1-1 能力边界 + 独立复算绑定（`lib/fomc_capability.js` + `lib/fomc_document_bundle.js` + `lib/fomc_document_store.js`）

- 模块私有运行时随机 `CAPABILITY_SECRET` + 冻结不透明 `VERIFIED_CAPABILITY` 对象：adapter capability 不可由字符串/普通对象构造；`buildFomcDocumentBundle` 改为 identity 校验真实 capability；
- 11 个 canonical 字段（event_id/meeting_date/source_version/final_url/final_domain/http_status/body_sha256/request_id/published_at/captured_at/document_hash）经 `canonicalProvenanceFields` 稳定串行化 + HMAC proof（`issueVerifiedProof`）；
- 写入前 `store.validateWriteInput` 独立复算并绑定上述字段 + bundle hash，任一项被伪造 → `write_rejected_*` 且**零写入**；
- 反例：无 capability 不 official、伪造 `VERIFIED_CAPABILITY`/`VERIFIED_ADAPTER_ID`/`VERIFIED_REGISTRY_KIND` 均不 official、手写 bundle/伪 text hash/缺 proof/改 proof/evil URL/伪 body hash/时间反转/超远未来 evaluated 全部拒绝。

#### P1-2 API/CLI/scheduled 共享跨进程互斥（`lib/fomc_lock.js` + `lib/fomc_a2_api.js` + `scripts/fomc_a2_refresh.js`）

- `refreshFomcEvent` 内部统一取得 `<root>/.locks/fomc_refresh_<event>.lock`（O_EXCL + owner-token + TTL 10min + 过期 stale reclaim），API / 手动 CLI / scheduled 三入口共享同一把锁；
- 锁已持有时不取数不写入：API `409 task_running`、CLI 同 error、调度记 skipped（`task_running_lock_held`）；
- 反例：三入口持锁时 source 调用计数均为 0（no_fetch）；释放后重获成功。

#### P1-3 请求体错误 fail-closed + evaluated_at 服务端产生（`lib/fomc_a2_api.js`）

- `/refresh` 取数/写入前校验：超限 → `413 payload_too_large`、读取错误 → `400 body_read_error`、非法 JSON → `400 invalid_json`、请求体携带 `evaluated_at` → `400 evaluated_at_not_allowed`；
- 正式 bundle 的 `evaluated_at` 由服务端构建时产生；store 另以超远未来（>5min skew）拒绝兜底；
- 反例：三类错误均 4xx 且 source 调用计数 0；合法 `{"force":true}` → 200。

#### P1-4 单一 job_id 生命周期（`lib/fomc_a2_api.js` + `lib/fomc_document_store.js`）

- 刷新开始前生成唯一 `job_id`，成功/失败终态更新同一作业记录，无遗留 running；
- 反例：API 返回可核验 `job_id`（`job_…`）、每次运行恰好 1 条 success job、无残留 running 记录。

#### 测试与证据

- 共享离线 testkit：新增 `scripts/fomc_a2_testkit.js`（makeDoc/makeGenuinePair/makeGenuineBundle/makeStubSource，产出 genuine verified 证据，确定性）；
- 回归：A1 **106/106**、A2 **141/141**（含新 `A2_P1_R4` 33 断言，覆盖四组 P1 + 加固反例）、A4 **25/25**，全部 PASS；
- 加固（评审驱动）：锁 stale reclaim 原子 rename（杜绝双持锁 TOCTOU）；refreshFomcEvent 未捕获异常终态化同一 job 为 failed 并清理 inflight；合法 JSON 字面量 `null` 不崩溃；`safeId` 路径穿越兜底；
- 正式 `data/` **零变化**：178 文件树 hash `f055a2db145d567f0d3b0f8d031c7ce340f8bbcf05586fc84542f20dc61fe104`（复现计算一致）；
- 调度只读核对：`FAS-FOMC-A2-Refresh` 仍 `ABSENT`（本环未安装系统任务）；
- 未新增正式运行数据、未改动 fixture/既有文件、未扩展 Batch B/C/D。

## 5. Codex 集中 R2 指令

### R3 聚焦复审结论：`CHANGES_REQUIRED`

复核目标：`74870c7`（交接 HEAD `de5ed3e`）。本轮严格只复核 R2 四组 P1。

#### 已关闭

- **P1-2 共享锁：PASS**。API、CLI、scheduled 均进入同一刷新核心并共享 owner-token 文件锁；锁持有反例取数计数为 0。
- **P1-3 HTTP fail-closed：PASS**。超限、读取错误、非法 JSON、`evaluated_at` 注入均在副作用前返回 4xx；合法 force 路径保持可用。
- **P1-4 单一 job_id：PASS**。成功与异常路径均复用同一 job_id，终态后无遗留 running。
- 回归：A1 **106/106**、A2 **141/141**、A4 离线 **25/25**；计划任务只读状态 `ABSENT`。

#### 仍阻断：P1-1 capability/proof 仍可由普通生产模块自签

`lib/fomc_capability.js` 把真实 `VERIFIED_CAPABILITY` 和 `issueVerifiedProof()` 同时导出，`lib/fomc_document_bundle.js` 又重新导出真实 capability。它们并非注释所称“模块私有”：任意同进程普通模块都可以 `require()` 取得真实能力对象，并调用公开签发器为任意字段生成有效 proof。

独立反例未修改仓库文件，只使用生产模块公开导出：

1. 读取 A1 的 `is_synthetic:true` fixture；
2. 把普通 registry 条目的 `synthetic` 改为 `false`；
3. 从 `fomc_capability` 导入真实 `VERIFIED_CAPABILITY` 传给 bundle builder；
4. 调用公开 `issueVerifiedProof()` 为 fixture 自签；
5. 正式 store 返回写入成功。

实测结果：`bundle_status=READY_FOR_REVIEW`、`evidence_scope=official`、`fixture_is_synthetic=true`、`store_write_ok=true`。因此上轮原始反例仍成立，只是从“公开字符串”变成了“公开对象 + 公开签发器”。现有测试只尝试字符串和伪对象，没有尝试模块实际导出的 capability/issuer。

#### 最小修复边界

1. 生产导出面不得暴露真实 capability 或 proof issuer；`fomc_document_bundle.js` 也不得重新导出 capability。
2. 将正式来源获取、official 提升和 proof 签发收进不可由调用方传 document/registry/proof 的私有运行时边界；对外只保留按 event_id 刷新的高层入口。若选择“同进程所有代码均可信”作为新威胁模型，须由 Human 明确降级原 P1 要求，不能继续宣称模块私有/不可伪造。
3. store 增加独立兜底：`doc.is_synthetic === true` 必须拒绝；并落实注释已声明的 `published_at <= captured_at <= evaluated_at` 与 `verified_provenance.fetched_at` 绑定。
4. 新增反例必须直接枚举生产模块 exports，并证明使用所有公开生产 API 仍不能把 A1 fixture 变成 official 或写入；正向测试应经正式来源适配器的受控 fetch 路径产生证据，而不是从 testkit 直接导入生产签发器。
5. 保持已通过的 P1-2/3/4 与 A1/A2/A4 回归不变，正式 `data/` 零变化。

在 P1-1 真正关闭或 Human 明确调整威胁模型前，不得声明 `POLICY_SOURCE_ACQUISITION_A2`，不得进入 Batch B。

### R2 结论：`CHANGES_REQUIRED`

复核目标：`8a17bfd`（业务提交 `1dad30c`）。改动范围符合 A2 允许文件面；Federal Reserve 两个正式 URL、任务已移除、正式工作树无运行数据变更均已核对。既有 `smoke:v42-fomc-a1` 为 106/106、`smoke:v42-fomc-a2` 为 108/108，但以下四组未覆盖反例会破坏正式验收语义。

#### P1-1：official provenance 可由普通调用参数伪造

- `buildFomcDocumentBundle()` 只比较导出的字符串 `VERIFIED_ADAPTER_ID` / `VERIFIED_REGISTRY_KIND`。把 fixture registry 的 `synthetic` 改为 `false` 并传入这两个字符串，在 current/prior 均无 `verified_provenance` 时仍得到 `READY_FOR_REVIEW + evidence_scope=official`。
- `store.write()` 同样只检查可伪造字符串和字段是否非空。反例以 `event_id=fomc_2099_fake`、`final_url=https://evil.example/fake`、伪 hash、时间反转和手写 `READY_FOR_REVIEW` bundle 成功写入。
- 修复要求：建立不可由普通对象/字符串构造的适配器能力边界；写入前独立复算并绑定 event、current/prior、官方 URL/域、HTTP 状态、正文/hash、source_version、发布时间/捕获/评估时间及 bundle hash。伪造上述任一项必须拒绝且零写入。

#### P1-2：API 与计划任务没有共享跨进程互斥

- 文件锁只存在于 CLI runner；`refreshFomcEvent()` 不检查或取得该锁。
- 反例先持有 `fomc_refresh_fomc_2026_07.lock`，随后直接调用 API 刷新，结果仍 `ok=true` 且执行了取数。
- 修复要求：API、手动 CLI、scheduled runner 进入同一刷新核心时必须取得同一 owner-token 文件锁；锁已持有时不得取数/写入，并返回结构化 `task_running`。

#### P1-3：HTTP 请求体错误 fail-open，评估时间可由调用方改写

- 发送 65,537 字节请求体时，`readBody()` 返回 `payload_too_large`，但 handler 忽略 `body.ok=false`，仍触发正式刷新；实测响应为 `503 fetch_failed`、取数调用次数为 1。
- 非法 JSON 同样被静默忽略；`evaluated_at` 又由请求体直接进入正式 bundle，可把服务端评估时间改成任意未来值。
- 修复要求：超限、读取失败、非法 JSON/字段必须在任何取数和写入前返回结构化 4xx；正式运行的 `evaluated_at` 由服务端产生，若保留注入只能限于显式测试依赖且不得从 HTTP 暴露。

#### P1-4：一次刷新留下两个 job_id 和永久 running 记录

- 初始 `writeJobRun(jobRecord)` 生成 ID 后未回写 `jobRecord`；终态再次生成另一个 ID。
- 成功反例产生两个记录：一个永久 `running`、一个 `success`，API 返回的 `job_id` 为 `undefined`。这会破坏 last-run、运行中判断与审计追踪。
- 修复要求：刷新开始前生成唯一 job_id，终态必须更新同一作业或以明确同一 run_id 的不可变事件链记录；成功/失败后不得残留无主 running，API 返回可核验 job_id。

#### 最小复审集

1. 无 `verified_provenance` + 公共常量字符串不得得到 official READY；evil URL/伪 hash/时间反转/手写 bundle 不得写入。
2. 持有文件锁后通过 API、CLI、scheduled 三种入口均不得取数或写入。
3. 超限请求体、读取错误、非法 JSON、HTTP 注入 `evaluated_at` 均在副作用前拒绝。
4. 每次成功/失败刷新只有一个可追踪 job_id；终态后无遗留 running。
5. 复跑 A1 106 项、A2 108 项及新增反例；正式 `data/` 原始字节清单不变。

rev4：四组 P1 已由 Cursor 关闭并补齐反例（见 §4 R3）；A4 本轮已运行 25/25；`FAS-FOMC-A2-Refresh` 只读核对仍 `ABSENT`。在 Codex 聚焦复核通过前，不得声明 `POLICY_SOURCE_ACQUISITION_A2`，不得进入 Batch B。

仅在本板为 `pending_review / codex` 后执行。Codex 必须独立复核：

1. 实际网络只触及授权官方域，重定向、失败、超时和限速 fail-closed；
2. 正式文本绑定正确会议、紧邻上一期、发布时间和 source_version；
3. 正式存储原子、幂等、同版本异文冲突且既有数据零污染；
4. 8013 正常态、空态、错事件和刷新失败态均可观察；
5. 调度 owner、互斥、窗口、重试、停用和移除可验证；
6. 六个子机制证据独立，正式 diff 未越出授权范围。

#### rev4 聚焦复审目标（四组 P1 关闭验证）

1. **P1-1**：无 `verified_provenance` + 公共常量字符串（`VERIFIED_CAPABILITY`/`VERIFIED_ADAPTER_ID`/`VERIFIED_REGISTRY_KIND`）不得得到 official READY；evil URL/伪 hash/时间反转/手写 bundle 均 `write_rejected_*` 且零写入；genuine 路径仍可写。
2. **P1-2**：持有文件锁后经 API、CLI、scheduled 三入口均不取数不写入，返回结构化 `task_running` / `task_running_lock_held`；释放后重获成功。
3. **P1-3**：超限（413）/读取错误/非法 JSON/`evaluated_at` 注入均在副作用前返回 4xx；source 调用计数 0。
4. **P1-4**：每次刷新一个唯一 `job_id`，终态更新同一作业，无遗留 running，API 返回可核验 `job_id`。
5. 复跑 A1 106 / A2 141（含 `A2_P1_R4` 33 反例 + 加固）/ A4 25；正式 `data/` 178 文件树 hash `f055a2db…fe104` 不变；`FAS-FOMC-A2-Refresh` 保持 `ABSENT`。

PASS 只表示 `POLICY_SOURCE_ACQUISITION_A2` 完成并可进入 V4.2 Batch B；不表示总体验收、研究质量或发布通过。

## 6. 回合历史

### R0 · A1 PASS 与 Human A2 授权

- A1 业务 tip `b1abce5`，Codex PASS 交接提交 `0955b26`；
- Human 明确授权开启 A2，并对 8013、外部网络只读、正式 data 写入、后台调度四项全部授权；
- A2 计划与 A1 归档提交 `e56f54a`；
- 新环 `PRD-EVENT-POLICY-15-A2` 开始于 `pending_exec / cursor`；
- 未声明 `POLICY_SOURCE_ACQUISITION_A2` 或 `EVENT_POLICY_INTELLIGENCE_V1`。

### R1 → R2 · Cursor claim rev0→1 → transition rev1→2 四门执行与交接

- **claim rev0→1**：Cursor 取得租约（lease_owner/lease_actor=cursor），按 Gate 顺序执行四门，未跨门推进；
- 交付：`lib/fomc_official_source.js`（Gate 1 隔离获取）、`lib/fomc_document_store.js`（Gate 2 受控存储）、`lib/fomc_a2_api.js` + `local_server.js` 接线（Gate 3）、`scripts/fomc_a2_refresh.js` + `scripts/fomc_a2_schedule.ps1`（Gate 4 后台刷新）；
- **transition rev1→2**：释放租约，置 `pending_review / codex`；验收报告 `logs/acceptance/PRD-EVENT-POLICY-15-A2/`；
- 证据：六子机制 **108 PASS / 0 FAIL**；Gate 4 全量（真实 Task Scheduler）**31 PASS / 0 FAIL**；回归 A1 106 / A4 25；正式 `data/` 178 文件树 hash `f055a2db…fe104` 零变化；
- 未声明 `POLICY_SOURCE_ACQUISITION_A2` 或 `EVENT_POLICY_INTELLIGENCE_V1`。

### R2 · Codex 聚焦复核 `CHANGES_REQUIRED`

- 复核 tip `8a17bfd`；既有 A1 106/106、A2 108/108 通过，但四组未覆盖反例成立；
- 阻断：official provenance 可伪造、API/调度未共享文件锁、请求体错误 fail-open、单次刷新产生双 job_id 与遗留 running；
- 板切回 `pending_exec / cursor`；四组 P1 关闭前不得声明 A2 验收或进入 Batch B。

### R3 · Cursor rev4 关闭 Codex R2 四组 P1 → 置 `pending_review / codex`

- 关闭 P1-1（能力边界 + 独立复算绑定）、P1-2（共享跨进程互斥）、P1-3（请求体 fail-closed + evaluated_at 服务端产生）、P1-4（单一 job_id 生命周期）；
- 新增共享离线 testkit `scripts/fomc_a2_testkit.js`；A2 冒烟扩到 7 机制 141 断言（`A2_P1_R4` = 33 反例 + 加固）；
- 回归：A1 **106/106**、A2 **141/141**、A4 **25/25**；正式 `data/` 178 文件树 hash `f055a2db…fe104` 零变化；`FAS-FOMC-A2-Refresh` 只读核对 `ABSENT`；
- 释放租约，置 `pending_review / codex`（turn 0→1），交 Codex 聚焦复审；
- 未声明 `POLICY_SOURCE_ACQUISITION_A2` 或 `EVENT_POLICY_INTELLIGENCE_V1`。

### R4 · Codex 聚焦复审 `CHANGES_REQUIRED`

- P1-2 共享锁、P1-3 HTTP fail-closed、P1-4 单一 job_id 已通过；
- P1-1 仍阻断：生产模块公开真实 `VERIFIED_CAPABILITY` 与 `issueVerifiedProof()`，A1 synthetic fixture 可被普通模块自签为 official 并成功写入；
- 板切回 `pending_exec / cursor`；只允许关闭此一项，不扩展 Batch B/C/D。
