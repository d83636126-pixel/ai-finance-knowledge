---
type: 项目主文档
tags: [项目, financial-alert-system, 金融预警, 传播图, AI协作]
created: 2026-07-05
updated: 2026-07-12
status: active
---

# 项目：financial-alert-system

## 项目定位

**宏观传导研究 + 预警能力补强的混合系统。**

- 传播图补全 Alert「缺宏观链路」问题
- 核心场景：事前分析 + 事后对比
- 推送 / Cron 延后（P3）

中心目标：**全球风险状态 → 资产篮子（BTC / Nasdaq / Gold / USD / Treasury）**。

## 本机位置

| 类型 | 路径 | 说明 |
|------|------|------|
| **Obsidian 库（唯一）** | `F:\AI 金融知识点` | 进度/规划只改这里 |
| **代码（唯一正式）** | `F:\financial-alert-system` | 可运行源码 |
| 代码（过渡副本） | `C:\Users\Administrator\Downloads\financial-alert-system` | 勿再作为执行路径 |

启动：

```text
start_server.bat
→ http://127.0.0.1:8000/propagation.html
→ http://127.0.0.1:8000/index.html
```

## 当前阶段（2026-07-12）

**研究工作台 P1–P4：功能通过；项目整体：有条件通过。**  
报告：[[AI项目控制台/financial-alert-system/验收报告_研究工作台_有条件通过_2026-07-12]]

| 层 | 状态 |
|----|------|
| 完整模式图谱 | ✅ |
| 研究工作台 P1–P4 | ✅ 功能验收通过 |
| 项目整体验收 | ⚠️ 有条件通过（sync 路径 / 两项回归 / evidence / 十秒走查待解阻） |
| 验证器实时值 | ⏳ 结构有、数据尚未刷新（曾见 0/9） |
| 日历/Inbox 事前事后 | ✅ |
| Case / 盲测样本 / 结果存档 | ✅（`smoke_archive` 待可写环境重跑） |
| 推导仪表板 | ✅ [[推导仪表板_执行方案_2026-07-11]] |
| 图谱改进 Phase1–4 | ✅ [[图谱深度研判与改进方案_2026-07-11]] |
| **V2 盲测可信度** | ⏳ 主线（Phase4 校准已开） |
| **V2 突发推送分析** | ⏳ 辅线 |

详细：[[AI项目控制台/financial-alert-system/任务进度]]  
V2 大纲：[[AI项目控制台/financial-alert-system/需求拆分_V2_2026-07-11]]
仪表板：[[AI项目控制台/financial-alert-system/推导仪表板_执行方案_2026-07-11]]

## 边界

- 暂不接真实交易接口 / 自动下单
- 暂不承诺预测准确率或收益（预判仅为情景）
- 暂不大改技术栈
- 推送放在 V2.2，不抢盲测主线

## 大需求

- 把宏观、流动性、风险资产、链上、衍生品等因素整理为传播图
- 对事件冲击做路径推演与验证
- 用健康检查保证图谱质量
- 为分析提供可视化预警与决策辅助

## 下一步行动

1. V2.0：盲测评分口径 + 批量跑分
2. V2.1：突发影响分析 + 三情景预判
3. V2.2：推送闭环

## 相关笔记

- [[AI项目控制台/00_项目总索引]]
- [[AI项目控制台/financial-alert-system/需求拆分]]
- [[AI项目控制台/financial-alert-system/需求拆分_V2_2026-07-11]]
- [[AI项目控制台/financial-alert-system/任务进度]]
- [[AI项目控制台/financial-alert-system/决策记录]]
- [[AI项目控制台/financial-alert-system/最终用途与路线图_2026-07-10]]
- [[AI项目控制台/financial-alert-system/会话交接]]
- [[AI项目控制台/financial-alert-system/突发事件处理_2026-07-10]]
- [[AI协作记忆系统/AI记录规范]]
