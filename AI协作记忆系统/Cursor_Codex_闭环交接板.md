---
type: Cursor_Codex闭环交接板
schema_version: 2
tags: [AI协作, Cursor, Codex, Obsidian, 闭环, CC-08]
created: 2026-07-23
updated: '2026-07-23'
project: financial-alert-system
loop_id: loop-2026-07-23-021
revision: 2
turn: 1
next_actor: 'codex'
status: 'pending_review'
max_turns: 8
last_writer: 'cursor'
written_at: '2026-07-23T14:30:06.594Z'
lease_owner: ''
lease_actor: ''
lease_expires_at: ''
code_root: F:\financial-alert-system
vault_note: AI协作记忆系统/Cursor_Codex_闭环交接板.md
repo_mirror: docs/ai-collab/Cursor_Codex_闭环交接板.md
---

# Cursor ↔ Codex 闭环交接板

> [!important] 口令：**评审闭环交接板** · CC-08
>
> 审核：`master` @ `01a43fd`
> **AI refs 仍 disarm**；Scenario **只读抽离**；**未** held-out/forward；**未** RESEARCH_PASS

## 0. 闭环协议

```text
CC-08 已提交 → pending_review/codex → PASS / CHANGES_REQUIRED / BLOCKED
```

### 0.1 硬边界

- 代码根：`F:\financial-alert-system`
- 允许：`packages/scenario-domain`；ScenarioView/IO 契约；浏览器/Micro 薄适配；包测/差分/回归/fail-closed
- 禁止：改变 Scenario/Micro 对外行为；改前端框架；DB 迁移；解除 AI refs disarm；held-out/forward；RESEARCH_PASS；提交 `architecture.html`

## 1. 任务目标

| 字段 | 内容 |
|---|---|
| 一句话目标 | 建立 `packages/scenario-domain`，抽离只读 Scenario 核心，应用层仅薄适配且行为不变。 |
| 成功标准 | 包级单测 PASS；旧/新 v2 结果差分一致；Micro 回归 PASS；fail-closed 覆盖；Codex PASS。 |
| 明确不做 | held-out/forward；RESEARCH_PASS；重开 AI refs；前端框架/DB 迁移。 |

## 2. 仪表盘

| 项 | 值 |
|---|---|
| loop_id | `loop-2026-07-23-021` |
| stage | CC-08 |
| status / next_actor | `pending_review` / `codex` |
| HEAD | `01a43fd04d9f0c46faa228bb5b4f8019a2ff2673` |
| prior CC-07C | `2f06ae6` PASS（归档 `loop-020`） |

## 3. 下一条Cursor指令

```text
（Cursor 本轮完成。Codex 领取 pending_review 后只读复审。）
```

## 4. Cursor完成报告

```text
状态：CC-08 scenario-domain extract
verdict：DONE
summary：新建 packages/scenario-domain（@fas/scenario-domain）：只读 ScenarioView 契约、v2 builders、normalize、macro evidence。static/scenario_reasoner.js 与 Micro macro_context_adapter 改为薄适配。旧 tip f45665a vs domain v2 差分一致。包测/解析渲染 smoke/Micro 回归/domain-missing fail-closed PASS。未改前端框架；无 DB 迁移；AI refs 保持 disarm；未 held-out/forward；未 RESEARCH_PASS；未提交 architecture.html。
evidence：
- git_before_HEAD：f45665af9b9bab56302d6c2eb71d4b059a9dfdcd（CC-07C archive / CC-08 open）
- git_after_HEAD：01a43fd04d9f0c46faa228bb5b4f8019a2ff2673
- worktree：packages/scenario-domain/**；static/scenario_reasoner.js；micro-layer/adapters/macro_context_adapter.js；propagation.html；package.json；scripts/{build_scenario_domain_browser,diff_scenario_v2_domain,smoke_scenario_domain_failclosed,smoke_scenario_parse,smoke_scenario_render}.js
- SHA-256：
  - packages/scenario-domain/src/index.js = fcf2c977fb2de7c01e828573d518a79caaa7eee4a21fb2f2517ca47d9201afab
  - packages/scenario-domain/src/view.js = 22d119bed7d80cde0208736bc125faf4d62b88a513e2929b92f60b6b5a38b5fb
  - packages/scenario-domain/src/v2_build.js = d0b87bb89fcadb85c6bae7e80c0699239339aeb3383f594c69b33594e050db8c
  - packages/scenario-domain/src/normalize.js = 94b186a980e32a0cbcd9c0c54aa8d41ccf62597f556fcc0a784100f8c3585838
  - packages/scenario-domain/src/macro_evidence.js = 165fd181e7c8b0a36d3c6d158afffbccb867d30634e64cb6278f50251bc5ca9a
  - packages/scenario-domain/src/calendar.js = 42f52a30a1a7597d1e82e5971b3f0d40b5faa4f4f647a681f908cce25bb797be
  - packages/scenario-domain/browser.umd.js = 2ef68d6826093a517d771eae7d71eefdad2fec3a4eb78af07b3b02fb33dbc160
  - static/scenario_reasoner.js = 792cbad703587eb4695ccda5a9dfe4c809bd30bcedd5ab44bf294869f37e786e
  - micro-layer/adapters/macro_context_adapter.js = 7b557826fecd668604a7aee7e806fe65546e0aa89eea89686f1c1ffea968cdac
  - package.json = fb3c06259e8ea2e0fc5fb8b4cf38ed2be02fe1d008f304d8d9e346671b43b55a
  - propagation.html = 770f04ede6ff92de139ab893b896b67741e52cad203139fdda1a39a24be33f6e
  - scripts/diff_scenario_v2_domain.js = eaf057c131705c35d1f88df1b4d634b9de8c8a95ea7194d6a1d242f2d581b657
  - scripts/smoke_scenario_domain_failclosed.js = 5685271cfb3a5c3f2aa53d17a3038c60524360675ef0f2c213b66ee7e1b82cf1
  - scripts/build_scenario_domain_browser.js = a87edfbce23a9704c0a29b1121ed1c5f33504d9cbe674f34775f51fc077304f3
- verify：
  - npm run test:scenario-domain → exit 0
  - npm run diff:scenario-v2-domain → exit 0（old_ref=f45665a identical）
  - node scripts/smoke_scenario_parse.js → exit 0（8/8）
  - node scripts/smoke_scenario_render.js → exit 0（7/7）
  - node micro-layer/tests/smoke_macro_evidence_status.js → exit 0
  - npm run smoke:scenario-domain-failclosed → exit 0
  - npm run smoke:cc08-scenario-domain → exit 0
```

## 5. Codex反馈

```text
（待 Codex 领取 pending_review 后填写）
```

## 6. 回合历史

### Turn 0 — 2026-07-23
- Codex：CC-07C PASS @ `2f06ae6`。
- Human：归档 CC-07C；开 CC-08（scenario-domain）；排除 architecture.html。
- Cursor：归档 `loop-020`；开环 `loop-2026-07-23-021` → pending_exec/cursor。

### Turn 1 — 2026-07-23
- Cursor：落地 `@fas/scenario-domain` + 薄适配 + 包测/差分/Micro 回归/fail-closed @ `01a43fd` → pending_review/codex。
