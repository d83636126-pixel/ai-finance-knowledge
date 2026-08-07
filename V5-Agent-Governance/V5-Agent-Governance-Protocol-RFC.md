# V5 Agent Governance Protocol RFC

> [!abstract] 摘要
> V5 是一套面向 AI Agent 工程治理的规范框架，涵盖身份认证、证据图谱、任务契约、验证门禁和交接协议。

## 一、目标与动机

当前 Agent 系统面临的核心挑战：

1. **执行指针错位**：Agent 声称的操作与实际状态不一致
2. **证据断裂**：结论无法回溯到原始输入和推理路径
3. **交接失控**：多 Agent 协作时上下文丢失或重复执行
4. **验证缺失**：缺乏可信的验收门禁

## 二、核心概念

### 2.1 Agent 身份 (Agent Identity)

每个 Agent 必须具备：
- 唯一标识符 (UUID)
- 版本快照 (Snapshot Hash)
- 能力边界声明 (Capability Manifest)
- 信任等级 (Trust Level)

### 2.2 证据图谱 (Evidence Graph)

```
输入 → 推理 → 输出
  ↓       ↓       ↓
元数据  路径     验证状态
```

- **节点**：输入、假设、推理步骤、结论
- **边**：因果关系、依赖关系、验证关系
- **属性**：时间戳、角色、置信度、可信度

### 2.3 租约模型 (Lease Model)

- **Hard Lease**：不可撤销，必须完成
- **Soft Lease**：可超时释放，需重新协商
- **Lease Timeout**：明确的最大执行时间

### 2.4 任务契约 (Task Contract)

```
{
  "task_id": "唯一标识",
  "description": "任务描述",
  "input_evidence": ["证据节点列表"],
  "output_contract": "输出规格",
  "validation_gates": ["验证门禁列表"],
  "lease": {
    "type": "hard|soft",
    "timeout_ms": 300000
  },
  "handoff": {
    "required": false,
    "next_agent": null
  }
}
```

## 三、目录结构

```
V5-Agent-Governance/
├── V5-Agent-Governance-Protocol-RFC.md    # 本文件
├── ADR/                                      # 架构决策记录
│   ├── ADR-001-Agent-Identity.md
│   ├── ADR-002-Evidence-Graph.md
│   └── ADR-003-Lease-Model.md
├── SPEC/                                     # 详细规格
│   ├── Task-Contract-Spec.md
│   ├── Validation-Gate-Spec.md
│   └── Handoff-Protocol-Spec.md
└── CASES/                                    # 案例库
    ├── Case-001-Execution-Pointer-Mismatch.md
    └── Case-002-未来案例.md
```

## 四、验证门禁

### 4.1 静态门禁

- [ ] 身份签名有效
- [ ] 输入证据完整
- [ ] 无已知冲突

### 4.2 动态门禁

- [ ] 执行指针一致
- [ ] 租约未超时
- [ ] 交接成功

### 4.3 验收门禁

- [ ] 所有 SPEC 满足
- [ ] 案例测试通过
- [ ] 回归测试通过

## 五、关联

- [[ADR-001-Agent-Identity|Agent 身份规范]]
- [[ADR-002-Evidence-Graph|证据图谱规范]]
- [[ADR-003-Lease-Model|租约模型规范]]
- [[Task-Contract-Spec|任务契约规格]]
- [[Validation-Gate-Spec|验证门禁规格]]
- [[Handoff-Protocol-Spec|交接协议规格]]

## 六、状态

- [x] RFC 创建
- [ ] ADR-001 完成
- [ ] ADR-002 完成
- [ ] ADR-003 完成
- [ ] SPEC 套件完成
- [ ] 案例库建设

---

*创建时间：2026-08-07*
*最后更新：2026-08-07*
*状态：草稿*
