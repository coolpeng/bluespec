# 设计：BlueSpec 的 Harness Agentic 工作流系统

## 概述
本文档定义了针对 BlueSpec iOS 原生开发（SwiftUI + CoreBluetooth）的 Harness Agentic 工作流系统架构设计。

## 核心架构原则

### 1. 分层架构（iOS 适配版）
```
┌─────────────────────────────────────────┐
│           UI Layer (SwiftUI)            │
│  - Views, ViewModels, State Management  │
└──────────────┬──────────────────────────┘
               │ depends on
               ↓
┌─────────────────────────────────────────┐
│         Domain Layer                    │
│  - Use Cases, Entities, Services        │
│  - BLE State Machines                   │
└──────────────┬──────────────────────────┘
               │ depends on
               ↓
┌─────────────────────────────────────────┐
│      Infrastructure Layer               │
│  - CoreBluetooth Wrappers               │
│  - Persistence, Networking              │
└─────────────────────────────────────────┘
```

### 2. 单向依赖原则
- UI Layer → Domain Layer → Infrastructure Layer
- 禁止循环依赖
- SwiftUI Views 仅依赖于 ViewModels 和 Domain Entities

### 3. 状态机驱动设计
- CoreBluetooth 状态显式建模为状态机
- SwiftUI Views 对状态变更做出可预测的响应
- 所有状态转换均需文档化并可测试

### 4. 物理 Worktree 隔离
- 变更在隔离的 Worktree 中实施
- 禁止直接修改 main 分支
- 每个变更拥有独立的规格目录
- Worktree 路径约定：`../bluespec-worktrees/{change-id}`
- 分支命名约定：`feature/{change-id}`
- 创建命令示例：`git worktree add ../bluespec-worktrees/{change-id} -b feature/{change-id}`
- Implementer 负责创建 Worktree，Reviewer/QA 负责在验证时确认实施不发生在 main 分支

## Agentic 工作流设计

### 变更管理流程
1. **提案阶段**：Architect 在 `openspec/changes/{change-id}/` 中创建提案
2. **审批阶段**：Stakeholder 审查并批准
3. **规格阶段**：Architect 在 `openspec/changes/{change-id}/specs/` 中描述能力规格 delta
4. **执行阶段**：Implementer 执行 `tasks.md` 中的任务
5. **验证阶段**：Reviewer 依据 DoD 和规格 delta 进行验证
6. **归档阶段**：QA 签署后，将已批准 delta 合并到 `openspec/specs/`，再合并代码

### TDD 门禁
- 无对应测试的代码不得合并
- Domain Layer 和 Infrastructure Layer 必须包含单元测试
- 关键 SwiftUI 流程必须包含 UI 测试
- CoreBluetooth 状态机测试为强制要求

### OpenSpec 规格约定
- 长期能力规格位于 `openspec/specs/{capability}/spec.md`
- 变更中的规格 delta 位于 `openspec/changes/{change-id}/specs/{capability}/spec.md`
- 规格 delta 使用 `ADDED Requirements`、`MODIFIED Requirements`、`REMOVED Requirements` 分区
- 每个 requirement 至少包含一个 `Scenario:`，描述可验证的行为
- Reviewer 必须确认实现、测试与 delta 中的 scenario 对齐
- QA 签署后，Architect 或 QA 将 delta 归档到长期规格，并关闭对应 change

### 验证命令约定
- 规格验证：检查 `proposal.md`、`design.md`、`tasks.md` 和适用的 `specs/` delta 是否齐全
- 构建验证：在 iOS 工程创建后运行 `docs/harness/verification-dod.md` 中定义的 Xcode 构建命令
- 测试验证：在 iOS 工程创建后运行 `docs/harness/verification-dod.md` 中定义的测试命令
- 当前初始化变更仅验证文档结构、链接和规范一致性，不要求运行 Xcode 构建

## 文件结构设计
```
bluespec/
├── AGENTS.md                   # Agent Roles
├── openspec/
│   ├── project.md              # Project Constitution
│   ├── changes/
│   │   └── {change-id}/
│   │       ├── proposal.md
│   │       ├── design.md
│   │       ├── tasks.md
│   │       └── specs/
│   │           └── {capability}/
│   │               └── spec.md  # Change Delta
│   └── specs/
│       └── {capability}/
│           └── spec.md          # Long-lived Capability Spec
├── docs/
│   └── harness/
│       ├── governance.md        # Harness Governance
│       ├── git-workflow.md      # Git / Worktree Workflow
│       └── verification-dod.md  # Definition of Done
├── BlueSpec/                   # iOS App Source
│   ├── UI/
│   ├── Domain/
│   └── Infrastructure/
└── BlueSpecTests/
```

## 验证标准（iOS 专属）
- 所有 Target 的 Xcode 构建成功
- 所有单元测试通过
- SwiftUI Previews 编译并渲染正常
- 无编译器警告
- CoreBluetooth 状态机验证通过
- 内存泄漏检查（Leaks instrument）通过

初始化工作流变更的验收范围：
- `openspec/project.md`、`AGENTS.md`、`docs/harness/*` 已创建并互相引用一致
- `openspec/changes/{change-id}/` 包含 `proposal.md`、`design.md`、`tasks.md`
- Worktree、OpenSpec 规格、Harness 治理和 DoD 的执行规则已文档化
