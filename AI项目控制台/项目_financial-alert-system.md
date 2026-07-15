---
type: 项目主文档
tags: [项目, financial-alert-system, 金融预警, 传播图, AI协作]
created: 2026-07-05
updated: 2026-07-12
status: active
项目名: financial-alert-system
定位: 宏观传导研究 + 预警能力补强
当前阶段: 研究工作台有条件通过；V2 盲测主线
最近更新: 2026-07-12
---

# 项目：financial-alert-system

## 项目定位

**宏观传导研究 + 预警能力补强的混合系统。**

- 传播图补全 Alert「缺宏观链路」问题
- 核心场景：事前分析 + 事后对比
- 推送 / Cron 延后（P3）

中心目标：**全球风险状态 → 资产篮子（BTC / Nasdaq / Gold / USD / Treasury）**。

## 路径映射（多机）

| 角色 | 路径 | 本机会话（2026-07-12） |
|------|------|------------------------|
| **Obsidian 主副本** | `D:\AI  金融知识点` | 应用中 |
| Obsidian 历史 | `F:\AI 金融知识点` | 未用；在其他机器时可能可用 |
| **代码优先** | `D:\financial-alert-system` | 优先使用 |
| 代码历史 / 他机 | `F:\financial-alert-system` | 他机可用时再切 |
| 代码 GitHub | https://github.com/d83636126-pixel/financial-alert-system | private |
| 废弃执行路径 | Downloads 下过渡副本 | 勿再作为执行根 |

**可用性检查：** 开工前 `Test-Path` 代码根；失败则标注「项目在其他机器，非丢失」，改做文档任务或请用户切换机器。

启动（代码根下）：

```text
start_server.bat
→ http://127.0.0.1:8000/propagation.html
→ http://127.0.0.1:8000/index.html
```

## 背景

从传播图 / 研究工作台迭代至 P0–P4 功能验收；整体仍为有条件通过。控制信息只写本 vault，源码在独立 Git 仓。

## 当前阶段（2026-07-12）

**研究工作台 P1–P4：功能通过；项目整体：有条件通过。**  
报告：[[AI项目控制台/financial-alert-system/验收报告_研究工作台_有条件通过_2026-07-12]]

| 层 | 状态 |
|----|------|
| 完整模式图谱 | ✅ |
| 研究工作台 P1–P4 | ✅ 功能验收通过 |
| 项目整体验收 | ⚠️ 有条件通过 |
| 验证器实时值 | ⏳ 结构有、数据待刷新 |
| V2 盲测可信度 | ⏳ 主线 |
| V2 突发推送分析 | ⏳ 辅线 |

详细：[[AI项目控制台/financial-alert-system/任务进度]]  
V2：[[AI项目控制台/financial-alert-system/需求拆分_V2_2026-07-11]]

## 边界（暂不做）

- 暂不接真实交易接口 / 自动下单
- 暂不承诺预测准确率或收益
- 暂不大改技术栈
- 推送放在 V2.2，不抢盲测主线

## 大需求

- 把宏观、流动性、风险资产、链上、衍生品等因素整理为传播图
- 对事件冲击做路径推演与验证
- 用健康检查保证图谱质量
- 为分析提供可视化预警与决策辅助

## 关键决策

见 [[AI项目控制台/financial-alert-system/决策记录]]（含是否已被推翻字段实践）。

## 下一步行动

1. V2.0：盲测评分口径 + 批量跑分
2. V2.1：突发影响分析 + 三情景预判
3. V2.2：推送闭环
4. 本机可写时重跑 `smoke_archive` / 刷新 verifier

## 验收标准

- 研究工作台：见有条件通过报告中的门禁与冒烟
- V2：盲测口径与跑分可复现后，再谈「完全通过」

## 相关笔记

- [[AI项目控制台/00_项目总索引]]
- [[AI项目控制台/financial-alert-system/需求拆分]]
- [[AI项目控制台/financial-alert-system/需求拆分_V2_2026-07-11]]
- [[AI项目控制台/financial-alert-system/任务进度]]
- [[AI项目控制台/financial-alert-system/决策记录]]
- [[AI项目控制台/financial-alert-system/会话交接]]
- [[AI协作记忆系统/AI记录规范]]
