---
type: 系统整改方案
status: implemented
tags: [Obsidian, 状态色标, 系统配置, 整改方案]
created: 2026-07-13
updated: 2026-07-13
---

# 状态色标整改方案 D

> [!success] 实施状态
> 方案 D 已落地：`folder_status.yml` / `file_status.yml` 升级为 `workflow` + `attention`；
> `sync_folder_status_colors.ps1` 支持 `-Check` / `-Preview` / `-Sync` / `-Dashboard`；
> 自动生成 [[00_状态总览]]。颜色由结构化状态计算。

## 一、整改目标

让每个状态都能回答：

1. 当前处于什么阶段？
2. 是否需要关注？
3. 为什么处于这个状态？
4. 下一步做什么？
5. 什么时候需要再次检查？

整改时保留现有颜色、CSS 和索引文件，避免大规模改名以及 Obsidian 双链损坏。

---

## 二、核心结构调整

### 2.1 工作阶段 `workflow`

| 值 | 含义 |
|---|---|
| `backlog` | 尚未排期 |
| `scheduled` | 已排期 |
| `active` | 正在推进 |
| `waiting` | 等待数据、事件或外部条件 |
| `paused` | 主动暂停 |
| `done` | 已完成，仍保留使用 |
| `archived` | 已归档，不再维护 |

### 2.2 注意程度 `attention`

| 值 | 含义 |
|---|---|
| `normal` | 无异常 |
| `watch` | 需要关注或近期复核 |
| `blocked` | 存在明确阻塞 |
| `overdue` | 已超过复核期限 |

两个维度可以组合。例如：

```yaml
workflow: active
attention: blocked
```

表示“项目仍在推进，但当前存在阻塞”，避免只能在蓝色和红色之间二选一。

---

## 三、颜色计算规则

侧栏继续只显示一种主颜色，避免视觉过载。

| 优先级 | 判断条件 | 显示 |
|---:|---|---|
| 1 | `attention: blocked` | 🔴 红 |
| 2 | 已超过 `review_by` | 🔴 红 |
| 3 | `attention: watch` | 🟠 橙 |
| 4 | `workflow: scheduled` 或 `waiting` | 🟠 橙 |
| 5 | `workflow: active` | 🔵 蓝 |
| 6 | `workflow: done` | 🟢 绿 |
| 7 | `workflow: paused` 或 `archived` | ⚪ 灰 |
| 8 | 未填写或配置错误 | ⚪ 灰，并产生警告 |

方案 D 不再要求人工直接决定 `green/blue/orange/red/gray`，颜色由结构化状态计算。

---

## 四、文件夹配置结构

`folder_status.yml` 目标格式：

```yaml
version: 2
updated: 2026-07-13

folders:
  - path: AI项目控制台/financial-alert-system
    workflow: active
    attention: watch
    owner: AI协作
    updated: 2026-07-13
    review_by: 2026-07-20
    next_action: 完成证据层 V2 验收
    reason: 当前证据快照仍以手工数据为主
    inherit: true
```

### 字段规范

| 字段 | 必填规则 | 用途 |
|---|---|---|
| `path` | 必填 | 文件夹路径 |
| `workflow` | 必填 | 当前工作阶段 |
| `attention` | 必填 | 当前注意程度 |
| `updated` | 必填 | 最近确认状态的日期 |
| `review_by` | 活跃项目必填 | 下次复核日期 |
| `next_action` | 活跃项目必填 | 下一项具体行动 |
| `reason` | 橙色、红色必填 | 关注或阻塞原因 |
| `owner` | 项目类必填 | 状态维护责任方 |
| `inherit` | 可选 | 子文件是否继承文件夹色 |

---

## 五、文件级状态控制

保留 `file_status.yml`，但限制其适用范围。只建议独立标记：

- 项目主文档
- 任务进度
- 会话交接
- 验收报告
- 正在跟踪的分析
- 明确阻塞的关键文件

普通资料、稳定决策记录和参考文件默认继承文件夹状态，避免逐文件维护。

示例：

```yaml
files:
  - path: AI项目控制台/financial-alert-system/验收报告.md
    workflow: waiting
    attention: watch
    review_by: 2026-07-20
    next_action: 补充实时数据验证
    reason: 当前为有条件通过
```

---

## 六、自动状态总览

同步时自动生成根目录文件：

```text
00_状态总览.md
```

总览包含四个区域。

### 6.1 需要立即处理

- 🔴 明确阻塞
- 🔴 已超过复核日期
- 🔴 配置路径不存在
- 🔴 活跃但没有下一步行动

### 6.2 近期关注

- 🟠 未来七天需要复核
- 🟠 等待外部数据或事件
- 🟠 有条件通过的项目

### 6.3 当前进行中

- 🔵 活跃项目
- 负责人
- 下一步行动
- 复核日期

