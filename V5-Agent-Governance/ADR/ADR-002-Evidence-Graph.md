# ADR-002: Evidence Graph

> [!info] 架构决策记录
> - **编号**：ADR-002
> - **标题**：证据图谱规范
> - **状态**：草稿
> - **决策日期**：2026-08-07
> - **影响范围**：推理链路、结论验证

---

## 背景

AI Agent 的结论必须可审计、可回溯。证据图谱是实现这一目标的核心数据结构。

## 决策

### 图结构

```
EvidenceGraph {
  nodes: Node[]
  edges: Edge[]
  metadata: GraphMetadata
}

Node {
  id: string                    // 唯一标识
  type: Input | Assumption | Inference | Conclusion
  content: string               // 原始内容
  metadata: {
    timestamp: ISO8601
    role: "system" | "user" | "agent" | "tool"
    confidence?: number         // 0-1
    verified?: boolean
  }
}

Edge {
  id: string
  source: string                // 源节点 ID
  target: string                // 目标节点 ID
  type: "causal" | "dependency" | "verification"
  weight?: number               // 0-1
}
```

### 操作规范

1. **创建节点**：每条输入、假设、推理步骤必须创建对应节点
2. **记录边**：所有逻辑关系必须用边表达
3. **保持完整性**：图谱不可逆，只能新增快照版本

### 验证规则

| 规则 | 描述 |
|------|------|
| 输入覆盖 | 所有结论必须可从图谱追溯到输入节点 |
| 无环检测 | 因果边不得形成环 |
| 时间顺序 | 边必须从早到晚 |

## 关联

- 父 RFC：[[V5-Agent-Governance-Protocol-RFC]]
- 相关 ADR：[[ADR-001-Agent-Identity]], [[ADR-003-Lease-Model]]
- 规格文档：[[Validation-Gate-Spec]]
