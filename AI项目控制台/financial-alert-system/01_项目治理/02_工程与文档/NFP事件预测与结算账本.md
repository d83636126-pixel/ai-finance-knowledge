---
type: 事件账本
tags: [NFP, 冻结, 结算, 盲测, 前瞻]
created: 2026-07-17
updated: 2026-07-17
status: active
project: financial-alert-system
---

# NFP 事件预测与结算账本

> [!important]
> 本账本只登记**可审计**事件卡。脚手架卡（`engineering_scaffold` / `synthetic_reactions=true`）可附注，但**不得**计入研究完成数。
> 执行计划：[[NFP真实盲测执行计划_2026-07-17]]

## 计数（人工维护；以门禁工件为准）

| 指标 | 当前 | 目标 | 证据 |
|---|---|---|---|
| 历史盲测合格 | **0** | ≥20 | `artifacts/nfp_research_blind_gate.json` → BLOCK |
| 真实前瞻已结算 | **0** | ≥3 | OBSERVING |
| 研究有效性 | BLOCK | RESEARCH_PASS | 主计划第 4 阶段 |

## 前瞻队列

| event_id | 期间 | 官方发布 | 模式 | 共识 | 冻结 | 结算 | 窗口 | 备注 |
|---|---|---|---|---|---|---|---|---|
| `nfp_2026_07` | 2026-07 | 2026-08-07 08:30 ET | live_forward | ⏳ 待 T-7 回填 | ⏳ | ⏳ | ⏳ | [[04_推演跟踪/2026年7月非农数据跟踪_占位]] |
| （下一场） | 2026-08 | ~2026-09-04 | live_forward | — | — | — | — | 日历待 T-1 复核 |
| （再下一场） | 2026-09 | ~2026-10-02 | live_forward | — | — | — | — | 日历待 T-1 复核 |

## 历史盲测候选

| period | 发布日 | 共识 provenance | 市场窗口 | 研究信用 | 备注 |
|---|---|---|---|---|---|
| 2026-06 | 2026-07-02 | 库内约 110–115k，**仍缺事前快照** | ❌ Yahoo 403（2026-07-17 试采失败） | ❌ 未授 | 事件已登记；窗口/共识均未过关 |
| 2026-05 | 2026-06-05 | 85k vs 130k 冲突 | — | ❌ | 先外部裁定 |
| 2025-10 | 停摆月 | 明确缺共识 | — | ❌ | 负样本 |
| 其余 scaffold seed | 多期 | BLS naive | 合成 | ❌ | 仅工程 |

## 结算登记模板（每事件一行复制）

```text
event_id:
period:
official_release_at:
research_mode: historical_as_of | live_forward
pre.content_hash:
consensus.provider / source_url / captured_at:
synthetic_reactions: false
primary_window (t_plus_30m) 五资产方向:
settlements summary:
vs baselines delta:
failure_notes:
card_path: data/nfp_cards/<id>.json
```

## 规则

1. 事前卡冻结后禁止改 `pre`。
2. 无 Street 快照或无五窗口原始行情 → 不登记为合格样本。
3. 历史回填卡永久不得计入前瞻。

## 关联

- [[项目收缩与核心闭环整改计划_2026-07-16]]
- [[NFP真实盲测执行计划_2026-07-17]]
- [[任务进度]]
