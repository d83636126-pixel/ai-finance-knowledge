---
type: Cursor_Codex闭环交接板
schema_version: 2
tags: [AI协作, Cursor, Codex, Obsidian, 闭环]
created: 2026-07-18
updated: '2026-07-18'
project: financial-alert-system
loop_id: loop-2026-07-18-001
revision: 1
turn: 0
next_actor: human
status: idle
max_turns: 8
last_writer: 'codex'
written_at: '2026-07-18T09:23:11.283Z'
lease_owner: ''
lease_actor: ''
lease_expires_at: ''
code_root: F:\financial-alert-system
vault_note: AI协作记忆系统/Cursor_Codex_闭环交接板.md
repo_mirror: docs/ai-collab/Cursor_Codex_闭环交接板.md
---

# Cursor ↔ Codex 闭环交接板

> [!important] 定位
> 本文件是 Cursor 与 Codex 的**唯一共享回合状态**，Obsidian 为正本；聊天仍是用户控制面。当前用户明确指令始终高于本板，本板高于历史交接与旧计划。
>
> 正本：`F:\AI 金融知识点\AI协作记忆系统\Cursor_Codex_闭环交接板.md`  
> 仓库镜像：`F:\financial-alert-system\docs\ai-collab\Cursor_Codex_闭环交接板.md`  
> 同步与校验：`node scripts/ai_collab_board.js validate|sync|claim|release`

## 0. 闭环协议

```text
Human 设置目标与首条指令
  → pending_exec / next_actor=cursor

Cursor 领取租约并完成一个有边界的小步
  → 写完成报告
  → pending_review / next_actor=codex / turn+1

Codex 领取租约并独立核验
  → 通过：done / next_actor=human
  → 返工：pending_exec / next_actor=cursor
  → 需决策：blocked / next_actor=human
```

### 0.1 权威顺序

1. 当前用户明确指令；
2. 本板当前 `loop_id + revision + status + next_actor`；
3. 项目五件套及历史回合；
4. 聊天中的旧结论。

若用户新指令改变活跃闭环范围，先停止旧任务并将本板设为 `blocked / next_actor=human`，不得机械继续旧指令。

### 0.2 合法状态

| status | next_actor | 含义 |
|---|---|---|
| `idle` | `human` | 没有活跃任务 |
| `pending_exec` | `cursor` | 等 Cursor 执行第3节 |
| `pending_review` | `codex` | 等 Codex 独立评审 |
| `blocked` | `human` | 等用户授权、选择或外部条件 |
| `done` | `human` | 本轮完成，等用户确认或开新轮 |

任何其他组合均为非法状态，工具校验必须失败。

### 0.3 并发租约

- Cursor/Codex 动手前必须先运行 `validate`，再运行 `claim`；
- `lease_owner` 必须是本会话唯一标识，不得固定写成 `cursor` 或 `codex`；
- 未过期租约存在时，其他会话不得执行或写板；
- 完成写回后运行 `release`，由工具清租约、递增 `revision`、同步镜像；
- 租约过期不代表任务成功，只允许新会话重新领取并先复核现场。

### 0.4 安全与记录边界

- 禁止在本板或仓库镜像写入 API Key、`.env` 内容、账号、Cookie；
- 禁止把 FactSet/Bloomberg 原文或 Databento 授权原始数据复制到镜像；只写来源、内部路径、任务ID与哈希；
- 正本与镜像哈希不一致时 fail-closed，禁止继续业务代码；
- 长期目标、决策、进度仍分流到项目五件套，本板只保留当前回合和审计摘要；
- Cursor不得在 `pending_review` 时继续改代码；Codex不得假装Cursor执行，除非当前用户明确授权改变角色。

## 1. 任务目标（Human或Codex设定）

| 字段 | 内容 |
|---|---|
| 一句话目标 | （待填） |
| 成功标准 | （待填，必须可核验） |
| 明确不做 | （待填） |
| 相关计划/笔记 | （待填wiki链接） |
| 允许改动路径 | （待填精确路径） |
| 代码根路径 | `F:\financial-alert-system` |

## 2. 当前回合仪表盘

| 项 | 值 |
|---|---|
| loop_id | `loop-2026-07-18-001` |
| revision | `0` |
| turn | `0 / 8` |
| status | ⚪ `idle` |
| next_actor | `human` |
| lease_owner | — |
| lease_expires_at | — |
| 阻塞原因 | — |

