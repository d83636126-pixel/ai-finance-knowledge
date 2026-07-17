---
type: 操作手册
tags: [项目, financial-alert-system, 同步, 自动化, Obsidian]
created: 2026-07-11
updated: 2026-07-11
---

# 代码状态 → Obsidian 自动同步

## 要解决的问题

代码侧已经验收 / 冒烟通过，但 Obsidian 笔记仍写着「未验收 / 进行中」——文档滞后于事实。

## 原则

1. **事实源在代码仓**：文件是否存在、Git commit、冒烟产物。
2. **Obsidian 只读回写**：自动区块由脚本覆盖，禁止手改。
3. **验收项登记在 registry**：新增验收维度先改 `acceptance_registry.json`，再跑同步。

## 一键同步

在 Obsidian 库根目录执行：

```bat
AI项目控制台\financial-alert-system\_sync\run_sync.bat
```

## 日开会话（写 .env + 启 local_server）

手册：[[AI项目控制台/financial-alert-system/01_项目治理/02_工程与文档/日开会话_DayOpen_2026-07-17]]

```bat
AI项目控制台\financial-alert-system\_sync\day_open.bat
```

或：

```bat
powershell -File "AI项目控制台\financial-alert-system\_sync\sync_vault_status.ps1"
node "AI项目控制台\financial-alert-system\_sync\sync_vault_status.js"
```

（优先用 `.ps1`：本机若 `node` 不在 PATH 也能跑。）

## 自动写入什么

1. 刷新 `AI项目控制台/financial-alert-system/project_status.json`（由探针生成，覆盖旧镜像）
2. 在登记过的笔记中更新：

```html
<!-- AUTO:STATUS:BEGIN -->
...自动表格...
<!-- AUTO:STATUS:END -->
```

3. 对「单验收项绑定」的方案笔记，改写 frontmatter `status:`（如 `done` / `acceptance_failed`）

## 当前登记项

见 `_sync/acceptance_registry.json`：

- `workbench-p0-p4`：研究工作台交付物是否真实存在
- `engineering-gate`：是否具备 `package.json` + 冒烟脚本
- `core-propagation`：传播图核心页面文件是否齐全

缺证据 → **未验收**；证据齐 → **已验收**。不再相信聊天里的“做过了”。

## 工作流（建议固定）

```text
代码改完 / 冒烟跑完
  → 运行 run_sync.bat
  → Obsidian 刷新
  → 看 AUTO 区块与 project_status.json
  → 需要时再 git commit 文档库
```

Agent / 人工验收结束后，**必须跑一次 sync**，禁止只改 Markdown 勾选。

## 明确不做

- 不从 Obsidian 反向“证明”代码已完成
- 不自动伪造冒烟 PASS 产物
- 不手写节点数 / commit / 验收状态到 AUTO 区块外冒充同步结果
