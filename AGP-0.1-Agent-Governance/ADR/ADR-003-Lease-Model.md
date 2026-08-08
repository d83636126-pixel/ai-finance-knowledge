# ADR-003: Lease Model

> [!info] 架构决策记录
> - **编号**：ADR-003
> - **标题**：租约模型规范
> - **状态**：草稿
> - **决策日期**：2026-08-07
> - **影响范围**：任务执行、超时管理、资源控制

---

## 背景

Agent 执行任务需要明确的时间和资源边界。租约模型定义了这些边界的行为规范。

## 决策

### 租约类型

```typescript
enum LeaseType {
  HARD = "hard",    // 不可撤销，必须完成或明确失败
  SOFT = "soft"     // 可超时释放，需重新协商
}

interface Lease {
  type: LeaseType
  timeout_ms: number
  max_retries: number
  grace_period_ms: number    // 宽限期
  on_timeout: "fail" | "suspend" | "extend"
}
```

### 状态机

```
                    ┌─────────────┐
                    │   PENDING   │
                    └──────┬──────┘
                           │ start()
                           ▼
                    ┌─────────────┐
         ┌─────────│  ACTIVE     │─────────┐
         │         └──────┬──────┘         │
         │                │               │
    timeout()        complete()       fail()
         │                │               │
         ▼                ▼               ▼
  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐
  │  SUSPENDED  │  │  COMPLETED  │  │   FAILED    │
  └─────────────┘  └─────────────┘  └─────────────┘
         │                │               │
         │ extend()        │              │
         ▼                ▼               ▼
  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐
  │   ACTIVE    │  │  ARCHIVED   │  │   RETRY     │
  └─────────────┘  └─────────────┘  └─────────────┘
```

### 默认配置

| 场景 | Lease 类型 | 超时 | 重试次数 | 超时行为 |
|------|-----------|------|---------|---------|
| 简单查询 | SOFT | 30s | 2 | suspend |
| 数据分析 | SOFT | 5min | 3 | fail |
| 关键任务 | HARD | 10min | 1 | fail |
| 实时响应 | HARD | 5s | 0 | fail |

## 关联

- 父 RFC：[[AGP-0.1-Protocol-RFC]]
- 相关 ADR：[[ADR-001-Agent-Identity]], [[ADR-002-Evidence-Graph]]
- 规格文档：[[SPEC/Task-Contract-Spec]], [[SPEC/Handoff-Protocol-Spec]]