**给下一位AI的一句话：**当前没有活跃闭环；Human设置第1/3节后，用同步工具切到`pending_exec / cursor`。

> 第2节是给人看的摘要，frontmatter才是机器权威；二者不一致时必须修正并重新校验。

## 3. 下一条Cursor指令

> Cursor只能执行本节列出的范围。每轮更新指令ID，不得复用旧ID。

```text
状态：⚪ 待填写
指令 ID：T00
目标：
前置证据：
允许改动路径：
验收命令/现象：
明确不做：
截止条件：做完即停，不顺手扩展
```

## 4. Cursor完成报告

> Codex评审必须以实际代码和工件为准，报告不是通过证据本身。

```text
状态：⚪ 尚无
指令 ID：T00
完成时间：
git_head_before：
git_head_after：
工作树范围（含既有无关改动）：
实际改动：
- 文件：
- 关键diff摘要：
验证结果：
- 命令：
- exit_code：
- 关键输出：
工件证据：
- path：
- sha256：
未完成/新发现问题：
建议Codex重点核验：
```

## 5. Codex反馈

```text
状态：⚪ 尚无
针对指令 ID：T00
评审结论：通过 / 需返工 / 需用户决策
独立复核基线：
- reviewed_git_head：
- reviewed_worktree_scope：
问题清单（按严重度）：
1.
独立验证：
- 命令/观察：
- exit_code：
- 工件path + sha256：
范围外改动检查：
下一动作归属：cursor / human / done
反馈摘要（≤5行）：
```

## 6. 回合历史（只追加，新回合在最上）

每轮至少保存指令、报告、反馈的关键事实和证据锚点；不得只写“已完成”。

```markdown
### Turn N — YYYY-MM-DD HH:mm — 指令ID
- Cursor：改动文件、git_head_after、验证exit_code、工件sha256
- Codex：结论、最高严重度问题、独立验证
- 状态迁移：pending_exec → pending_review → ...
- 结果：done / pending_exec / blocked
```

（尚无回合）

## 7. 操作清单

### 7.1 Human启动/改向

1. 填第1节和第3节；
2. frontmatter设为`next_actor=cursor`、`status=pending_exec`，同步第2节；
3. 运行：`node scripts/ai_collab_board.js sync --actor human --bump`；
4. 若要中断活跃租约，明确下令后运行`clear-lease --actor human`，并记录原因。

### 7.2 Cursor执行

1. `node scripts/ai_collab_board.js validate`；
2. 若轮到Cursor：`node scripts/ai_collab_board.js claim cursor --owner <唯一会话ID> --minutes 60`；
3. 只执行第3节；
4. 填第4/6节，将状态切到`pending_review / codex`并同步第2节，`turn+=1`；
5. `node scripts/ai_collab_board.js release cursor --owner <同一会话ID>`；
6. 停止，不继续下一步代码。

### 7.3 Codex评审

1. `node scripts/ai_collab_board.js validate`；
2. 若轮到Codex：`node scripts/ai_collab_board.js claim codex --owner <唯一会话ID> --minutes 45`；
3. 对照第1/3节独立核查第4节、代码、Git和工件；
4. 填第5/6节：通过→`done/human`，返工→重写第3节并设`pending_exec/cursor`，需决策→`blocked/human`；
5. `node scripts/ai_collab_board.js release codex --owner <同一会话ID>`。

## 8. 新循环与归档

- `done`或`blocked`后由Human决定是否结束；
- 开新任务前，将旧板归档为`闭环归档/<loop_id>.md`并保留仓库安全镜像；
- 新任务生成新`loop_id`，重置`turn=0`、清空租约、更新任务区；
- 不得在同一`loop_id`中偷换目标。

## 9. 启动口令

**Cursor：**

```text
读取Obsidian正本 Cursor_Codex_闭环交接板.md，先运行校验；只有next_actor=cursor且status=pending_exec时才领取租约并执行第3节。完成后写第4/6节，交给Codex并同步镜像。
```

**Codex：**

```text
读取Obsidian正本 Cursor_Codex_闭环交接板.md，先运行校验；只有next_actor=codex且status=pending_review时才领取租约并独立评审。写第5/6节后完成、返工或交Human决策。
```

## 10. 关联

- [[AI协作记忆系统/00_AI记忆入口]]
- [[AI协作记忆系统/AI记录规范]]
- [[AI协作记忆系统/会话交接日志]]
- [[AI项目控制台/项目_financial-alert-system]]

