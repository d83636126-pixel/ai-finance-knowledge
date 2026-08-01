---
type: Cursor_Codex闭环交接板
schema_version: 2
tags: [AI协作, Cursor, Codex, V4.2, A2, FOMC]
created: 2026-08-01
updated: '2026-08-01'
project: financial-alert-system
loop_id: PRD-EVENT-POLICY-15-A2
acceptance: POLICY_SOURCE_ACQUISITION_A2
revision: 0
turn: 0
next_actor: 'cursor'
status: 'pending_exec'
max_turns: 3
last_writer: 'human'
written_at: '2026-08-01T09:42:13.605Z'
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
| HEAD | `e56f54a` |
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

待 Cursor 执行后填写。

## 5. Codex 集中 R2 指令

仅在本板为 `pending_review / codex` 后执行。Codex 必须独立复核：

1. 实际网络只触及授权官方域，重定向、失败、超时和限速 fail-closed；
2. 正式文本绑定正确会议、紧邻上一期、发布时间和 source_version；
3. 正式存储原子、幂等、同版本异文冲突且既有数据零污染；
4. 8013 正常态、空态、错事件和刷新失败态均可观察；
5. 调度 owner、互斥、窗口、重试、停用和移除可验证；
6. 六个子机制证据独立，正式 diff 未越出授权范围。

PASS 只表示 `POLICY_SOURCE_ACQUISITION_A2` 完成并可进入 V4.2 Batch B；不表示总体验收、研究质量或发布通过。

## 6. 回合历史

### R0 · A1 PASS 与 Human A2 授权

- A1 业务 tip `b1abce5`，Codex PASS 交接提交 `0955b26`；
- Human 明确授权开启 A2，并对 8013、外部网络只读、正式 data 写入、后台调度四项全部授权；
- A2 计划与 A1 归档提交 `e56f54a`；
- 新环 `PRD-EVENT-POLICY-15-A2` 开始于 `pending_exec / cursor`；
- 未声明 `POLICY_SOURCE_ACQUISITION_A2` 或 `EVENT_POLICY_INTELLIGENCE_V1`。
