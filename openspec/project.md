# project.md — BlueSpec 项目宪法

**版本：** v1.1  
**生效日期：** 2026-05-12  
**最后更新：** 2026-05-12  
**定位：** 本文件是 BlueSpec Harness Engineering 的最高约束文档。所有 AI Agent 在开始任何任务前必须读取本文件，本文件的规则优先级高于 `AGENTS.md`、`tasks.md` 和其他辅助文档。

> 修改本文件的实质性规则必须同步更新版本号和最后更新日期，并遵循 `docs/harness/governance.md`。

---

## 1. 项目使命与目标

### 使命
BlueSpec 是一个探索规格驱动 AI 开发模式的实验性 iOS 项目，旨在研究如何通过 OpenSpec 和 Superpowers 指导 AI 辅助开发真正的 CoreBluetooth 应用。

### 核心目标
- 构建一个轻量级的 LightBlue 类 BLE 探索应用
- 验证规格驱动的 AI 开发工作流
- 探索状态机驱动的 SwiftUI 架构设计
- 建立可复用的个人项目级 Harness Engineering 模板

### 初始范围
- 外设扫描功能
- 设备连接管理
- 服务发现
- 特征值检查

### 当前尺度
BlueSpec 当前定位为个人 iOS 实验项目，而非多人企业交付项目。流程必须保持严肃但轻量：所有功能变更要可追溯、可测试、可验证，但不引入与当前目标无关的团队管理和业务专项规则。

---

## 2. 架构原则

### 2.1 分层架构
项目采用三层架构设计：

| 层级 | 职责 | 技术栈 |
|------|------|--------|
| **UI Layer** | 用户界面展示与交互 | SwiftUI, ViewModels |
| **Domain Layer** | 业务逻辑与状态管理 | Use Cases, Entities, State Machines |
| **Infrastructure Layer** | 外部依赖与设备访问 | CoreBluetooth Wrappers, Persistence |

### 2.2 单向依赖原则
- 依赖方向：UI Layer → Domain Layer → Infrastructure Layer
- 禁止循环依赖
- SwiftUI Views 仅依赖 ViewModels 和 Domain Entities
- Domain Layer 不直接依赖 SwiftUI 或 CoreBluetooth

### 2.3 状态机驱动设计
- CoreBluetooth 状态必须显式建模为状态机
- 所有状态转换必须文档化且可测试
- SwiftUI Views 应响应式地反映状态变更
- 权限拒绝、蓝牙关闭、连接失败、扫描超时必须作为显式状态处理

### 2.4 物理隔离原则
- Apply 阶段的所有实现必须在隔离的 Git Worktree 中实施
- 禁止直接在 main 分支实现功能
- 每个变更拥有独立的 OpenSpec 目录
- Worktree、分支、commit、PR 规则见 `docs/harness/git-workflow.md`

---

## 3. OpenSpec 变更管理流程

所有功能开发必须经过以下四个阶段，不可跳过：

```
Proposal（规划）→ Review（确认）→ Apply（实现）→ Archive（归档）
     │               │              │              │
  只产出文档      Stakeholder     才能写代码     规格进入基线
  严禁写代码      明确批准        TDD + DoD      change 关闭
```

### 3.1 Proposal 阶段
Architect 在 `openspec/changes/{change-id}/` 中创建：
- `proposal.md`：变更动机、范围、收益、风险
- `design.md`：架构设计、数据流、状态机、验证策略
- `specs/{capability}/spec.md`：能力规格 delta
- `tasks.md`：可执行任务清单

Proposal 阶段严禁写任何实现代码，包括示例实现片段。

### 3.2 Review 阶段
Stakeholder 必须明确批准 Proposal，才能进入 Apply。批准记录应写入 `proposal.md` 或 `tasks.md`。

### 3.3 Apply 阶段
Implementer 按 `tasks.md` 实现，并严格执行：
1. 创建或切换 Worktree
2. `writing-plans`
3. TDD：RED → GREEN → REFACTOR
4. DoD 验证
5. 更新 `tasks.md`

