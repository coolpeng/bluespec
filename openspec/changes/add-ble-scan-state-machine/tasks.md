# 任务清单：添加 BLE 扫描状态机与 Mock UI

## 变更编号
`add-ble-scan-state-machine`

## 当前阶段
Proposal 阶段，待 Stakeholder 审批后进入 Apply。

## 前置条件
- [ ] Stakeholder 已批准本 Proposal
- [ ] Apply 阶段 Worktree 已创建：`../bluespec-worktrees/add-ble-scan-state-machine`

## 任务列表

### 任务 1：定义 BLE 扫描 Domain 状态机
**文件**：`ios/BlueSpec/Domain/`

**描述**：定义硬件无关的扫描状态、事件、错误和状态转换边界。

**验收标准**：
- [ ] 状态覆盖 idle、scanning、empty、discovered、failed、stopped、permissionRequired、bluetoothUnavailable
- [ ] 状态转换由明确事件驱动
- [ ] Domain 不依赖 SwiftUI
- [ ] Domain 不依赖 CoreBluetooth

**负责人**：Implementer

### 任务 2：扩展设备摘要模型
**文件**：`ios/BlueSpec/Domain/Entities/`

**描述**：扩展或复用 `DiscoveredPeripheralSummary`，支持扫描列表展示所需字段。

**验收标准**：
- [ ] 设备摘要包含稳定 id、display name、RSSI
- [ ] 不暴露 CoreBluetooth 类型
- [ ] 支持 mock 数据构造

**负责人**：Implementer

### 任务 3：实现 Mock Scanner Adapter
**文件**：`ios/BlueSpec/Infrastructure/Bluetooth/`

**描述**：实现可控 mock adapter，用于触发扫描中、空结果、设备列表、失败、权限和不可用状态。

**验收标准**：
- [ ] mock 行为确定性可测试
- [ ] 不创建 `CBCentralManager`
- [ ] 不请求蓝牙权限
- [ ] 可被 ViewModel 注入

**负责人**：Implementer

### 任务 4：升级扫描页 ViewModel
**文件**：`ios/BlueSpec/UI/Scan/`

**描述**：将 Domain 扫描状态映射为 UI 标题、文案、按钮状态和列表数据。

**验收标准**：
- [ ] ViewModel 暴露开始/停止 mock 扫描命令
- [ ] ViewModel 覆盖 scanning、empty、discovered、failed、permissionRequired、bluetoothUnavailable 文案
- [ ] ViewModel 不直接依赖 CoreBluetooth
- [ ] ViewModel 映射有单元测试

**负责人**：Implementer

### 任务 5：升级扫描页 SwiftUI
**文件**：`ios/BlueSpec/UI/Scan/`

**描述**：将当前占位 UI 升级为 mock 扫描页，展示状态、空态、设备列表和错误/不可用提示。

**验收标准**：
- [ ] 扫描页可以显示 mock 设备列表
- [ ] 扫描页可以显示空状态
- [ ] 扫描页可以显示错误、权限、蓝牙不可用状态
- [ ] 关键按钮有图标或系统语义
- [ ] Simulator 截图无明显重叠或截断

**负责人**：Implementer

### 任务 6：补充测试与 DoD 验证
**文件**：`ios/BlueSpecTests/`、`docs/harness/verification-dod.md`

**描述**：使用 TDD 覆盖状态机和 ViewModel，并执行适用 DoD。

**验收标准**：
- [ ] Domain 状态转换测试通过
- [ ] ViewModel 映射测试通过
- [ ] `xcodebuild build` 通过
- [ ] `xcodebuild test` 通过
- [ ] simulator UI smoke test 通过
- [ ] iPhone BLE smoke test 标记为 not applicable，并说明本 change 不包含真实 BLE 硬件行为

**负责人**：QA

## 依赖关系
- 任务 2 依赖任务 1
- 任务 3 依赖任务 1 和任务 2
- 任务 4 依赖任务 1-3
- 任务 5 依赖任务 4
- 任务 6 依赖任务 1-5

## 验证
- [ ] 所有任务已完成
- [ ] DoD 验证通过
- [ ] 可提交 review
