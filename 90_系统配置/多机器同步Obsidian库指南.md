---
type: 操作指南
tags: [Obsidian, Git, GitHub, 多机器同步]
created: 2026-07-05
updated: 2026-07-05
---

# 多机器同步 Obsidian 库指南

## 核心逻辑

```text
GitHub 仓库 = 云端中转
本机 Obsidian vault = 本地副本
```

当前 Obsidian 知识库仓库：

```text
https://github.com/d83636126-pixel/ai-finance-knowledge
```

## 另一台电脑第一次同步

### 1. 安装 Git

下载安装 Git：

```text
https://git-scm.com/downloads
```

### 2. 选择本机目录

例如：

```text
D:\Obsidian
```

### 3. 克隆 GitHub 仓库

在目标目录中执行：

```powershell
git clone https://github.com/d83636126-pixel/ai-finance-knowledge.git
```

克隆后会得到：

```text
D:\Obsidian\ai-finance-knowledge
```

### 4. 用 Obsidian 打开

打开 Obsidian，选择：

```text
Open folder as vault
```

然后选择：

```text
D:\Obsidian\ai-finance-knowledge
```

这样另一台机器就能看到同一套 Obsidian 内容。

## 日常同步规则

开始写之前，先拉取最新内容：

```powershell
git pull
```

写完之后，提交并推送：

```powershell
git add -A
git commit -m "update obsidian notes"
git push
```

最简单的记忆方式：

```text
开始前 pull
结束后 add / commit / push
```

## 推荐方式

另一台机器也可以安装 Obsidian Git 插件。

这样可以在 Obsidian 里点按钮同步，不需要每次手动输入 Git 命令。

## 注意事项

不要在两台机器同时修改同一个文件后都推送。

最稳的习惯是：

```text
打开 Obsidian 前先 git pull
写完后及时 git push
```

如果两台机器都修改了同一个文件，可能会出现 Git 冲突，需要手动合并。

---

## 异地登录（状态不滞后）

换电脑 / 异地登录时，仅 `git pull` 笔记不够：还要把**本机代码探针结果**写回 Obsidian。

完整步骤见：

- [[90_系统配置/异地登录自动同步落地_2026-07-11]]
- [[AI项目控制台/financial-alert-system/_sync/README]]

新机器一键：

```powershell
powershell -File ".\90_系统配置\bootstrap_remote_machine.ps1"
```