### 3.4 Archive 阶段
所有任务完成且 QA 签署后，Architect 或 QA 将 change delta 合并到 `openspec/specs/`，关闭对应 change。

### 3.5 OpenSpec 规格格式
- 长期能力规格位于 `openspec/specs/{capability}/spec.md`
- 变更 delta 位于 `openspec/changes/{change-id}/specs/{capability}/spec.md`
- delta 使用 `ADDED Requirements`、`MODIFIED Requirements`、`REMOVED Requirements`
- 每个 requirement 至少包含一个 `Scenario:`，描述可验证行为

---

## 4. TDD 与验证门禁

### 4.1 TDD 门禁
- 无对应测试的业务代码不得合并
- Domain 和 Infrastructure 层必须有单元测试
- CoreBluetooth 状态机测试为强制要求
- 关键 SwiftUI 流程必须有 UI 测试或明确的手动验证证据

### 4.2 DoD
详细验证步骤见 `docs/harness/verification-dod.md`。

声明任务完成前，必须执行适用验证并记录结果。当前 iOS 工程尚未创建时，文档类变更只验证文档结构、链接和 OpenSpec 一致性。

---

## 5. iOS / SwiftUI / CoreBluetooth 专属约束

### 5.1 SwiftUI
- View 只负责展示和用户交互，不承载 BLE 业务逻辑
- ViewModel 负责将 Domain 状态映射为 UI 状态
- iOS 17+ 优先使用 `@Observable`
- 列表类 UI 必须考虑大量外设扫描结果的性能和空状态

### 5.2 CoreBluetooth
- `CBCentralManager` 状态必须被包装为 Domain 可测试状态
- 扫描、连接、发现服务、读取特征必须通过 Use Case 暴露给 UI
- 蓝牙权限拒绝、蓝牙关闭、连接失败、外设断开必须有用户可理解的状态
- 扫描必须有停止策略，避免无谓耗电

### 5.3 性能与可靠性
- UI 响应时间目标 < 100ms
- BLE 扫描响应目标 < 500ms
- 启动时间目标 < 2s
- 无循环引用和可疑内存泄漏

---

## 6. Harness 规范治理

以下文件为受保护文件，实质性修改必须走 OpenSpec 流程：

| 文件 | 原因 |
|------|------|
| `openspec/project.md` | 项目宪法，最高约束 |
| `AGENTS.md` | Agent 行为入口，直接影响执行方式 |
| `docs/harness/governance.md` | Harness 规范治理 |
| `docs/harness/git-workflow.md` | 分支、Worktree、提交和 PR 规则 |
| `docs/harness/verification-dod.md` | 完成定义和验证门禁 |

细则见 `docs/harness/governance.md`。

---

## 7. 文档地图

| 文档 | 职责 |
|------|------|
| `AGENTS.md` | Agent 角色、行为规范、技能索引 |
| `docs/harness/governance.md` | 受保护文件和规范修改流程 |
| `docs/harness/git-workflow.md` | Worktree、分支、commit、PR 操作手册 |
| `docs/harness/verification-dod.md` | iOS DoD 和专项验证清单 |
| `openspec/changes/{change-id}/` | 变更提案、设计、规格 delta、任务 |
| `openspec/specs/{capability}/spec.md` | 长期能力规格 |

---

## 8. 沟通与决策

- 需求、范围、优先级由 Stakeholder 在当前对话或 OpenSpec 文档中确认
- 技术讨论记录在 `openspec/changes/{change-id}/design.md`
- 重大决策记录在 `openspec/decisions/`
- 代码审查通过 review 输出或 PR 评论记录

---

## 9. 版本控制规范

- `main`：主分支，仅接受已验证合并
- `feature/{change-id}`：功能变更
- `fix/{change-id}`：缺陷修复
- `docs/{change-id}`：文档或 Harness 规范变更

提交必须采用 Conventional Commits，并在 commit body 中包含：

```text
OpenSpec: <change-id>
```
