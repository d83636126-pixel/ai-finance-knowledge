# 版本命名规范 / Version Naming Convention

> **生效日期**：2026-08-07  
> **状态**：正式规范  
> **适用范围**：所有 Obsidian Vault 中的文档命名

---

## 一、核心原则

1. **协议命名空间禁止 V 前缀**：Agent Governance Protocol 独立为 `AGP-0.1` 命名空间，与产品 `V4.3`/`V5.0` 隔离
2. **不同命名空间严格隔离**：Product / Protocol / Document / Revision 各自独立
3. **文件名即身份**：文件名改变时，同步更新所有引用它的链接
4. **日期辅助定位**：历史版本文件名附加日期后缀 `_YYYY-MM-DD`
5. **Obsidian 链接优先**：优先使用 `[[双向链接]]`，链接文本与文件名一致

---

## 二、四套命名空间

### 命名空间 A：Product Version（产品版本）

> 适用于：`financial-alert-system` 等**产品**的正式发布版本

```
<产品名>-<版本号>.md
示例：financial-alert-system_V4.4.md
      financial-alert-system_V5.0.md
```

- 主版本号表示重大架构变更
- 次版本号表示功能迭代
- 补丁版本号表示热修复

**允许并推荐使用 `V` 前缀**：`V4.4`、`V5.0` 是产品的正式版本标识，与协议命名空间 `AGP-0.1` 已完全隔离，不会产生命名冲突。

---

### 命名空间 B：Protocol Version（协议版本）

> 适用于：**跨系统治理规范**，如 Agent 治理协议

**协议命名空间禁止 V 前缀**，以明确区分于产品版本。

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

**两层结构**：

**① Canonical Live Document（权威当前文档）**
- 文件名保持稳定，不含 `_revN` 后缀
- 当前权威文档：`需求拆分.md`
- 内部 frontmatter 记录修订号：`revision: 3`
- 供 Obsidian 双向链接和 Agent 定位使用

**② Archive Snapshot（归档快照）**
- 需要保存历史快照时，复制为归档文件
- 格式：`<文档名>_rev<修订号>_<日期>.md`
- 示例：`需求拆分_rev2_2026-08-08.md`

这样保持 Obsidian 稳定链接的同时，Git 历史和审计需求通过归档文件满足。

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
| `V5-Agent-Governance/` | 协议命名空间混用 V 前缀 | `AGP-0.1-Agent-Governance/` |
| `V5-Agent-Governance-Protocol-RFC.md` | 协议命名空间使用 V 前缀 | `AGP-0.1-Protocol-RFC.md` |
| `version: V1.1`（frontmatter） | frontmatter 使用 V 前缀 | `version: "1.1"` |
| `index_v2_final.md` | 多重后缀 | `index_v2.md`（日期单独存储） |

> **注意**：产品版本（如 `V4.4`、`V5.0`）使用 `V` 前缀是**允许且推荐**的，这与协议命名空间 `AGP-0.1` 已完全隔离。

---

## 四、Obsidian 双向链接规范

1. **链接文本必须与文件名一致**，改名后同步更新所有 `[[链接]]`
2. **外部引用格式**：`[[文件夹/文件名]]`（相对路径）
3. **跨 Vault 链接**：使用完整路径或 Obsidian URI
4. **重命名操作必须同时更新**：
   - 文件系统层面的文件名
   - 所有引用该文件的 `[[双向链接]]`
   - 所有引用该文件的 URL
   - Canonical 文档的 `revision` frontmatter（如有变更）

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
| 2026-08-08 | 修正命名规范：恢复产品版本 V 前缀，区分 Canonical / Archive 两层文档修订结构 | VERSION-NAMING-CONVENTION.md |

---

*本文档由 AI 辅助生成，请人工复核后生效。*