### 6.4 稳态与归档

绿色和灰色内容折叠展示，避免占据主要工作视野。

总览表示例：

| 状态 | 项目 | 下一步 | 复核日期 | 原因 |
|---|---|---|---|---|
| 🔴 | financial-alert-system | 补齐实时证据 | 2026-07-20 | 证据层仍为手工快照 |
| 🟠 | NFP月度跟踪 | 等待下次就业报告 | 2026-08-07 | 事件窗口未到 |
| 🔵 | AI协作记忆系统 | 完成剩余章节 | 2026-07-18 | 正常推进 |

---

## 七、同步脚本整改

建议为 `sync_folder_status_colors.ps1` 增加四种运行方式：

```powershell
# 只检查，不修改
sync_folder_status_colors.ps1 -Check

# 预览将发生的变化
sync_folder_status_colors.ps1 -Preview

# 正式同步
sync_folder_status_colors.ps1 -Sync

# 同步并重建状态总览
sync_folder_status_colors.ps1 -Sync -Dashboard
```

### 7.1 自动检查项目

- 配置路径是否真实存在
- `workflow` 和 `attention` 是否合法
- 活跃项目是否缺少 `next_action`
- 橙色、红色项目是否缺少 `reason`
- `review_by` 是否已经过期
- 是否存在重复路径
- 文件级覆盖是否过多
- 索引文件名与计算颜色是否一致
- YAML、CSS、状态总览是否同步

### 7.2 安全要求

- 默认执行 `-Check`，不直接修改文件。
- 修改前生成变更清单。
- 索引重命名发生冲突时立即停止。
- 不再自动修改普通文件名。
- 同步结束后分别输出错误、警告和变更。

---

## 八、说明文档整改

### `00_状态色标说明.md`

改为面向使用者的简明说明，只保留：

- 颜色含义
- 状态查看方法
- 状态冲突时的优先级
- 状态修改方法
- 状态总览入口

其中“当前文件夹状态”不再人工维护，改由脚本生成，避免形成第二份状态源。

### `90_系统配置/文件夹状态.md`

改为维护手册，包含：

- 完整字段说明
- 状态转换规则
- 命令说明
- 故障处理
- 配置示例

现有文档中的错误示例路径 `D:\AI  金融知识点` 应统一改为真实知识库路径 `F:\AI 金融知识点`。

---

## 九、状态转换规范

主流程：

```text
backlog → scheduled → active → done
                     ↓
                  waiting
                     ↓
                   active
```

补充规则：

- 任意工作阶段均可进入 `paused`。
- `paused` 恢复后回到原工作阶段。
- `done` 长期不再维护后转为 `archived`。
- `blocked` 只改变注意程度，不自动改变工作阶段。
- 超过 `review_by` 后，显示状态自动转为 `overdue`。
- 人工确认状态后必须同步更新 `updated`。

---

## 十、实施顺序

### 第一阶段：修复现有问题

- [x] 修正文档中的错误路径
- [x] 去除说明页内人工维护的当前状态表
- [x] 增加路径、重复项和无效状态检查
- [x] 增加 `-Check` 和 `-Preview` 模式

### 第二阶段：升级数据结构

- [x] 引入 `workflow` 和 `attention`
- [x] 加入 `updated`、`review_by`、`next_action` 和 `reason`
- [x] 兼容现有五色配置并完成一次性迁移

### 第三阶段：建立状态总览

- [x] 自动生成 `00_状态总览.md`
- [x] 自动识别过期、阻塞和近期复核项目
- [x] 按处理优先级排序

### 第四阶段：降低维护成本

- [x] 限制文件级覆盖范围（手册约定 + 超量警告）
- [x] 增加状态继承控制（`inherit`）
- [ ] 评估 Obsidian 命令入口或一键同步（未做；可后续加）

---

## 十一、验收标准

- [x] 所有配置路径真实存在
- [x] 不再人工维护重复的状态表
- [x] 颜色可以从结构化状态稳定计算
- [x] “进行中但阻塞”能够被正确表达
- [x] 过期项目自动显示为红色
- [x] 活跃项目具备下一步行动和复核日期
- [x] 一页即可看到所有需要处理的项目
- [x] 普通文件不因状态变化而改名
- [x] 原有 Obsidian 双链不受影响（仅索引改名并修补链接）
- [x] 连续执行两次同步，第二次显示零变更

---

## 十二、迁移原则

采用兼容迁移：新版脚本先同时支持旧字段 `status: blue` 和新字段 `workflow`、`attention`。确认状态总览、颜色计算和索引文件均无异常后，再移除旧格式。

这样可以最大限度降低现有知识库的整改风险。

## 相关文件

- [[00_状态色标说明]]
- [[00_状态总览]]
- [[文件夹状态]]
- [[folder_status.yml]]
- [[file_status.yml]]
