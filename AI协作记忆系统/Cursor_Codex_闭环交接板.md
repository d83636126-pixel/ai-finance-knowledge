---
type: Cursor_Codex闭环交接板
schema_version: 2
tags: [AI协作, Cursor, Codex, Obsidian, 产品路线图, V3.5, PRD-LOCAL-CONTINUITY-13]
created: 2026-07-28
updated: '2026-07-28'
project: financial-alert-system
loop_id: PRD-LOCAL-CONTINUITY-13
acceptance: LOCAL_PRODUCT_CONTINUITY_V1_PASS
revision: 8
turn: 0
next_actor: 'cursor'
status: 'pending_exec'
max_turns: 3
last_writer: 'human'
written_at: '2026-07-28T04:56:14.897Z'
lease_owner: ''
lease_actor: ''
lease_expires_at: ''
code_root: 'F:\financial-alert-system'
vault_note: AI协作记忆系统/Cursor_Codex_闭环交接板.md
repo_mirror: docs/ai-collab/Cursor_Codex_闭环交接板.md

---
# Cursor ↔ Codex 闭环交接板

> [!important] 当前状态：**PRD-LOCAL-CONTINUITY-13 · V3.5 本地产品交付与研究资产保全 · 已批准待执行**
>
> 当前验收：`LOCAL_PRODUCT_CONTINUITY_V1_PASS` 尚未声明
> 产品基线：`2661ddd`
> 治理基线：`dec08d9`

## 0. 产品边界

- 本环只解决唯一启动入口、产品资产导出和隔离恢复。
- 默认资产范围限于 V3 事件研究产品资产，不打包整个仓库或 RES 研究库。
- 恢复只允许写入新的空目录，禁止覆盖原数据。
- 不上云、不重写数据库、不宣称 `RESEARCH_PASS` 或 `RELEASE_PASS`。
- Batch A/B/C 连续执行，结束后一次集中 R1。

## 1. 任务目标

| 字段 | 内容 |
|---|---|
| 所属轨道 | `PROD` |
| 审核等级 | `R1`（整环一次集中产品验收） |
| 一句话目标 | 一个入口启动今日简报，并能导出、隔离恢复 V3 产品资产 |
| 成功标准 | `LOCAL_PRODUCT_CONTINUITY_V1_PASS` |
| 产品基线 | `2661ddd` |
| 治理基线 | `dec08d9` |
| 执行计划 | `产品发展执行计划_V3.5_本地产品交付与研究资产保全_2026-07-27.md` |

## 2. 仪表盘

| 项 | 值 |
|---|---|
| loop_id | `PRD-LOCAL-CONTINUITY-13` |
| stage | V3.5 已批准；Batch A 等待执行 |
| status / next_actor | `pending_exec` / `cursor` |
| HEAD | `dec08d9` |
| Batch A | 未开始：唯一启动入口 + 连续性页面 |
| Batch B | 未开始：资产导出 + manifest |
| Batch C | 未开始：隔离恢复 + 真实走查 |
| acceptance | 尚未声明 |

## 3. Cursor 当前执行指令

连续完成三个批次，不分段提交审核：

### Batch A

- 新增 `start_local_product.bat` / `stop_local_product.bat`；
- 复用现有端口所有权保护；
- 默认打开 `daily_briefing.html`；
- 增加用户可理解的本地产品与备份页面；
- 显示真实数据根、资产数量和最近成功备份。

### Batch B

- 实现严格 allowlist 的 V3 产品资产导出；
- 生成资产包和 `manifest.json`；
- 清单绑定路径、大小、SHA-256、包含/引用/排除分类；
- 密钥、缓存、测试工件、NFP bulk/raw/held-out/forward 禁止进入默认包；
- 失败时不得写“备份成功”。

### Batch C

- 增加最小 `FAS_PRODUCT_DATA_ROOT` 接线；
- 恢复目标只允许不存在或为空的目录；
- 在独立端口启动隔离恢复实例；
- 打开同一 `event_id` 的台账、研究记录、收尾卡和准备清单；
- 验证原始产品资产前后 SHA-256 一致；
- 提供 Human 五分钟产品走查清单。

完成后一次性提交 V3.5 文件，并把本板切为 `pending_review / codex`。

## 4. Cursor 完成报告

```text
等待 Cursor 完成 Batch A/B/C 后填写。
```

## 5. Codex 集中 R1

只审查以下产品阻断：

1. 原数据是否可能被覆盖或修改；
2. 资产包是否可能包含密钥或受限内容；
3. manifest、文件数量与 SHA-256 是否一致；
4. 隔离恢复后真实事件、研究记录和收尾卡是否可打开；
5. 启停是否可能误停其他端口或其他程序；
6. 产品是否会在导出/恢复失败时误报成功。

文案、布局、更多格式、性能优化和附加负向用例登记后续事项，不开启新一轮技术整改。

## 6. Human 产品验收

Human 最终执行：

```text
唯一入口启动
→ 今日简报
→ 查看数据与备份状态
→ 导出资产包
→ 预览并恢复到空目录
→ 独立端口打开恢复实例
→ 打开同一事件、研究记录和收尾卡
→ 停止恢复实例
→ 确认原产品未受影响
```

未完成前不得声明 `LOCAL_PRODUCT_CONTINUITY_V1_PASS`。

## 7. 下一步

当前由 Cursor 执行：

`执行Cursor_Codex闭环交接板当前指令`

V3.5 完成后不自动开启 V4.0，由 Human 重新选择产品维护、研究轨道或下一阶段路线。

