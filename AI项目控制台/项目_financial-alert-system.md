---
type: 项目主文档
tags: [项目, financial-alert-system, 金融预警, 传播图, AI协作]
created: 2026-07-05
updated: 2026-07-10
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
| 代码（当前） | `C:\Users\Administrator\Downloads\financial-alert-system` | 可运行源码 |
| 代码（历史） | `F:\financial-alert-system` | 早期机器 |

启动：

```text
start_server.bat
→ http://127.0.0.1:8000/propagation.html
→ http://127.0.0.1:8000/index.html
```

## 当前阶段（2026-07-10）

**P1 + P2 已闭环。**

| 层 | 状态 |
|----|------|
| 完整模式图谱 | ✅ |
| 验证器 9/9 | ✅ |
| 日历/Inbox 事前事后 | ✅ |
| Case FOMC/NFP/CPI/PPI | ✅ |
| Alert↔图谱↔Inbox | ✅ |
| 推送 | ⏸ 延后 |

详细进度：[[AI项目控制台/financial-alert-system/任务进度]]  
路线图：[[AI项目控制台/financial-alert-system/最终用途与路线图_2026-07-10]]

## 边界

- 暂不接真实交易接口 / 自动下单
- 暂不承诺预测准确率
- 暂不大改技术栈
- 推送非当前优先级

## 大需求

- 把宏观、流动性、风险资产、链上、衍生品等因素整理为传播图
- 对事件冲击做路径推演与验证
- 用健康检查保证图谱质量
- 为分析提供可视化预警与决策辅助

## 下一步行动

1. 可选：事前/事后结果常驻面板
2. 可选：代码仓推送 GitHub
3. 延后：P3 推送

## 相关笔记

- [[AI项目控制台/00_项目总索引]]
- [[AI项目控制台/financial-alert-system/需求拆分]]
- [[AI项目控制台/financial-alert-system/任务进度]]
- [[AI项目控制台/financial-alert-system/决策记录]]
- [[AI项目控制台/financial-alert-system/最终用途与路线图_2026-07-10]]
- [[AI项目控制台/financial-alert-system/会话交接]]
- [[AI项目控制台/financial-alert-system/突发事件处理_2026-07-10]]
- [[AI协作记忆系统/AI记录规范]]
