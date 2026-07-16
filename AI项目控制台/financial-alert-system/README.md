<!-- AUTO:STATUS:BEGIN -->

> [!important] AUTO STATUS (do not hand-edit this block)
> generated_at: 2026-07-16T04:52:10.2392880Z
> code_root: `F:\financial-alert-system`
> git: `fa3fe38` / `master` (dirty)
> source: code probes + `_sync/acceptance_registry.json`

| item | status | evidence |
|---|---|---|
| 传播图核心页面存在（结构，非发布验收） | ACCEPTED | OK:propagation.html / OK:static/propagation_app.js / OK:propagation_graph.json |

sync:
```bat
powershell -NoProfile -ExecutionPolicy Bypass -File "F:\AI 金融知识点\AI项目控制台\financial-alert-system\_sync\sync_vault_status.ps1"
```

<!-- AUTO:STATUS:END -->


# financial-alert-system

> [!warning] 2026-07-11 路径纠正与分叉提示
> 正式源码目录应为 `F:\financial-alert-system`。复核发现，P1/P2 最新实现暂存在 Downloads 副本，而 F 盘正式目录尚未包含部分新文件。完成安全同步与回归前，不应把 Downloads 继续当作正式源码根目录，也不应声称 F 盘已经包含全部最新能力。

金融预警与传播图系统——把宏观事件、政策冲击、流动性变化、风险资产反应等因素结构化，通过图谱辅助判断市场传导路径。

**中心目标**：全球风险状态 → 资产篮子（BTC / Nasdaq / Gold / USD / Treasury）

## 当前路径

| 项 | 路径 |
|---|---|
| 正式源码目标 | `F:\financial-alert-system` |
| 最新实现暂存副本 | `C:\Users\Administrator\Downloads\financial-alert-system` |
| 当前启动脚本 | Downloads 副本中有 `start_server.bat`；F 盘尚未同步 |
| Propagation | `http://127.0.0.1:8000/propagation.html` |
| Dashboard | `http://127.0.0.1:8000/index.html` |
| 正式 Obsidian 库 | `F:\AI 金融知识点` |

正式开发和后续 Git 仓应以 F 盘为准。下一步需先比较并安全合并 Downloads 的新增实现，不能直接用覆盖方式抹掉 F 盘独有内容。

## 目标目录结构（当前完整实现见 Downloads，待同步至 F 盘）

```
financial-alert-system/
├── local_server.js              # Node.js 静态服务器（端口 8000）
├── propagation_graph.json       # 图谱数据（124 节点 / 287 边，健康评分 94）
├── graph_schema.md              # 图谱节点/边 schema 定义
├── index.html                   # 首页（系统概览）
├── propagation.html             # 传播图交互页面（图谱可视化+路径/Case报告）
├── architecture.html            # 架构说明页面
├── static/                      # 前端静态资源
│   ├── propagation_engine.js    # 传播路径搜索引擎（核心）
│   ├── propagation_app.js       # 完整模式应用入口
│   ├── propagation_quickload.js # 快速加载与状态处理
│   ├── scenario_reasoner.js     # 事前/事后分析
│   ├── case_catalog.js          # FOMC/NFP/CPI/PPI Case
│   ├── alert_graph_bridge.js    # Alert ↔ 图谱 ↔ Inbox
│   ├── major_events.js          # 主要事件数据
│   └── ingest/                  # 日历、Inbox、分类、数据抓取桥接
└── README.md
```

## 功能模块

### 传播引擎（`static/propagation_engine.js`）

核心函数：

| 函数 | 功能 |
|------|------|
| `findPaths()` | 在图谱中搜索传导路径，返回 `target_tier` 和 `target_priority` |
| `getExposure()` | 计算单事件各资产综合敞口 |
| `getPathReport()` | 生成单事件路径报告，资产敞口按核心 target 优先排序 |
| `getCaseReport()` | 生成综合 Case 报告（如 FOMC），含核心 target 验证仪表 |

### 图谱可视化（`propagation.html`）

