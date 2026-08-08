# Validation Gate Specification

> [!abstract] 规格说明
> 定义 AGP-0.1 Agent 系统的验证门禁机制和实现规范。

---

## 1. 门禁类型

```typescript
enum GateType {
  // 静态验证
  IDENTITY = "identity",          // 身份验证
  SIGNATURE = "signature",        // 签名验证
  SCHEMA = "schema",              // Schema 验证

  // 动态验证
  EXECUTION = "execution",        // 执行状态
  TIMEOUT = "timeout",            // 超时检查
  POINTER = "pointer",            // 执行指针一致性

  // 语义验证
  EVIDENCE = "evidence",          // 证据完整性
  CONSISTENCY = "consistency",     // 逻辑一致性
  CONFLICT = "conflict",          // 冲突检测

  // 业务验证
  OUTPUT = "output",              // 输出合规
  THRESHOLD = "threshold",        // 阈值检查
  POLICY = "policy"               // 策略合规
}

interface ValidationGate {
  gate_id: string
  type: GateType
  config: GateConfig             // 类型特定配置
  severity: "error" | "warning"  // 失败时行为
}

interface GateResult {
  gate_id: string
  passed: boolean
  score: number                 // 0-1
  details: string
  evidence?: string[]            // 相关证据节点
  timestamp: ISO8601
}
```

## 2. 门禁配置

### 2.1 身份门禁 (Identity Gate)

```json
{
  "gate_id": "gate-identity-001",
  "type": "identity",
  "config": {
    "verify_signature": true,
    "check_trust_level": "verified",
    "allowed_versions": ["1.0.0", "1.1.0"]
  },
  "severity": "error"
}
```

### 2.2 证据门禁 (Evidence Gate)

```json
{
  "gate_id": "gate-evidence-001",
  "type": "evidence",
  "config": {
    "require_input_coverage": true,
    "max_assumption_depth": 3,
    "allow_unverified_assumptions": false,
    "conflict_detection": true
  },
  "severity": "error"
}
```

### 2.3 执行指针门禁 (Pointer Gate)

```json
{
  "gate_id": "gate-pointer-001",
  "type": "pointer",
  "config": {
    "verify_state_consistency": true,
    "check_claimed_vs_actual": true,
    "tolerance_ms": 100
  },
  "severity": "error"
}
```

### 2.4 阈值门禁 (Threshold Gate)

```json
{
  "gate_id": "gate-threshold-001",
  "type": "threshold",
  "config": {
    "metric": "confidence",
    "operator": ">=",
    "value": 0.8,
    "per_output_field": {
      "conclusion": { "metric": "confidence", "operator": ">=", "value": 0.9 },
      "reasoning": { "metric": "coherence", "operator": ">=", "value": 0.7 }
    }
  },
  "severity": "warning"
}
```

## 3. 执行流程

```
开始验证
    │
    ▼
┌───────────────────────────────────┐
│  按 severity 分组: error → warning │
└───────────────────────────────────┘
    │
    ▼
┌───────────────────────────────────┐
│  执行 error 门禁 (全部必须通过)    │
└───────────────────────────────────┘
    │
    ├─ 任何失败 ─→ 立即返回 FAIL
    │
    ▼
┌───────────────────────────────────┐
│  执行 warning 门禁 (计算分数)      │
└───────────────────────────────────┘
    │
    ▼
┌───────────────────────────────────┐
│  计算总分 = Σ(score × weight)     │
└───────────────────────────────────┘
    │
    ▼
总分 >= threshold? ─→ PASS : FAIL
```

## 4. 验收规则

| 场景 | 必须通过的门禁 | 可选门禁 |
|------|---------------|---------|
| 入网注册 | identity | policy |
| 任务开始 | identity, schema | - |
| 任务完成 | evidence, output, threshold | pointer, consistency |
| 交接 | identity, evidence | conflict |

## 5. 实现要求

1. **幂等性**：同一输入必须产生相同结果
2. **可观测性**：每次验证必须记录完整日志
3. **原子性**：gate 执行不可中断
4. **可扩展性**：支持自定义门禁类型

## 6. 关联

- [[AGP-0.1-Protocol-RFC]]
- [[ADR/ADR-002-Evidence-Graph]]
- [[SPEC/Task-Contract-Spec]]
- [[SPEC/Handoff-Protocol-Spec]]
