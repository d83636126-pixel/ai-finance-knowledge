---
type: 图谱目标设计
tags: [项目, financial-alert-system, 图谱, target, USD, Treasury]
created: 2026-07-05
updated: 2026-07-05
status: implemented
---

# USD / Treasury 目标节点设计 2026-07-05

## 背景

核心输出资产篮子已确认为：

```text
BTC + Nasdaq + Gold + USD + Treasury
```

其中：

- `btc_price` 已是 target。
- `nasdaq` 已升级为 target。
- `gold_price` 已是 target。
- `usd_index` 原本是 intermediate。
- `treasury_yield` 原本是 intermediate。

## 设计决策

### USD

将 `usd_index` 从 `intermediate` 升级为 `target`。

原因：

- USD 输出可以直接用 DXY 表达。
- DXY 是全球美元压力、风险状态和利差变化的核心表现。

执行结果：

```text
usd_index.type = target
usd_index.subtype = currency_index
```

### Treasury

保留 `treasury_yield` 为 `intermediate`，新增 `treasury_bond_return` 作为 target。

原因：

- `treasury_yield` 是收益率，不等于债券价格或债券回报。
- 收益率上升通常对应债券价格/回报下降。
- 如果直接把 `treasury_yield` 当作 target，输出方向容易误读。

执行结果：

```text
treasury_yield.type = intermediate
treasury_bond_return.type = target
treasury_bond_return.subtype = bond_return
```

## 本次新增边

```text
global_risk_state -> usd_index
global_inflation_pressure -> treasury_yield
global_inflation_pressure -> real_yield
global_growth_expectation -> nasdaq
global_dollar_stress -> btc_price
global_dollar_stress -> gold_price
treasury_yield -> treasury_bond_return
real_yield -> treasury_bond_return
global_risk_state -> treasury_bond_return
```

## 校验结果

- 节点数：113
- 边数：252
- target 节点数：8
- JSON 校验：通过
- 坏边引用：0
- 孤立节点：0
- 图谱健康评分：88
- 图谱状态：watch

## 当前 target 节点

```text
usd_index
btc_price
nasdaq
eth_price
spx
gold_price
altcoin_season
treasury_bond_return
```

## 下一步

下一步应讨论：

- 是否将 `ETH / SPX / altcoin_season` 归为第二层输出，而不是第一版核心输出。已完成。
- 是否在 UI 中区分“核心 target”和“扩展 target”。已确认。
- 是否补充 target 权重或 target_priority 字段。已完成。

详见：

- [[AI项目控制台/financial-alert-system/02_宏观图谱/01_架构与设计/Target分层规则_2026-07-05]]
