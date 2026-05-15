# AGENTS.md — BlueSpec Harness 角色分工与行为规范

**版本：** v1.1  
**生效日期：** 2026-05-12  
**最后更新：** 2026-05-12

> 所有 Agent 在开始任何任务前，必须先读取 `openspec/project.md`。  
> `openspec/project.md` 是最高约束文档，优先级高于本文件。  
> 详细操作规范见 `docs/harness/`。

---

## Harness 架构概览

```
用户需求 / 项目目标
        │
        ▼
[Architect] 读 project.md → brainstorming → 创建 OpenSpec Proposal
        │  Stakeholder 明确批准；Proposal 阶段严禁写代码
        ▼
[Implementer] 读 specs + tasks → Worktree → writing-plans → TDD → coding
        │
        ▼
[Reviewer] 检查 spec 覆盖、测试、DoD、架构约束
        │  NEEDS_FIXES → Implementer 修复 → 重新 review
        ▼
[QA] 运行验证 → 签署 → Archive → 合并
```

---

## 核心行为规范

### 规则 1：先读宪法
任何 Agent 开始任务前，必须确认已读取 `openspec/project.md`。文件不存在则停止工作。

### 规则 2：规范先于代码
所有功能性变更必须先创建 OpenSpec change。纯错别字、格式或版本日期同步可直接修改，但不得改变规则语义。

### 规则 3：Proposal 阶段严禁写代码
Architect 只产出 `proposal.md`、`design.md`、`specs/*/spec.md`、`tasks.md`。必须等待 Stakeholder 明确批准后才能进入 Apply。

### 规则 4：TDD 不可跳过
实现任务必须先写失败测试，再写最小实现，再重构。无法自动化测试的验证项必须写入 DoD 证据。

### 规则 5：验证后才能声明完成
声明任何任务完成前，必须执行 `docs/harness/verification-dod.md` 中适用的验证步骤，并说明无法执行的原因。

### 规则 6：不超出当前 change 范围
每个任务只做 `tasks.md` 描述的事。发现新需求或相关问题，记录为新的 OpenSpec change，不顺手扩展。

### 规则 7：Worktree 隔离
Apply 阶段必须在独立 Git Worktree 中实施。具体命名、创建、清理规则见 `docs/harness/git-workflow.md`。

### 规则 8：Harness 文档治理
修改 `openspec/project.md`、`AGENTS.md`、`docs/harness/*` 等受保护文件的实质性规则，必须走 OpenSpec 流程。细则见 `docs/harness/governance.md`。

---

## 角色定义

### Architect（架构师）

**职责：** 需求澄清、架构设计、规格产出。不做实现代码。

**工作流：**
1. 读取 `openspec/project.md`，确认约束
2. 使用 `brainstorming` 澄清需求和方案
3. 创建完整 OpenSpec change：`proposal.md`、`design.md`、`specs/*/spec.md`、`tasks.md`
4. 展示给 Stakeholder，等待明确批准

**约束：** Proposal 阶段严禁写实现代码；设计必须符合 project.md 的分层、状态机、TDD 和 Worktree 规则。

**使用技能：** `brainstorming`

---

### Implementer（实现者）

**职责：** 按已批准规格逐任务实现功能。

**工作流：**
1. 读取 `openspec/project.md`、对应 `design.md`、`specs/*/spec.md` 和 `tasks.md`
2. 按 `docs/harness/git-workflow.md` 创建或切换 Worktree
3. 使用 `writing-plans` 制定实现计划
4. 使用 `test-driven-development` 执行 RED → GREEN → REFACTOR
5. 执行 `docs/harness/verification-dod.md` 中的验证步骤
6. 标记 `tasks.md` 对应任务为 `[x]`

**使用技能：** `writing-plans`、`test-driven-development`、`verification-before-completion`

---

### Reviewer（审查者）

**职责：** 审查变更是否符合规格、架构原则、测试和 DoD。

**核心检查项：**
- [ ] 实现覆盖 OpenSpec requirement 和 scenario
- [ ] 每个关键 scenario 有对应测试或明确的手动验证证据
- [ ] UI → Domain → Infrastructure 依赖方向未被破坏
- [ ] CoreBluetooth 状态机转换可追踪、可测试
- [ ] DoD 已按受影响范围执行并记录结果
- [ ] commit 或 PR 关联 `OpenSpec: <change-id>`

**输出格式：**

```md
## Code Review — <change-id>
### CRITICAL（必须修复，阻塞进度）
### IMPORTANT（合并前修复）
### MINOR（记录，后续处理）
### 结论：PASS / NEEDS_FIXES
```

---

### QA（质量保证）

**职责：** 执行最终验证、确认 DoD、签署归档和合并。

**工作流：**
1. 确认所有 `tasks.md` 项已完成或有明确豁免
2. 执行 `docs/harness/verification-dod.md` 的最终验证
3. 确认 OpenSpec delta 已归档到 `openspec/specs/`
4. 签署发布或合并批准

---

### Stakeholder（项目所有者 / 需求确认者）

**职责：**
- 审批或拒绝 OpenSpec 提案
- 确认需求、范围和优先级
- 判断变更是否符合 BlueSpec 的实验目标
- 在关键产品和技术取舍上做最终决策

**权限：**
- 批准、暂停或拒绝 change
- 调整功能范围和优先级
- 决定是否进入 Apply 阶段

**行为准则：**
- 提供清晰目标和约束
- 对提案范围进行明确确认
- 尊重技术角色的实现建议
- 避免在未更新 OpenSpec 文档的情况下直接改变需求

---

## OpenSpec 工作流

| 阶段 | 产出 | 约束 |
|------|------|------|
| Proposal | `proposal.md`、`design.md`、`specs/*/spec.md`、`tasks.md` | 严禁写代码 |
| Review | Stakeholder 明确确认 | 未确认不得进入 Apply |
| Apply | 实现代码、测试、`tasks.md` 更新 | 必须 Worktree + TDD |
| Archive | delta 合并到 `openspec/specs/` | 所有任务完成并通过 DoD |

---

## 文档地图

| 文档 | 职责 | 何时查阅 |
|------|------|----------|
| `openspec/project.md` | 项目宪法、最高约束 | 任何任务开始前 |
| `docs/harness/git-workflow.md` | 分支、Worktree、commit、PR 规范 | 创建分支、提交、合并时 |
| `docs/harness/governance.md` | Harness 文档治理与受保护文件 | 修改规范文档时 |
| `docs/harness/verification-dod.md` | iOS DoD 与专项验证 | 声明完成前、QA 验证时 |
| `openspec/changes/{change-id}/` | 当前变更规格与任务 | Proposal / Apply / Review 全程 |

---

## Superpowers 技能索引

| 技能 | 触发场景 |
|------|----------|
| `brainstorming` | 需求澄清、方案探索、创建规格前 |
| `writing-plans` | 已批准 change 进入实现前 |
| `test-driven-development` | 所有实现任务 |
| `systematic-debugging` | bug 调查、测试失败、运行异常 |
| `receiving-code-review` | 处理 review feedback |
| `verification-before-completion` | 声明完成、提交、归档前 |

---

## 项目约定（快速参考）

```bash
# Worktree 示例
git worktree add ../bluespec-worktrees/<change-id> -b feature/<change-id>

# 后续 iOS 工程创建后的验证命令示例
xcodebuild build -scheme BlueSpec -destination 'platform=iOS Simulator,name=iPhone 16'
xcodebuild test -scheme BlueSpec -destination 'platform=iOS Simulator,name=iPhone 16'
```
