---
type: 项目主文档
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
---

# 项目：financial-alert-system

## 大需求

- 把宏观、流动性、风险资产、链上、衍生品等因素整理为传播图。
- 对事件冲击进行路径推演和验证。
- 用健康检查规则保证图谱质量。
- 为金融分析提供可视化预警与决策辅助。

中心目标：**全球风险状态 → 资产篮子（BTC / Nasdaq / Gold / USD / Treasury）**。

## 边界

- 暂不接真实交易接口。
- 暂不做自动下单。
- 暂不承诺预测准确率。
- 暂不大改技术栈。

## 当前状态

图谱 124 节点 / 287 边，健康评分 94（healthy），核心 target 分层 + 交互式验证仪表已实现。详细进度见 [[AI项目控制台/financial-alert-system/任务进度]]。

## 相关笔记

- [[AI项目控制台/00_项目总索引]]
- [[AI项目控制台/financial-alert-system/需求拆分]]
- [[AI项目控制台/financial-alert-system/任务进度]]
- [[AI项目控制台/financial-alert-system/决策记录]]
- [[AI项目控制台/financial-alert-system/会话交接]]
