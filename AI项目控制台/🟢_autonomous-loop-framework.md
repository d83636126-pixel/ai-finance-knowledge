# 自主迭代框架（Autonomous Iteration Framework）

给 `financial-alert-system`（代码项目）和 `Vault Cortex`（知识库项目）共用的一套全自动
"规划 → 执行 → 评估 → 记录 → 熔断检查 → 重复" 循环引擎。

以下每一节对应一个文件，标题即文件路径。落地时按路径拆分成对应文件即可。

---

## `autonomous-loop/README.md`

```markdown
# 自主迭代框架（Autonomous Iteration Framework）

给 `financial-alert-system`（代码项目）和 `Vault Cortex`（知识库项目）共用的一套全自动
"规划 → 执行 → 评估 → 记录 → 熔断检查 → 重复" 循环引擎。

## 目录结构

autonomous-loop/
├── goals/                          # 每个项目的北极星目标 + 自主权边界（红线）
│   ├── financial-alert-system.goal.md
│   └── vault-cortex.goal.md
├── state/                          # 持久化状态，跨会话的"接力棒"
│   ├── financial-alert-system.state.json
│   └── vault-cortex.state.json
├── adapters/                       # 项目类型适配器：怎么干活、怎么打分
│   ├── code-adapter.md
│   └── knowledge-adapter.md
├── runner/
│   └── loop.sh                     # 调度 + 执行 + 熔断的主脚本
└── logs/                           # 每轮迭代的完整存档

## 为什么需要这几层（不是过度设计）

1. **state.json 是必须的**：`claude -p` headless 模式每次调用之间互不记得上一轮做了什么，
   没有这一层，"自动迭代"会退化成"每次从零开始瞎猜"。
2. **goal.md 划红线是必须的**：全自动意味着没人在现场按"批准"，所以哪些操作允许自主决定、
   哪些必须停下来等人工审批，必须在跑之前写死，不能指望模型临场判断。
3. **adapter 把"代码项目"和"知识库项目"的差异隔离开**：核心循环（loop.sh）完全不用管
   项目是写代码还是写 Obsidian 笔记，差异全部封装在 adapter 的 prompt 模板和评估 checklist 里。
4. **熔断是必须的**：全自动系统最大的风险不是"做错一次"，而是"错误重复放大"。
   `consecutive_failures` 达到阈值就应该自动停下来等你看一眼，而不是无限重试。

## 使用方式

```bash
# 部署到本地后，放入 crontab（例如每天跑一次 financial-alert-system）
0 3 * * * /path/to/autonomous-loop/runner/loop.sh financial-alert-system

