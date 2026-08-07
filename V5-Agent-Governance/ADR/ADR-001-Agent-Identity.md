# ADR-001: Agent Identity

> [!info] 架构决策记录
> - **编号**：ADR-001
> - **标题**：Agent 身份规范
> - **状态**：草稿
> - **决策日期**：2026-08-07
> - **影响范围**：所有 V5 Agent

---

## 背景

在多 Agent 系统中，每个 Agent 需要被唯一标识和验证。没有统一的身份规范将导致：
- 执行来源不明
- 责任归属模糊
- 信任等级无法传递

## 决策

每个 V5 Agent 必须实现以下身份规范：

### 1. 唯一标识符 (UUID)

```json
{
  "agent_id": "550e8400-e29b-41d4-a716-446655440000",
  "version": "1.0.0",
  "instance_id": "host-001-session-123"
}
```

### 2. 版本快照 (Snapshot Hash)

```json
{
  "snapshot_hash": "sha256:abc123...",
  "capability_hash": "sha256:def456...",
  "timestamp": "2026-08-07T10:00:00Z"
}
```

### 3. 能力边界 (Capability Manifest)

```json
{
  "capabilities": {
    "reasoning": ["deductive", "inductive"],
    "tools": ["read", "write", "search"],
    "limits": {
      "max_tokens": 100000,
      "max_execution_time_ms": 300000
    }
  },
  "trust_level": "verified"  // unverified | sandboxed | verified | trusted
}
```

### 4. 身份签名

```
Identity = Base64(HMAC-SHA256(agent_id + version + snapshot_hash, secret_key))
```

## 验证规则

1. **入网验证**：新 Agent 加入时必须通过身份注册
2. **心跳验证**：每 N 分钟验证一次身份一致性
3. **版本检查**：升级前验证兼容性

## 关联

- 父 RFC：[[V5-Agent-Governance-Protocol-RFC]]
- 相关 ADR：[[ADR-002-Evidence-Graph]], [[ADR-003-Lease-Model]]
