---
type: 事件账本
tags: [NFP, 冻结, 结算, 盲测, 前瞻]
created: 2026-07-17
updated: 2026-07-18
status: active
project: financial-alert-system
---

# NFP 事件预测与结算账本

> [!important]
> 计数三档（勿混用）：
> - `gate_eligible` = 门禁 RESEARCH_ELIGIBLE 卡数
> - `audit_pass` = 人工 AUDIT_PASS 卡数
> - `research_counted` = 同时满足上两者（小样本进度）
>
> **禁止**把 `events_research_ok` 直接说成“研究已通过”。权威工件：`artifacts/nfp_research_counts.json`

## 计数（人工维护；以门禁工件为准）

| 指标 | 当前 | 目标 | 证据 |
|---|---|---|---|
| gate_eligible | **5** | — | 门禁 v2 RESEARCH_ELIGIBLE（小样本 5 场） |
| audit_pass | **5** | — | 人工审计工件 |
| research_counted | **5** | 5（小样本✅）/ ≥20（聚合） | `artifacts/nfp_research_counts.json` |
| 聚合 RESEARCH_PASS | BLOCK | RESEARCH_PASS | 需 ≥20 research_counted + 指标 |

## 前瞻队列

| event_id | 期间 | 官方发布 | 模式 | 共识 | 冻结 | 结算 | 窗口 | 备注 |
|---|---|---|---|---|---|---|---|---|
| `nfp_2026_07` | 2026-07 | 2026-08-07 08:30 ET | live_forward | ⏳ 待 T-7 回填 | ⏳ | ⏳ | ⏳ | [[04_推演跟踪/2026年7月非农数据跟踪_占位]] |
| （下一场） | 2026-08 | ~2026-09-04 | live_forward | — | — | — | — | 日历待 T-1 复核 |
| （再下一场） | 2026-09 | ~2026-10-02 | live_forward | — | — | — | — | 日历待 T-1 复核 |

## 历史盲测候选

| period | 发布日 | 共识 provenance | 市场窗口 | 研究信用 | 备注 |
|---|---|---|---|---|---|
| 2026-06 | 2026-07-02 | MUFG→Bloomberg 115k · auditable | Databento NQU6/ZTU6/DX + gold/btc | ✅ research_counted | 小样本 #1 AUDIT_PASS |
| 2026-04 | 2026-05-08 | FactSet/Bloomberg 65k · auditable | Databento NQM6/ZTM6/DX + gold/btc | ✅ research_counted | 小样本 #2 AUDIT_PASS；周五 t+1d→周一 |
| 2025-12 | 2026-01-09 | FactSet 55k · auditable | Databento NQH6/ZTH6/DX + gold/btc | ✅ research_counted | 小样本 #5 AUDIT_PASS；周五 t+1d→周一；**5/5 完成** |
| 2026-02 | 2026-03-06 | FactSet 60k · auditable | Databento NQH6/ZTM6/DX + gold/btc | ✅ research_counted | 小样本 #4 AUDIT_PASS；周五 t+1d→周一 |
| 2026-01 | 2026-02-11 | FactSet 75k · auditable | Databento NQH6/ZTH6/DX + gold/btc | ✅ research_counted | 小样本 #3 AUDIT_PASS；周三正常会话 |
| 2026-03 | 2026-04-03 | — | — | ❌ **EXCLUDED_HOLIDAY_SESSION** | Good Friday 早收；不计分母；非研究失败 |
| 2026-05 | 2026-06-05 | 85k vs 130k 冲突 | — | ❌ | 排除出小样本 |
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
