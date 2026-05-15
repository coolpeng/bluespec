# Harness 规范治理 — BlueSpec

**版本：** v1.0  
**生效日期：** 2026-05-12  
**最后更新：** 2026-05-12  
**权威来源：** `openspec/project.md`「Harness 规范治理」

---

## 受保护文件列表

以下文件的任何实质性修改必须走 OpenSpec 四阶段流程：

| 文件 | 原因 |
|------|------|
| `openspec/project.md` | 项目宪法，最高约束文档 |
| `AGENTS.md` | Agent 行为入口，直接影响执行方式 |
| `docs/harness/governance.md` | Harness 规范治理 |
| `docs/harness/git-workflow.md` | 分支、Worktree、提交和 PR 规则 |
| `docs/harness/verification-dod.md` | 完成定义和验证门禁 |

**不受保护**（可直接编辑）：`openspec/changes/*/` 变更文件、实验性源码、环境配置、临时说明文档。

---

## 修改流程

```
Proposal：创建 update-<target>-<description>
    ↓ Stakeholder 明确批准
Apply：修改受保护文件并更新 tasks.md
    ↓ 所有任务完成并通过验证
Archive：归档规格，关闭 change
```

在 Stakeholder 确认 Proposal 之前，禁止对受保护文件做实质性修改。

---

## 变更命名约定

格式：`update-<target>-<brief-description>`

示例：
- `update-project-ios-dod`
- `update-agents-workflow-map`
- `update-harness-git-worktree`

---

## 例外情况

以下情形允许直接编辑，但必须在 24h 内补录 OpenSpec 变更记录：

- 单个词语级别的错别字修正
- 纯格式调整（缩进、空行、标点）
- 已批准变更中的版本号和日期同步

---

## 不属于例外

以下情形必须先走 Proposal：

- 新增或删除任何规则、约束、禁止事项
- 修改现有规则的语义
- 新增或删除章节
- 修改 DoD 定义
- 修改受保护文件列表本身

---

## 可追溯性要求

每次对受保护文件的实质性修改，必须在对应 OpenSpec change 中记录：

- **Why**：为什么要改
- **What Changes**：改了什么
- **Impact**：影响哪些角色、流程或验证步骤
