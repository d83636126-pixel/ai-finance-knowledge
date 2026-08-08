# Task Contract Specification

> [!abstract] 规格说明
> 定义 Agent 任务的标准化契约格式和验证要求。

---

## 1. 契约结构

```typescript
interface TaskContract {
  // 身份
  contract_id: string           // UUID v4
  version: string               // 语义版本
  created_at: ISO8601

  // 任务定义
  task: {
    description: string        // 人类可读描述
    type: TaskType              // 见下文枚举
    priority: "low" | "normal" | "high" | "critical"
  }

  // 证据输入
  input: {
    evidence_graph_id: string   // 关联证据图谱
    evidence_nodes: string[]     // 直接引用的节点 ID
    context_hash: string        // 上下文哈希
  }

  // 输出契约
  output: {
    schema: JSONSchema          // 输出 JSON Schema
    required_fields: string[]    // 必需字段列表
    optional_fields: string[]   // 可选字段列表
    max_size_bytes: number      // 最大输出大小
  }

  // 验证门禁
  validation: {
    gates: ValidationGate[]     // 见 Validation-Gate-Spec
    pass_threshold: number       // 通过阈值 (0-1)
    must_pass_gates: string[]   // 必须通过的 gate ID
  }

  // 租约
  lease: Lease                  // 见 ADR-003

  // 交接
  handoff?: {
    required: boolean
    next_agent_id?: string
    next_contract_id?: string
    fail_on_handoff_error: boolean
  }
}

enum TaskType {
  QUERY = "query",              // 简单查询
  ANALYSIS = "analysis",        // 数据分析
  REASONING = "reasoning",      // 推理任务
  EXECUTION = "execution",      // 执行任务
  RESEARCH = "research"        // 研究任务
}
```

## 2. 生命周期

```
┌──────────┐     create()     ┌──────────┐
│  DRAFT   │ ───────────────▶│ VALIDATED│
└──────────┘                 └────┬─────┘
                                  │ execute()
                                  ▼
                           ┌──────────┐
                           │ EXECUTING│
                           └────┬─────┘
                    ┌──────────┼──────────┐
                    ▼          ▼          ▼
              ┌──────────┐ ┌──────────┐ ┌──────────┐
              │COMPLETED │ │ PARTIAL  │ │  FAILED  │
              └──────────┘ └──────────┘ └────┬─────┘
                                            │ retry()
                                            ▼
                                       ┌──────────┐
                                       │ PENDING  │
                                       └──────────┘
```

## 3. 创建规则

1. **必需字段**：contract_id, task, input, output, validation, lease
2. **可选字段**：handoff
3. **ID 格式**：contract_id 必须为 UUID v4
4. **版本控制**：每次修改生成新版本，旧版本归档

## 4. 验收检查清单

- [ ] contract_id 格式正确
- [ ] task.description 非空
- [ ] input.evidence_graph_id 存在
- [ ] output.schema 符合 JSON Schema 规范
- [ ] validation.gates 非空
- [ ] lease.timeout_ms > 0
- [ ] handoff 配置一致（如果指定了 required）

## 5. 关联

- [[AGP-0.1-Protocol-RFC]]
- [[ADR/ADR-001-Agent-Identity]]
- [[ADR/ADR-002-Evidence-Graph]]
- [[ADR/ADR-003-Lease-Model]]
- [[SPEC/Validation-Gate-Spec]]
- [[SPEC/Handoff-Protocol-Spec]]