# Vault Cortex 项目建议在有新数据发布时触发，而不是固定 cron
# （比如你自己的 BLS/FOMC 日历系统检测到新发布后调用）
/path/to/autonomous-loop/runner/loop.sh vault-cortex
```

## 下一步

这份是**框架骨架 + 两个项目的具体填充示例**，你需要做的：

1. 检查 `goals/*.goal.md` 里的红线是否符合你的真实底线，尤其是 `financial-alert-system`
   涉及告警阈值、密钥、资金相关的部分——这份是我按你项目描述推测的，务必修改成你真实要求。
2. 根据 `financial-alert-system` 的实际测试命令，把 `adapters/code-adapter.md` 里的
   评估命令换成真实的（`npm test` / `pytest` 等）。
3. `loop.sh` 里的 `claude` 调用参数（`--allowedTools`、`--max-turns`、`--max-budget-usd`）
   建议先在交互模式（去掉 `-p`）手动跑一轮，确认行为符合预期后再挂 cron。
4. 第一周建议不挂 cron，手动逐次触发，观察 `state.json` 和 `logs/` 里的记录是否合理，
   再切换成全自动定时。
```

---

## `autonomous-loop/goals/financial-alert-system.goal.md`

```markdown
---
project: financial-alert-system
adapter: code-adapter
allowed_tools: "Read,Edit,Bash(git:*),Bash(npm test),Bash(npm run lint),Bash(python -m pytest)"
max_turns: 40
max_budget_usd: 2
git_branch_prefix: "auto-iter/"
consecutive_failure_limit: 3
---

# 北极星目标

保持 `financial-alert-system`（scanner / on-chain / evaluator / notifier 四模块）
长期稳定运行，持续收敛 bug、提升代码质量与告警准确性，不引入回归。

# 允许自主决定（AI 可以自己判断并执行，不需要等人工批准）

- 修复已知 bug（有明确复现路径或测试失败证据的）
- 补充单元测试 / 边界情况测试
- 重构明确的代码坏味道（重复代码、命名混乱、缺少错误处理），前提是不改变外部行为
- 优化已确认的性能问题（有 benchmark 数据支撑，不是主观猜测）
- 更新代码注释、docstring、README 中过时的技术描述
- 修正明显的格式/Unicode/编码问题（如之前处理过的破折号规范化类问题）

# 红线（必须停下等人工审批，AI 不能自主执行）

- 修改告警触发阈值、评分逻辑的核心判定条件
- 修改 Server酱 / 任何通知渠道的密钥、endpoint、鉴权配置
- 修改 evaluator 模块中 Claude API 的核心 prompt 逻辑（可以提出修改建议，写入
  `state.json` 的 `next_candidates`，但不能自己改完就提交）
- 任何涉及钱包地址、链上监控目标地址的改动
- `git push --force`、删除任何 commit 历史
- 删除或截断历史日志、历史告警记录数据
- 新增或修改任何对外网络请求的目标域名/API endpoint

> 触发红线时的正确行为：在 `state.json` 的 `next_candidates` 里记录发现和建议，
> 标注 `requires_human_approval: true`，本轮不执行，继续处理其他任务。

# 评估标准（必须可判定，禁止用"看起来合理""应该没问题"这类模糊结论）

一轮迭代只有同时满足以下条件才算"通过"：

1. 全部既有测试通过（不能有回归），命令：见 `adapters/code-adapter.md`
2. lint 无新增 error（warning 数量不得增加）
3. 本轮改动的 diff 行数与任务描述的复杂度相称（防止"顺手改了不该改的地方"）
4. 如果改动涉及 evaluator/notifier 的输出格式，必须附带一次真实调用的输出样例作为证据

任一条不满足 → 本轮标记为失败，回滚改动（`git checkout` 到迭代前状态），
`consecutive_failures` 计数 +1，不得强行提交。
```

---

## `autonomous-loop/goals/vault-cortex.goal.md`

```markdown
---
project: vault-cortex
adapter: knowledge-adapter
allowed_tools: "mcp__obsidian__*,WebSearch,Read"
max_turns: 30
max_budget_usd: 1.5
consecutive_failure_limit: 3
---

# 北极星目标

保持 Vault Cortex 对宏观事件（Fed working groups、NFP 月度发布、FOMC 纪要、
关税/CLARITY Act 等日历节点）的分析持续更新，且严格遵守既有的事实核查协议——
禁止模糊评价语言（"合理""站得住脚"等），要求 source-level 溯源与可证伪表述。

# 允许自主决定

- 根据新发布的数据（新一期 NFP、新的 FOMC 纪要、Warsh working group 动态等）
  生成或更新对应的分析笔记草稿
- 更新已有笔记之间的交叉引用（如 NFP 质量审计 ↔ 方法论手册 ↔ 宏观日历节点）
- 标记方法论文档中因新证据出现而"可能需要修订"的段落（打标签，不直接改结论）
- 起草新的可证伪假设（必须自带 falsification criteria，否则不算完成）
- 维护宏观事件日历（新增/更新节点，不删除历史节点）

# 红线

- 不得自行将任何假设标记为"已证实"或"已证伪"——只能提出证据、标注置信度，
  最终判定必须留给你本人做
- 不得删除或覆盖历史笔记原文，只能新增或以"更新记录"形式追加
- 不得使用方法论手册明确禁止的模糊评价语言
- 涉及对 Fed/BLS 机构动机的定性判断（如"审计型 vs 背书型"结论）时，
  必须在笔记中明确标注"AI草稿，待人工复核"，不得作为最终结论写入核心方法论文档
- 不得自动执行 Obsidian 笔记的批量删除/重命名操作

# 评估标准

一条新增/更新的分析笔记必须同时满足：

1. 每个关键论断都有明确的一手数据来源标注（不能是"据说""普遍认为"）
2. 如果是假设性内容，必须包含可证伪判据（什么情况下这个假设会被推翻）
3. 不违反 `01_方法论/方法论_非农注水识别手册.md` 及既有 fact-checking 协议
4. 与已有笔记的交叉引用链接是否有效（不能生成指向不存在笔记的死链）

任一条不满足 → 本轮该条目标记为失败，写入 `failed_attempts`，不写入正式笔记，
仅保留为草稿供人工检查。
```

---

## `autonomous-loop/state/financial-alert-system.state.json`

```json
{
  "project": "financial-alert-system",
  "iteration_count": 0,
  "last_iteration": null,
  "current_focus": "初始化：请在第一轮迭代前手动填写当前最优先要处理的1-3个具体任务",
  "completed": [],
  "next_candidates": [],
  "failed_attempts": [],
  "consecutive_failures": 0,
  "requires_human_review": false
}
```

---

## `autonomous-loop/state/vault-cortex.state.json`

```json
{
  "project": "vault-cortex",
  "iteration_count": 0,
  "last_iteration": null,
  "current_focus": "初始化：建议第一轮聚焦 Warsh 五个 working group 的优先级监控协议落地",
  "completed": [],
  "next_candidates": [],
  "failed_attempts": [],
  "consecutive_failures": 0,
  "requires_human_review": false
}
```

---

## `autonomous-loop/adapters/code-adapter.md`

```markdown
# Code Adapter — 每轮迭代的执行规则

你正在对一个真实生产代码库进行**一轮**自主迭代。你没有上一轮的记忆，
下面提供的 `goal.md` 和 `state.json` 就是你全部的上下文，必须依赖它们而不是猜测。

## 本轮流程（严格按顺序）

1. **读状态**：读 `state.json` 的 `next_candidates` 和 `current_focus`，
   选出本轮要处理的**一个**具体任务（不要贪多，一轮一个任务，除非任务极小）。
   如果 `next_candidates` 为空，自己审查代码库找出下一个最有价值、
   且不触碰 `goal.md` 红线的任务。

2. **执行前检查红线**：对照 `goal.md` 的红线清单，确认本任务不在红线范围内。
   如果任务本身或执行过程中发现会触碰红线，立即停止该任务，
   把发现写入 `next_candidates`（标注 `requires_human_approval: true`），
   转而处理下一个非红线任务。

3. **在独立分支执行**：
   ```
   git checkout -b auto-iter/<task-slug>-<date>
   ```
   完成改动后运行评估命令（见下），**全部通过**才允许 commit。

4. **评估命令（按实际项目替换）**：
   ```bash
   npm test            # 或 python -m pytest
   npm run lint         # 或对应 lint 工具
   ```
   任一命令非零退出 → 本轮失败，执行：
   ```
   git checkout main -- . && git branch -D auto-iter/<task-slug>-<date>
   ```
   不允许强行 commit 未通过评估的改动。

5. **通过后 commit**（不 push，等待人工审查合并）：
   ```
   git add -A
   git commit -m "auto-iter: <task简述> [评估通过: test+lint]"
   ```

6. **更新 state.json**（作为本轮最后一步，必须执行）：
   - `iteration_count` +1
   - `last_iteration` 设为当前 ISO 时间戳
   - 成功：把任务从 `next_candidates` 移到 `completed`，`consecutive_failures` 归零
   - 失败：写入 `failed_attempts`（含具体失败原因，禁止写"未通过"这种空洞描述，
     必须写清楚是哪个测试/哪一行 lint 报错），`consecutive_failures` +1
   - 如果 `consecutive_failures` 达到 `goal.md` 里的 `consecutive_failure_limit`，
     设置 `requires_human_review: true`，本轮结束后不再自动触发下一轮

## 禁止事项（本适配器层面，独立于 goal.md 的红线）

- 禁止在评估未通过的情况下声称"应该没问题"就提交
- 禁止一轮内跨多个不相关模块同时改动
- 禁止修改本文件（`code-adapter.md`）或 `goal.md` 本身
```

---

## `autonomous-loop/adapters/knowledge-adapter.md`

```markdown
# Knowledge Adapter — 每轮迭代的执行规则

你正在对 Obsidian 知识库 Vault Cortex 进行**一轮**自主迭代，通过
`cyanheads/obsidian-mcp-server` 读写笔记。你没有上一轮记忆，
`goal.md` 和 `state.json` 是你全部上下文。

## 本轮流程

1. **读状态**：读 `state.json` 的 `next_candidates` 和 `current_focus`。
   如果为空，自主判断：是否有新的宏观事件/数据发布需要纳入分析
   （检查是否有你已知但笔记中尚未覆盖的近期 Fed/BLS/FOMC 动态）。

2. **执行前检查红线**：对照 `goal.md`。特别注意——任何"这个假设被证实/证伪了"
   这类**结论性判定**，本轮只能提出证据和置信度变化，不能替你下最终结论。

3. **写作规则（硬性）**：
   - 每个关键论断标注来源（哪份文件/哪次发布/哪条数据）
   - 假设性内容必须包含 falsification criteria 段落，格式：
     `## 证伪条件\n若出现 [具体可观测情况]，则本假设被推翻`
   - 严禁使用："合理""站得住脚""大概率""显然"等模糊评价词
     （沿用你现有 `~/.claude/CLAUDE.md` 事实核查协议的禁用词表）
   - 涉及机构动机定性判断的内容，笔记开头必须加：
     `> ⚠️ AI草稿，待人工复核，非最终结论`

4. **交叉引用检查**：新增/修改笔记后，检查涉及的双向链接（wikilink）
   指向的笔记是否存在，不允许生成死链。

5. **不确定性处理**：如果某个论断你无法找到明确来源支撑，
   不要为了完成任务而编造归因，宁可留空并写入 `failed_attempts`
   （原因写清楚："缺少一手数据来源，未完成"）。

6. **更新 state.json**（最后一步，必须执行）：
   - `iteration_count` +1，`last_iteration` 设为当前时间戳
   - 成功完成的条目 → `completed`，`consecutive_failures` 归零
   - 未完成/被红线拦下的 → `next_candidates`（保留，供下轮或人工处理）
   - 真正失败（尝试了但不满足评估标准）→ `failed_attempts`，
     `consecutive_failures` +1
   - 达到熔断阈值 → `requires_human_review: true`

## 禁止事项

- 禁止批量删除、重命名笔记
- 禁止把 AI 草稿直接写入核心方法论文档（`01_方法论/`），
  只能以"待审阅"笔记形式存在于独立的草稿区域
- 禁止跳过来源标注"先写着，来源以后补"
```

---

## `autonomous-loop/runner/loop.sh`

```bash
#!/usr/bin/env bash
#
# 自主迭代循环 - 单次调用运行"一轮"迭代
# 用法: ./loop.sh <project-name>
#   例如: ./loop.sh financial-alert-system
#         ./loop.sh vault-cortex
#
# 建议先手动跑几次观察行为，确认稳定后再挂 cron。

set -euo pipefail

PROJECT="${1:?用法: loop.sh <project-name>}"
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
GOAL_FILE="$BASE_DIR/goals/$PROJECT.goal.md"
STATE_FILE="$BASE_DIR/state/$PROJECT.state.json"
LOG_DIR="$BASE_DIR/logs"
TIMESTAMP="$(date -u +%Y%m%dT%H%M%SZ)"
LOG_FILE="$LOG_DIR/${PROJECT}-${TIMESTAMP}.json"

# 项目实际代码/vault路径需要你自己配置这个映射
declare -A PROJECT_WORKDIR=(
  ["financial-alert-system"]="$HOME/projects/financial-alert-system"
  ["vault-cortex"]="$HOME/vaults/vault-cortex"
)
WORKDIR="${PROJECT_WORKDIR[$PROJECT]:?未知项目: $PROJECT，请先在 loop.sh 里配置 WORKDIR 映射}"

if [[ ! -f "$GOAL_FILE" ]]; then
  echo "找不到 goal 文件: $GOAL_FILE" >&2
  exit 1
fi

# --- 熔断检查：如果上次已经标记 requires_human_review，直接拒绝本轮运行 ---
NEEDS_REVIEW="$(python3 -c "import json;print(json.load(open('$STATE_FILE')).get('requires_human_review', False))")"
if [[ "$NEEDS_REVIEW" == "True" ]]; then
  echo "[$PROJECT] 状态标记为 requires_human_review=true，已暂停自动运行。" >&2
  echo "请人工检查 $STATE_FILE 和最近的 logs/，处理后手动把该字段改回 false 再继续。" >&2
  exit 2
fi

# --- 从 goal.md 的 frontmatter 读取运行参数 ---
ADAPTER="$(awk -F': ' '/^adapter:/{print $2; exit}' "$GOAL_FILE")"
ALLOWED_TOOLS="$(awk -F': ' '/^allowed_tools:/{print $2; exit}' "$GOAL_FILE" | tr -d '"')"
MAX_TURNS="$(awk -F': ' '/^max_turns:/{print $2; exit}' "$GOAL_FILE")"
MAX_BUDGET="$(awk -F': ' '/^max_budget_usd:/{print $2; exit}' "$GOAL_FILE")"
ADAPTER_FILE="$BASE_DIR/adapters/${ADAPTER}.md"

# --- 组装本轮 prompt：目标 + 状态 + 适配器规则 ---
PROMPT="$(cat <<EOF
你正在为项目 "$PROJECT" 执行一轮全自动迭代。以下是你的完整上下文，
不要假设任何未在此处出现的信息。

===== 目标与红线 (goal.md) =====
$(cat "$GOAL_FILE")

===== 当前状态 (state.json) =====
$(cat "$STATE_FILE")

===== 本轮执行规则 (adapter) =====
$(cat "$ADAPTER_FILE")

===== 要求 =====
严格按适配器流程执行本轮迭代，并在完成后覆盖写回 $STATE_FILE。
不要输出与本轮工作无关的内容。
EOF
)"

cd "$WORKDIR"

echo "[$PROJECT] 开始第 $(date) 轮迭代 -> $LOG_FILE"

set +e
claude -p "$PROMPT" \
  --allowedTools "$ALLOWED_TOOLS" \
  --max-turns "$MAX_TURNS" \
  --max-budget-usd "$MAX_BUDGET" \
  --output-format json \
  > "$LOG_FILE" 2> "${LOG_FILE}.err"
CLAUDE_EXIT=$?
set -e

if [[ $CLAUDE_EXIT -ne 0 ]]; then
  echo "[$PROJECT] claude 调用非零退出 ($CLAUDE_EXIT)，查看 ${LOG_FILE}.err" >&2
  python3 - "$STATE_FILE" <<'PYEOF'
import json, sys, datetime
path = sys.argv[1]
with open(path) as f:
    state = json.load(f)
state["consecutive_failures"] = state.get("consecutive_failures", 0) + 1
state["last_iteration"] = datetime.datetime.utcnow().isoformat() + "Z"
if state["consecutive_failures"] >= 3:
    state["requires_human_review"] = True
with open(path, "w") as f:
    json.dump(state, f, ensure_ascii=False, indent=2)
PYEOF
  exit 1
fi

# state.json 应由本轮 Claude 执行内容自行更新（见 adapter 流程第6步）。
# 这里只做一个基本合法性校验，防止写坏 JSON。
if ! python3 -c "import json; json.load(open('$STATE_FILE'))" 2>/dev/null; then
  echo "[$PROJECT] 警告: state.json 在本轮结束后不是合法 JSON，可能被写坏，请人工检查。" >&2
  exit 1
fi

echo "[$PROJECT] 本轮完成，日志: $LOG_FILE"
```
