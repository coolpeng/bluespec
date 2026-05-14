# 任务清单：初始化 Harness Agentic 工作流系统

## 变更编号
`init-bluespec-harness-constitution`

## 前置条件
- [x] 提案已获 Stakeholder 批准
- [x] Worktree 隔离环境已搭建

## 任务列表

### 任务 1：起草项目宪法
**文件**：`openspec/project.md`

**描述**：创建项目宪法，定义项目使命、价值观、架构原则及变更管理流程。

**验收标准**：
- [x] 定义项目使命与目标
- [x] 建立架构原则（分层架构、单向依赖、状态机驱动）
- [x] 文档化变更管理工作流程
- [x] 定义质量标准

**负责人**：Architect

### 任务 2：定义 Agent 角色规范
**文件**：`AGENTS.md`

**描述**：将 Agent 规范升级为 BlueSpec Harness 入口地图，规定角色职责、核心行为规则、OpenSpec 工作流、文档地图和技能索引。

**验收标准**：
- [x] 定义 Architect 角色及其职责
- [x] 定义 Implementer 角色及其职责
- [x] 定义 Reviewer 角色及其职责
- [x] 定义 QA 角色及其职责
- [x] 文档化各角色间的协作工作流程
- [x] 明确所有 Agent 必须先读 `openspec/project.md`
- [x] 明确 Proposal 阶段严禁写代码
- [x] 明确 Superpowers 技能索引

**负责人**：Architect

### 任务 3：制定 iOS 专属 DoD 验证标准
**文件**：`docs/harness/verification-dod.md`

**描述**：建立针对 iOS 原生开发（SwiftUI + CoreBluetooth）的 Definition of Done 标准。

**验收标准**：
- [x] 定义 Xcode 构建要求
- [x] 定义测试要求（单元测试、UI 测试）
- [x] 定义 SwiftUI 最佳实践
- [x] 定义 CoreBluetooth 状态管理标准
- [x] 定义代码质量标准
- [x] 定义性能与内存要求
- [x] 定义 DoD 四步骤
- [x] 统一 `docs/harness/verification-dod.md` 为 DoD 权威入口

**负责人**：Architect

### 任务 4：补充 Harness 操作手册
**文件**：`docs/harness/governance.md`、`docs/harness/git-workflow.md`、`docs/harness/verification-dod.md`

**描述**：建立轻量 Harness 操作手册，覆盖规范治理、Git Worktree 和 DoD 验证。

**验收标准**：
- [x] 定义受保护文件列表和修改流程
- [x] 定义 Worktree 路径、分支、commit、PR 规则
- [x] 定义 iOS DoD 验证步骤和专项检查

**负责人**：Architect

### 任务 5：补充 OpenSpec 规格工作流约定
**文件**：`openspec/changes/init-bluespec-harness-constitution/design.md`

**描述**：明确能力规格、变更 delta、归档流程与验证命令约定。

**验收标准**：
- [x] 定义 `openspec/specs/{capability}/spec.md` 长期规格位置
- [x] 定义 `openspec/changes/{change-id}/specs/{capability}/spec.md` delta 位置
- [x] 定义 requirement 与 scenario 的编写要求
- [x] 定义 QA 签署后的归档流程

**负责人**：Architect

### 任务 6：验证初始设置
**描述**：验证所有宪法文件已就位且工作流已就绪。

**验收标准**：
- [x] 三个核心文件已创建并审查
- [x] 目录结构已建立
- [x] 工作流已文档化
- [x] `docs/harness/` 操作手册已创建
- [x] Worktree 隔离环境已实际创建并验证（`../bluespec-worktrees/init-bluespec-harness-constitution`）

**负责人**：QA

## 依赖关系
- 任务 6 依赖于任务 1、2、3、4、5 的完成

## 验证
- [x] 所有任务已完成
- [x] 已获得 Stakeholder 审批
- [x] 可进入下一阶段
