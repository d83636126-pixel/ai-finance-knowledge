---
title: acceptance_registry 整改段设计（RG0）
date: 2026-07-16
project: financial-alert-system
type: 设计说明
status: draft_design_only
note: 本文件只定义设计；本轮故意不改 _sync/acceptance_registry.json 探针，避免工程 ACCEPTED 被误读为发布通过。
---

# acceptance_registry 整改段设计（RG0）

## 原则

1. 现有 `items`（workbench-p0-p4 / engineering-gate / core-propagation）保持原语义：只证明结构与工程门禁。
2. 统一工作台发布/研究级门禁放入独立 `remediation` 对象，由人工与 `-R`/`v2` 工件驱动。
3. `delete_executed` 与 `observation_status` 必须分字段，禁止用删除事实冒充观察通过。

## 建议字段（后续增量写入 JSON 时采用）

```json
{
  "remediation": {
    "schema": "fas-remediation-gate-v1",
    "plan_relpath": "AI项目控制台/financial-alert-system/04_研究工作台/01_规划/统一研究工作台_审核阻断修复与重新验收计划_2026-07-16.md",
    "rg0_report_relpath": "AI项目控制台/financial-alert-system/04_研究工作台/02_重构执行/统一研究工作台_RG0整改重开与基线_2026-07-16.md",
    "release_gate": "blocked",
    "cloud_gate": "blocked",
    "code_head_at_rg0": "ffa0093900c0a7c3040d9c0be0fc585259c3316a",
    "split_flags": {
      "delete_executed": true,
      "observation_status": "not_run"
    },
    "phases": {
      "RG0": "complete",
      "SEC0": "not_started",
      "RT1": "not_started",
      "TRUTH1": "not_started",
      "CTX1": "not_started",
      "GATE1": "not_started",
      "UX2": "not_started",
      "UW3-R": "not_started",
      "UW4-R": "not_started",
      "UW6-R": "not_started",
      "UW7-R": "not_started",
      "UW8-R": "not_started"
    },
    "historical_uw_audit": {
      "UW0": "PASS",
      "UW1": "CONDITIONAL",
      "UW2": "PASS",
      "UW3": "BLOCK",
      "UW4": "BLOCK",
      "UW5": "CONDITIONAL",
      "UW6": "BLOCK",
      "UW7": "BLOCK",
      "UW8": "NOT_RUN"
    }
  }
}
```

## 同步脚本约束（建议）

- `sync_vault_status.ps1` 若读取 remediation：`release_gate=blocked` 时任务进度必须显示「发布阻断」。
- 不得因为 `engineering-gate=ACCEPTED` 自动把统一工作台标为 complete。

## 本轮状态

- 设计已落地（本文件）。
- `_sync/acceptance_registry.json` **未修改**（避免误升 AUTO STATUS）。
