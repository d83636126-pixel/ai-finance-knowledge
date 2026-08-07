# Case-001: Execution Pointer Mismatch

> [!abstract] 案例分析
> 分析 Agent 执行指针与实际状态不一致的问题及解决方案。

---

## 问题描述

### 现象

Agent 声称执行了某操作，但实际状态未发生变化：

```
[Agent] 执行: DELETE /api/users/123
[Agent] 报告: 操作成功，状态码 200
[实际]   响应: 403 Forbidden (权限不足)
```

### 影响

- 用户获得错误反馈
- 问题根源被掩盖
- 后续操作基于错误假设

---

## 根因分析

### 证据图谱

```
┌─────────────┐     claims      ┌─────────────┐
│ Action Node │ ───────────────▶│ Report Node │
│ (DELETE)    │                │ (200 OK)    │
└─────────────┘                └─────────────┘
       │                              ▲
       │ actual_response              │
       │ (403)                        │ interprets
       ▼                              │
┌─────────────┐                ┌─────────────┐
│ Reality Node│ ───────────────▶│ State Node  │
│ (403)       │                 │ (unchanged) │
└─────────────┘                └─────────────┘
```

### 问题类型

| 类型 | 描述 | 频率 |
|------|------|------|
| 网络分层 | Agent 读取 HTTP 层，忽略应用层错误 | 高 |
| 缓存污染 | 返回缓存的成功状态，实际请求失败 | 中 |
| 错误处理 | 异常被捕获但返回成功 | 中 |
| 并发竞态 | 状态在报告后被其他进程修改 | 低 |

---

## 解决方案

### 1. 验证门禁 (Pointer Gate)

```json
{
  "gate_id": "gate-pointer-case001",
  "type": "pointer",
  "config": {
    "verify_claimed_vs_actual": true,
    "check_response_code": true,
    "verify_state_change": true,
    "response_code_field": "status",
    "expected_success_range": [200, 299]
  }
}
```

### 2. 证据收集规则

```typescript
interface ExecutionEvidence {
  // 请求证据
  request: {
    method: string
    url: string
    headers: Record<string, string>
    body?: any
  }

  // 响应证据
  response: {
    status_code: number
    headers: Record<string, string>
    body?: any
    timing_ms: number
  }

  // 状态证据
  state: {
    before: Record<string, any>
    after: Record<string, any>
    changed: boolean
  }

  // 一致性验证
  consistency: {
    status_indicates_success: boolean
    state_changed: boolean
    timing_reasonable: boolean
  }
}
```

### 3. 修复流程

```
检测指针不一致
       │
       ▼
┌──────────────────┐
│ 记录完整证据     │
│ - 声称的结果     │
│ - 实际结果       │
│ - 状态差异       │
└──────────────────┘
       │
       ▼
┌──────────────────┐
│ 验证假设         │
│ - 网络可达？     │
│ - 权限正确？     │
│ - 参数有效？     │
└──────────────────┘
       │
       ▼
┌──────────────────┐
│ 生成诊断报告     │
│ - 根因推测       │
│ - 建议操作       │
│ - 影响评估       │
└──────────────────┘
```

---

## 验收门禁

| 门禁 | 要求 | 通过标准 |
|------|------|---------|
| 证据完整性 | 记录请求、响应、状态 | 三者齐全 |
| 指针一致性 | 声称 == 实际 | 一致率 ≥ 99% |
| 诊断准确 | 根因识别正确 | 准确率 ≥ 90% |

---

## 关联案例

- [[Case-002-未来案例|案例 2]]

## 关联规范

- [[Validation-Gate-Spec|验证门禁规格]]
- [[ADR-002-Evidence-Graph|证据图谱规范]]
