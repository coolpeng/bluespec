# 提案：为 BlueSpec 初始化 Harness Agentic 工作流系统

## 变更编号
`init-bluespec-harness-constitution`

## 状态
**已批准**

审批记录：
- 审批角色：Stakeholder
- 审批日期：2026-05-12

## 目标
为 BlueSpec iOS 蓝牙低功耗（BLE）探索工具初始化 Harness Agentic 工作流系统。本系统将建立宪法框架、Agent 角色定义及验证标准，并针对 iOS 原生开发、SwiftUI 和 CoreBluetooth 特性进行定制化适配。

## 背景
BlueSpec 是一个探索 CoreBluetooth 应用规格驱动 AI 开发模式的实验性 iOS 项目。该项目需要一套健壮的 Agentic 工作流系统，以确保：
- 指导 LightBlue 类 BLE 探索应用的 AI 辅助开发
- 通过严格的 TDD 门禁机制强制执行架构完整性
- 维护物理 Worktree 隔离以实现安全的实验性开发
- 验证状态机驱动的 UI 架构设计

## 提案内容
遵循标准 Harness 工程范式，为 iOS/SwiftUI/CoreBluetooth 开发进行适配，实现 Harness Agentic 工作流系统。

### 核心组件
1. **项目宪法**（`openspec/project.md`）
   - 定义项目使命、价值观及架构原则
   - 建立变更管理流程
   - 定义验证标准

2. **Agent 角色规范**（`AGENTS.md`）
   - **Architect**：设计与提案变更
   - **Implementer**：按照宪法执行已批准的变更
   - **Reviewer**：依据 DoD 进行验证
   - **QA**：执行验证与测试

3. **iOS 专属 DoD**（`docs/harness/verification-dod.md`）
   - iOS 原生开发验证标准
   - SwiftUI 最佳实践
   - CoreBluetooth 状态管理标准
   - Xcode 构建与测试要求

4. **OpenSpec 规格管理约定**（`openspec/specs/`）
   - 定义能力规格目录结构
   - 定义变更 delta 的编写格式
   - 定义规格归档与验证流程

5. **Harness 操作手册**（`docs/harness/`）
   - `governance.md`：受保护文件与规范修改流程
   - `git-workflow.md`：Worktree、分支、提交和 PR 规范
   - `verification-dod.md`：iOS DoD 四步骤与专项检查

## 方法论
遵循 Harness 标准范式：
- **分层架构**：针对 iOS 进行适配的严格关注点分离
- **单向依赖**：清晰的依赖流向 UI Layer → Domain Layer → Infrastructure Layer
- **TDD 门禁**：未通过测试的代码不得合并
- **物理 Worktree 隔离**：安全的变更实施

## 收益
- 一致的开发工作流程
- 架构完整性强制执行
- 高质量的 iOS 原生代码
- 通过规格驱动开发实现明确的责任划分

## 风险
- 初始设置开销
- Agent 角色学习曲线
- 需要严格遵守流程

## 后续步骤
执行 `tasks.md` 中定义的剩余验证任务，并在后续功能开发中以 `openspec/specs/` 作为能力规格的长期基线，以 `docs/harness/` 作为 Harness 操作手册入口。