- 交互式关系图渲染
- 逆向归因：从目标资产反向查找影响事件
- 节点类型：`event`（事件）、`intermediate`（中间传导）、`target`（目标资产）、`verifier`（验证指标）
- Target 分层展示：核心 target 节点更大/白色边框，扩展 target 绿色边框
- 下拉框按 optgroup 分组（核心 target / 扩展 target / 其他）
- 核心 Target 验证仪表：路径/Case 报告顶部，5 张卡片可点击展开详情
- 验证指标收集：自动从 `verifies` 边读取验证点并去重

关键 UI 函数：

| 函数 | 功能 |
|------|------|
| `targetTierLabel()` | 返回 target 层级标签 |
| `targetSort()` | 按 `target_priority` 排序 |
| `renderTargetValidationDashboard(targets, paths)` | 渲染核心 target 验证仪表 |
| `targetPanelId(scope, id)` | 生成 target 详情面板 ID |
| `showTargetValidationDetail(scope, targetId)` | 展开 target 验证详情 |

### 图谱数据（`propagation_graph.json`）

- **节点**：124 个（event / intermediate / target / verifier）
- **边**：287 条（含 verifies 边 15 条）
- **健康评分**：94（healthy），孤立节点 0，坏边引用 0，环路 0
- **Target 分层**：
  - 核心：BTC（priority 1）、Nasdaq（2）、Gold（3）、USD（4）、Treasury（5）
  - 扩展：ETH（101）、SPX（102）、Altcoin Season（103）

### 图谱治理

健康检查维度：孤立节点、坏边引用、重复节点、环路检测、subtype 完整性

## 运行方式

```bash
node local_server.js
# 访问 http://127.0.0.1:8000
```

主要页面：
- `http://127.0.0.1:8000/` — 首页
- `http://127.0.0.1:8000/propagation.html` — 传播图交互页面
- `http://127.0.0.1:8000/architecture.html` — 架构说明页面

## 传导链路

```
全球事件 / 数据 / 政策
  → 美元流动性、利率、通胀、增长、地缘、风险偏好
  → 全球风险状态（核心 hub）
  → BTC / Nasdaq / Gold / USD / Treasury（核心输出资产）
```

### 关键传导链

1. **财政供给链**：财政刺激 → 美债供给压力 → 期限溢价 → 美债收益率/回报/Nasdaq
2. **政策预期链**：政策收紧/宽松预期 → 实际利率/美元 → 实际利率冲击 → Nasdaq/Gold/BTC
3. **美元压力链**：美元融资压力 → 流动性收紧 → 风险资产/BTC/美债回报

### 验证指标覆盖

| 链条 | 验证指标 |
|------|---------|
| 美债期限溢价 | ACM 10Y 期限溢价、拍卖尾部、MOVE 指数 |
| 实际利率 | 10Y TIPS 实际收益率 |
| 美元压力 | DXY 动量 |
| 黄金确认 | 黄金 ETF 资金流 |
| BTC 确认 | BTC ETF 资金流 |
| Nasdaq 确认 | 市场宽度 |

## 边界

- 暂不接真实交易接口
- 暂不做自动下单
- 暂不承诺预测准确率
- 暂不大改技术栈

## 当前阶段

- 产品实现层：P1 与 P2 已在 Downloads 副本完成并通过既有验收。
- 正式源码层：F 盘尚未同步 P1/P2 的全部新增文件，当前存在工程阻塞。
- 下一工程动作：先做双目录差异清单、备份与安全合并，再在 F 盘重新回归。
- 下一优先：NFP/CPI 历史样本与防数据穿越的历史盲测。
- 第二优先：事前/事后结果常驻面板最小版。
- P3：推送、Cron、无人值守扫描，明确延后。

## 相关文档

本项目设计文档和进度记录在 Obsidian vault `AI项目控制台/financial-alert-system/` 中。

- [[AI项目控制台/financial-alert-system/01_项目治理/01_愿景与需求/需求拆分]]
- [[AI项目控制台/financial-alert-system/01_项目治理/01_愿景与需求/需求拆分_可选增强_2026-07-11]]
- [[AI项目控制台/financial-alert-system/任务进度]]
- [[AI项目控制台/financial-alert-system/01_项目治理/01_愿景与需求/最终用途与路线图_2026-07-10]]
- [[AI项目控制台/financial-alert-system/决策记录]]
- [[AI项目控制台/financial-alert-system/会话交接]]
