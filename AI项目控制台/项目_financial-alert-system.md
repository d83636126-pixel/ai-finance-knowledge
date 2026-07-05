---
type: 项目主文档
tags: [项目, financial-alert-system, 金融预警, 传播图, AI协作]
created: 2026-07-05
updated: 2026-07-05
status: active
local_path: F:\financial-alert-system
---

# 项目：financial-alert-system

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

- 把宏观、流动性、风险资产、链上、衍生品等因素整理为传播图。
- 对事件冲击进行路径推演和验证。
- 用健康检查规则保证图谱质量。
- 为金融分析提供可视化预警与决策辅助。

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

## 相关笔记

- [[AI项目控制台/00_项目总索引]]
- [[AI项目控制台/financial-alert-system/需求拆分]]
- [[AI项目控制台/financial-alert-system/任务进度]]
- [[AI项目控制台/financial-alert-system/决策记录]]
- [[AI项目控制台/financial-alert-system/会话交接]]
- [[AI协作记忆系统/AI记录规范]]
