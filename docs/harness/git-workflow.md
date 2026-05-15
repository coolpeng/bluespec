# Git 工作流规范 — BlueSpec

**版本：** v1.0  
**生效日期：** 2026-05-12  
**最后更新：** 2026-05-12  
**权威来源：** `openspec/project.md`「版本控制规范」

---

## 分支策略

`main` 为主分支，仅接受已验证的合并。功能实现不得直接发生在 `main` 分支。

功能分支格式：`{type}/{openspec-change-id}`

| type | 适用场景 |
|------|----------|
| `feature` | 新功能 |
| `fix` | 缺陷修复 |
| `docs` | 文档或 Harness 规范变更 |
| `refactor` | 不改变行为的重构 |
| `test` | 测试相关 |
| `chore` | 构建、依赖、配置 |

示例：
- `feature/add-ble-scanning`
- `fix/handle-bluetooth-powered-off`
- `docs/update-harness-dod`

---

## Worktree 使用规范

### 核心原则

每个 OpenSpec change 的 Apply 阶段必须使用独立 Git Worktree。Worktree 是物理工作目录隔离机制，不改变分支命名规则或 Git 历史结构。

### 路径约定

Worktree 放置在主仓库父目录下的统一目录：

```text
../bluespec-worktrees/{change-id}
```

### 创建时机

必须在 Proposal 被 Stakeholder 明确批准、进入 Apply 阶段后创建。禁止在 Proposal 阶段提前创建功能分支或写代码。

### 首次创建

```bash
git worktree add ../bluespec-worktrees/<change-id> -b <type>/<change-id>
cd ../bluespec-worktrees/<change-id>
```

示例：

```bash
git worktree add ../bluespec-worktrees/add-ble-scanning -b feature/add-ble-scanning
cd ../bluespec-worktrees/add-ble-scanning
```

### 后续继续同一变更

```bash
cd ../bluespec-worktrees/<change-id>
git status --short
```

如果远端分支已存在且需要同步：

```bash
git pull origin <type>/<change-id>
```

### 清理

PR 合并或 change 关闭后，在主仓库目录执行：

```bash
git worktree remove ../bluespec-worktrees/<change-id>
git worktree list
```

---

## Commit 规范

提交采用 Conventional Commits：

```text
<type>(<scope>): <subject>

OpenSpec: <change-id>
```

规则：
- `subject` 使用英文，动词开头，不超过 72 字符
- commit body 必须包含 `OpenSpec: <change-id>`
- 每个 commit 应对应一个完整、可验证的任务或 TDD 循环
- 禁止提交临时代码、调试日志或无关格式化

示例：

```text
feat(ble): add scanner state machine

OpenSpec: add-ble-scanning
```

---

## Pull Request 规范

PR 标题建议使用 OpenSpec change id，例如 `add-ble-scanning`。

PR 描述必须包含：

```md
## OpenSpec
Change: `<change-id>`
Path: `openspec/changes/<change-id>/`

## Summary
- <变更摘要>

## Verification
- xcodebuild build: pass / not run
- xcodebuild test: pass / not run
- simulator smoke test: pass / not run
- CoreBluetooth state machine tests: pass / not run

## Notes
- <无法执行的验证或剩余风险>
```
