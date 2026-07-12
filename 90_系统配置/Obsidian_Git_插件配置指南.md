# 🔧 Obsidian Git 插件配置指南

> 创建日期：2026年7月4日  
> **状态（2026-07-12）**：本机主副本已安装并启用 `obsidian-git`；半自动备份已开——**每 10 分钟 auto-commit，每 30 分钟 auto-push**；开机 auto-pull。  
> 目的：知识库自动备份到 GitHub（`ai-finance-knowledge`）

---

## 📑 目录

- [一、为什么需要这个插件](#一为什么需要这个插件)
- [二、安装步骤](#二安装步骤)
- [三、配置详解](#三配置详解)
- [四、推荐配置方案](#四推荐配置方案)
- [五、常见问题](#五常见问题)
- [六、故障排查](#六故障排查)

---

## 一、为什么需要这个插件

### 价值

| 功能 | 价值 |
|------|------|
| **自动备份** | 每次保存自动提交到GitHub |
| **版本控制** | 每次更改都有记录 |
| **跨设备同步** | 多台电脑无缝切换 |
| **防丢失** | 本地损坏不影响数据 |
| **可视化历史** | Obsidian中查看diff |

### 与手动 git 的对比

| 维度 | 手动 git | Obsidian Git插件 |
|------|---------|----------------|
| 易用性 | 需命令行 | 图形界面 |
| 自动化 | 需每次手动 | 自动定时 |
| 集成度 | 独立 | 与Obsidian无缝集成 |
| 学习成本 | 高 | 低 |

---

## 二、安装步骤

### 第1步：打开Obsidian设置

1. 打开Obsidian
2. 点击左下角 ⚙️ 设置按钮
3. 选择 **第三方插件** → **社区插件市场**

### 第2步：搜索并安装

1. 在搜索框输入 **"Obsidian Git"**
2. 找到插件（作者：denolehov）
3. 点击 **安装**
4. 安装完成后点击 **启用**

### 第3步：首次配置

启用后会自动跳转到插件设置页。

---

## 三、配置详解

### 必填配置

#### 1. Git 仓库路径

```
设置项：Vault path
默认值：自动检测
建议：保持默认
```

#### 2. Git 用户信息

```
设置项：Author name / Author email
默认值：从全局git config读取
建议：保持默认（如果之前设置过）
```

#### 3. 自动备份设置

| 设置项 | 推荐值 | 说明 |
|--------|--------|------|
| **Auto backup interval (minutes)** | 30 | 每30分钟自动备份 |
| **Auto backup after file change** | ✅ 开启 | 文件变化时立即备份 |
| **Auto push on backup** | ✅ 开启 | 备份后自动推送 |
| **Pull updates on startup** | ✅ 开启 | 启动时自动拉取 |

### 可选配置

#### 4. 提交消息模板

```
设置项：Commit message
推荐值：{{date}} - {{hostname}}
说明：自动填充日期和主机名
```

#### 5. 排除文件

```
设置项：Ignored files
默认值：已包含 .obsidian/workspace 等
建议：保持默认
```

#### 6. 同步设置

```
设置项：Sync method
推荐值：commit + push + pull
```

---

## 四、推荐配置方案

### 方案A：完全自动（推荐新手）

```yaml
Auto backup interval: 30
Auto backup after file change: ✅
Auto push on backup: ✅
Pull updates on startup: ✅
Commit message: {{date}} - 自动备份
```

**优点**：
- 完全无感
- 每次保存都自动备份
- 启动时自动同步

**缺点**：
- 提交次数多（每天几十次）
- 仓库历史较乱

### 方案B：定时备份（推荐进阶）

```yaml
Auto backup interval: 60
Auto backup after file change: ❌
Auto push on backup: ✅
Pull updates on startup: ✅
Commit message: {{date}} - 定时备份
```

**优点**：
- 提交次数适中（每天10-20次）
- 历史较清晰

**缺点**：
- 文件变化后不会立即备份
- 可能丢失最近改动

### 方案C：手动备份（最控制）

```yaml
Auto backup interval: 0  # 禁用自动
Auto backup after file change: ❌
Auto push on backup: ✅
Pull updates on startup: ✅
```

**优点**：
- 完全控制提交时机
- 历史最清晰

**缺点**：
- 需要手动操作

**我的推荐**：**方案A**（新手）或 **方案B**（进阶）

---

## 五、常用操作

### 1. 手动提交

```
快捷键：Ctrl+P → "Obsidian Git: Commit"
或在左侧栏的Git面板点击"提交"按钮
```

### 2. 手动推送

```
快捷键：Ctrl+P → "Obsidian Git: Push"
```

### 3. 手动拉取

```
快捷键：Ctrl+P → "Obsidian Git: Pull"
```

### 4. 查看历史

```
右键笔记 → "Obsidian Git: Open File History"
或：Ctrl+P → "Obsidian Git: View File History"
```

### 5. 查看差异

```
快捷键：Ctrl+P → "Obsidian Git: View Diff"
```

---

## 六、常见问题

### Q1: 提交时提示认证失败？

**解决方案**：

1. 确认已登录GitHub：
   ```bash
   gh auth status
   ```

2. 如果未登录：
   ```bash
   gh auth login
   ```

3. 或者配置Git凭证存储：
   ```bash
   git config --global credential.helper store
   ```
   下次推送时输入用户名密码（Personal Access Token）

### Q2: 推送时提示"non-fast-forward"？

**原因**：GitHub上有本地没有的提交

**解决方案**：
1. 在Obsidian中使用"Obsidian Git: Pull"先拉取
2. 然后再推送

或者使用强制推送（不推荐）：
```bash
git push --force-with-lease
```

### Q3: 如何处理冲突？

**步骤**：
1. Obsidian Git会提示冲突
2. 打开冲突笔记查看冲突标记
3. 选择保留本地或远程版本
4. 解决后手动提交

**预防**：
- 多设备编辑前先pull
- 避免同时编辑同一笔记

### Q4: 自动备份太频繁，如何停止？

**解决方案**：
- 设置 → 第三方插件 → Obsidian Git
- 将 `Auto backup interval` 设为 `0`
- 或者禁用插件

### Q5: 如何修改最近一次提交？

**步骤**：
1. Ctrl+P → "Obsidian Git: Amend last commit"

### Q6: 如何忽略某些笔记？

**设置**：在 `.gitignore` 中添加：

```gitignore
# 个人草稿
草稿/
*.draft.md

# 临时笔记
temp/
```

---

## 七、故障排查

### 检查清单

- [ ] Obsidian Git 插件已启用
- [ ] Git 仓库已初始化（git init）
- [ ] 远程仓库已配置（git remote -v）
- [ ] Git 用户信息已配置
- [ ] GitHub 账号已登录
- [ ] 网络连接正常

### 调试命令

在Obsidian中按 Ctrl+P，输入"Obsidian Git: Open Git log"，查看详细日志。

### 常见错误信息

| 错误信息 | 原因 | 解决方案 |
|---------|------|---------|
| `Not a git repository` | 仓库未初始化 | 运行 `git init` |
| `Permission denied` | 权限问题 | 检查文件夹权限 |
| `Authentication failed` | 认证失败 | 重新登录GitHub |
| `Could not resolve host` | 网络问题 | 检查网络连接 |
| `Branch main not found` | 分支问题 | 创建main分支 |

---

## 八、高级配置

### 配置 Personal Access Token

如果需要更安全的认证方式：

1. GitHub → Settings → Developer settings → Personal access tokens
2. Generate new token (classic)
3. 勾选 `repo` 权限
4. 生成token并复制

5. 配置Git使用token：
   ```bash
   git remote set-url origin https://你的token@github.com/d83636126-pixel/ai-finance-knowledge.git
   ```

### 配置SSH（推荐）

1. 生成SSH密钥：
   ```bash
   ssh-keygen -t ed25519 -C "your_email@example.com"
   ```

2. 复制公钥：
   ```bash
   cat ~/.ssh/id_ed25519.pub
   ```

3. GitHub → Settings → SSH and GPG keys → New SSH key
4. 粘贴公钥

5. 修改远程URL：
   ```bash
   git remote set-url origin git@github.com:d83636126-pixel/ai-finance-knowledge.git
   ```

---

## 九、推荐工作流

### 日常工作流

```
1. 打开Obsidian → 自动拉取最新版本
2. 编辑笔记
3. 每30分钟自动备份
4. 关闭Obsidian → 自动提交未推送的内容
```

### 跨设备工作流

```
设备A：
1. 编辑笔记
2. 关闭Obsidian（自动推送）

设备B：
1. 打开Obsidian（自动拉取）
2. 看到设备A的更改
3. 继续编辑
```

### 月度工作流

```
每月初：
1. 创建当月跟踪笔记
2. 套用模板填写
3. 自动备份到GitHub
```

---

## 十、附录

### 关联笔记

- [[README]] - 主索引
- [[00_知识图谱索引]] - 图谱索引
- [[01_方法论/操作手册_日常实战整合版_2026-07-04]] - 操作手册
- [[01_方法论/月度跟踪_非农分析模板]] - 月度跟踪模板

### 插件信息

| 项目 | 内容 |
|------|------|
| 插件名 | Obsidian Git |
| 作者 | denolehov |
| 仓库 | https://github.com/denolehov/obsidian-git |
| 当前版本 | 2.x |
| 兼容性 | Obsidian 1.0+ |

---

*配置指南版本：v1.0 · 创建日期：2026-07-04*
*下次更新：插件重大升级时*