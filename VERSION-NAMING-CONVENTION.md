# 版本命名规范 / Version Naming Convention

> **生效日期**：2026-08-07  
> **状态**：正式规范  
> **适用范围**：所有 Obsidian Vault 中的文档命名

---

## 一、核心原则

1. **版本号不带前缀字母**：`V5.0` → `5.0`，`V4.3` → `4.3`
2. **不同命名空间严格隔离**：Product / Protocol / Document / Revision 各自独立
3. **文件名即身份**：文件名改变时，同步更新所有引用它的链接
4. **日期辅助定位**：历史版本文件名附加日期后缀 `_YYYY-MM-DD`
5. **Obsidian 链接优先**：优先使用 `[[双向链接]]`，链接文本与文件名一致

---

## 二、四套命名空间

### 命名空间 A：Product Version（产品版本）

> 适用于：`financial-alert-system` 等**产品**的正式发布版本

```
<产品名>_<版本号>_<日期>.md
示例：financial-alert-system_4.4_2026-08-01.md
      financial-alert-system_5.0_2026-09-01.md
```

- 主版本号表示重大架构变更
- 次版本号表示功能迭代
- 补丁版本号表示热修复

---

### 命名空间 B：Protocol Version（协议版本）

> 适用于：**跨系统治理规范**，如 Agent 治理协议

```
<协议缩写>-<主版本>.<次版本>/<子文档>
示例：AGP-0.1/AGP-0.1-Protocol-RFC.md
      AGP-0.1/ADR/ADR-001-Agent-Identity.md
      AGP-0.1/SPEC/SPEC-Task-Contract.md
```

**当前协议版本对照：**

| 协议名 | 旧名（已废弃） | 新名 |
|--------|--------------|------|
| Agent Governance Protocol | `V5-Agent-Governance-Protocol` | `AGP-0.1-Protocol` |
| ADR-001 Agent Identity | `V5/ADR/ADR-001-Agent-Identity` | `AGP-0.1/ADR/ADR-001-Agent-Identity` |
| ADR-002 Evidence Graph | `V5/ADR/ADR-002-Evidence-Graph` | `AGP-0.1/ADR/ADR-002-Evidence-Graph` |
| ADR-003 Lease Model | `V5/ADR/ADR-003-Lease-Model` | `AGP-0.1/ADR/ADR-003-Lease-Model` |

---

### 命名空间 C：Document Revision（文档版本）

> 适用于：单个文档的内部修订历史

```
<文档名>_rev<修订号>_<日期>.md
示例：需求拆分_rev1_2026-07-10.md
      需求拆分_rev2_2026-07-15.md
```

- 同一文档每次重大修订递增修订号
- 旧版本归档，不删除

---

### 命名空间 D：Board / Loop Revision（状态板版本）

> 适用于：Agent 交接板状态、循环执行记录

```
<板名>-<日期>-<序号>.md
示例：PRD-EVENT-INTELLIGENCE-13.md
      PRD-EVENT-INTELLIGENCE-13-R2.md  （第二轮）
```

- 序号区分同一任务的多个执行轮次
- 状态板 `.md` 文件不附加日期（在文件名内已包含）

---

## 三、禁止使用的命名模式

| ❌ 错误模式 | 原因 | ✅ 正确做法 |
|-----------|------|-----------|
| `V5-Agent-Governance/` | V 前缀混用 | `AGP-0.1-Agent-Governance/` |
| `V5-Agent-Governance-Protocol-RFC.md` | V 前缀在文件名 | `AGP-0.1-Protocol-RFC.md` |
| `产品发展执行计划_V2_...` | V 前缀在正文版本引用 | `产品发展执行计划_2_...` 或直接写 `V2` 表示语义版本（允许） |
| `version: V1.1` | V 前缀在 frontmatter | `version: "1.1"` |
| `index_v2_final.md` | 多重后缀 | `index_v2.md`（日期单独存储） |

---

## 四、Obsidian 双向链接规范

1. **链接文本必须与文件名一致**，改名后同步更新所有 `[[链接]]`
2. **外部引用格式**：`[[文件夹/文件名]]`（相对路径）
3. **跨 Vault 链接**：使用完整路径或 Obsidian URI
4. **重命名操作必须同时更新**：
   - 文件系统层面的文件名
   - 所有引用该文件的 `[[双向链接]]`
   - 所有引用该文件的 URL

---

## 五、命名冲突处理

当同一命名空间内出现版本号冲突时：

1. **同版本多稿** → 加日期后缀
   ```
   需求拆分_2_2026-07-10.md
   需求拆分_2_2026-07-15.md
   ```

2. **跨命名空间同名** → 保留各自命名空间前缀
   - `AGP-0.1/ADR/ADR-001-Agent-Identity.md`（协议命名空间）
   - `financial-alert-system/ADR-001-xxx.md`（产品命名空间）

---

## 六、迁移记录

| 日期 | 操作 | 影响文件 |
|------|------|---------|
| 2026-08-07 | `V5-Agent-Governance/` → `AGP-0.1-Agent-Governance/` | 9 个文件 |

---

*本文档由 AI 辅助生成，请人工复核后生效。*
