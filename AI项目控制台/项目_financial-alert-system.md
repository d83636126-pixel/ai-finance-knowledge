---
type: 项目主文档
<<<<<<< HEAD
tags: [项目, financial-alert-system, 金融预警, 传播图, AI协作]
created: 2026-07-05
updated: 2026-07-05
status: active
local_path: F:\financial-alert-system
=======
项目名: financial-alert-system
路径:
  当前机器: C:\financial-alert-system
  已知机器:
    - 机器标识: F盘机器
      路径: F:\financial-alert-system
      最近确认可访问: 2026-07-05
    - 机器标识: C盘机器
      路径: C:\financial-alert-system
      最近确认可访问: 2026-07-07（当前机器路径存在但源码目录为空，项目文件在其他机器，非丢失）
可用性检查: 2026-07-07 当前机器 C 盘路径下源码目录为空，判定为"项目在另一台机器，非丢失"，需切换机器或从 GitHub 同步
定位: 金融预警与传播图系统——把宏观事件、政策冲击、流动性变化、风险资产反应等因素结构化，通过图谱辅助判断市场传导路径
当前阶段: 开发中
最近更新: 2026-07-07
>>>>>>> origin/main
---

# 项目：financial-alert-system

<<<<<<< HEAD
## 项目定位

本项目是一个金融预警 / 传播图系统。

从当前文件判断，它包含：

- `index.html`：主页面。
- `propagation.html`：传播图页面。
- `architecture.html`：架构页面。
- `propagation_graph.json`：传播图数据。
- `graph_schema.md`：传播图结构规范。
- `static/`：前端脚本与静态资源。
- `local_server.js`：本地静态服务器。

## 本机位置

```text
F:\financial-alert-system
```

## 当前状态

截至 2026-07-05：

- 项目目录存在。
- 目前没有发现 README。
- 已有传播图 schema，说明 `propagation_graph.json` 被当作决策资产管理。
- 本项目适合纳入 Obsidian 作为“金融预警系统”长期开发项目。

## 已知运行方式

根据 `local_server.js`：

```text
node local_server.js
```

默认地址：

```text
http://127.0.0.1:8000
```

## 大需求

待确认。

当前可推测的大方向：

=======
## 大需求

>>>>>>> origin/main
- 把宏观、流动性、风险资产、链上、衍生品等因素整理为传播图。
- 对事件冲击进行路径推演和验证。
- 用健康检查规则保证图谱质量。
- 为金融分析提供可视化预警与决策辅助。

<<<<<<< HEAD
## 小需求拆分

详见：[[AI项目控制台/financial-alert-system/需求拆分]]

## 当前阶段

项目登记阶段。

## 下一步行动

- 读取项目核心脚本，确认现有功能边界。
- 补写 README 或项目需求说明。
- 建立任务拆分文档。
- 明确第一版要完成的最小闭环。

## 验收标准

待确认。

第一阶段建议验收：

- 能清楚说明系统目的。
- 能本地打开主要页面。
- 能解释 `propagation_graph.json` 中节点和边的作用。
- 能列出下一批开发任务。
=======
中心目标：**全球风险状态 → 资产篮子（BTC / Nasdaq / Gold / USD / Treasury）**。

## 边界

- 暂不接真实交易接口。
- 暂不做自动下单。
- 暂不承诺预测准确率。
- 暂不大改技术栈。

## 当前状态

图谱 124 节点 / 287 边，健康评分 94（healthy），核心 target 分层 + 交互式验证仪表已实现。详细进度见 [[AI项目控制台/financial-alert-system/任务进度]]。
>>>>>>> origin/main

## 相关笔记

- [[AI项目控制台/00_项目总索引]]
- [[AI项目控制台/financial-alert-system/需求拆分]]
- [[AI项目控制台/financial-alert-system/任务进度]]
- [[AI项目控制台/financial-alert-system/决策记录]]
- [[AI项目控制台/financial-alert-system/会话交接]]
<<<<<<< HEAD
- [[AI协作记忆系统/AI记录规范]]
=======
>>>>>>> origin/main
