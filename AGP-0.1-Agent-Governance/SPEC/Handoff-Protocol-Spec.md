# Handoff Protocol Specification

> [!abstract] 规格说明
> 定义多 Agent 协作时的交接协议和状态传递规范。

---

## 1. 交接场景

```typescript
enum HandoffTrigger {
  TASK_COMPLETE = "task_complete",       // 任务完成
  TASK_TIMEOUT = "task_timeout",         // 任务超时
  CAPABILITY_LIMIT = "capability_limit", // 能力边界
  USER_REQUEST = "user_request",         // 用户请求
  ERROR_ESCALATION = "error_escalation"  // 错误升级
}

interface HandoffContext {
  // 交接基本信息
  handoff_id: string
  trigger: HandoffTrigger
  timestamp: ISO8601

  // 源 Agent
  source: {
    agent_id: string
    contract_id: string
    completed_steps: string[]
    partial_output: any
  }

  // 目标 Agent
  target?: {
    agent_id: string
    required_capabilities: string[]
    estimated_complexity: "low" | "medium" | "high"
  }

  // 传递数据
  payload: {
    evidence_graph_snapshot: string    // 图谱快照 ID
    task_state: TaskState
    accumulated_context: ContextSummary
    unresolved_questions: string[]
  }
}
```

## 2. 交接状态

```
┌──────────┐    initiate()    ┌──────────┐
│  NONE   │ ────────────────▶│ PENDING  │
└──────────┘                 └────┬─────┘
                                   │
          ┌────────────────────────┼────────────────────────┐
          │                        │                        │
          ▼                        ▼                        ▼
   ┌──────────┐            ┌──────────┐            ┌──────────┐
   │ TRANSFER │            │  ACCEPT  │            │  REJECT  │
   └────┬─────┘            └────┬─────┘            └────┬─────┘
        │                       │                        │
        │ complete()            │                        │ reason
        ▼                       ▼                        ▼
   ┌──────────┐            ┌──────────┐            ┌──────────┐
   │COMPLETED │            │  ACTIVE  │            │ ABORTED  │
   └──────────┘            └──────────┘            └──────────┘
```

## 3. 交接协议

### 3.1 发起交接

```typescript
async function initiateHandoff(ctx: HandoffContext): Promise<HandoffResult> {
  // 1. 验证源 Agent 身份
  await validateIdentity(ctx.source.agent_id)

  // 2. 生成图谱快照
  const snapshot = await createEvidenceSnapshot(ctx.payload.evidence_graph_id)

  // 3. 验证目标能力
  if (ctx.target) {
    const capability_check = await verifyCapabilities(
      ctx.target.agent_id,
      ctx.target.required_capabilities
    )
    if (!capability_check.valid) {
      throw new HandoffRejectedError("Insufficient capabilities", capability_check.gaps)
    }
  }

  // 4. 传输上下文
  const transfer_result = await transferContext({
    snapshot_id: snapshot.id,
    task_state: ctx.payload.task_state,
    context: ctx.payload.accumulated_context
  })

  // 5. 发送确认
  return {
    handoff_id: ctx.handoff_id,
    status: "TRANSFER",
    snapshot_id: snapshot.id,
    transfer_token: transfer_result.token
  }
}
```

### 3.2 接受交接

```typescript
async function acceptHandoff(handoff_id: string, token: string): Promise<void> {
  // 1. 验证 token
  await validateTransferToken(handoff_id, token)

  // 2. 恢复上下文
  const ctx = await restoreContext(handoff_id)

  // 3. 初始化任务状态
  await initializeTaskState(ctx.payload.task_state)

  // 4. 更新证据图谱
  await mergeEvidenceSnapshot(ctx.payload.evidence_graph_snapshot)
}
```

## 4. 上下文传递规则

| 数据类型 | 传递方式 | 完整性要求 |
|---------|---------|-----------|
| 证据图谱 | 快照 + 差异 | 必须完整 |
| 任务状态 | 完整序列化 | 必须一致 |
| 上下文摘要 | 压缩摘要 | 关键信息不丢失 |
| 未解决问题 | 列表 | 必须传递 |

## 5. 失败处理

| 失败场景 | 处理策略 |
|---------|---------|
| 目标 Agent 不可达 | 重试 3 次 → 升级到 supervisor |
| Token 验证失败 | 拒绝交接 → 源 Agent 保留任务 |
| 上下文不完整 | 中止交接 → 记录缺口 |
| 超时 | 释放租约 → 标记为暂停 |

## 6. 验收检查清单

- [ ] 源 Agent 身份验证通过
- [ ] 目标 Agent 能力匹配
- [ ] 证据图谱快照完整
- [ ] 任务状态序列化成功
- [ ] 交接 token 有效
- [ ] 上下文恢复验证通过

## 7. 关联

- [[AGP-0.1-Protocol-RFC]]
- [[ADR/ADR-001-Agent-Identity]]
- [[ADR/ADR-002-Evidence-Graph]]
- [[ADR/ADR-003-Lease-Model]]
- [[SPEC/Task-Contract-Spec]]
- [[SPEC/Validation-Gate-Spec]]
