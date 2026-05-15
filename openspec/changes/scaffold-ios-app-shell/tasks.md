# 任务清单：创建 BlueSpec iOS App Shell

## 变更编号
`scaffold-ios-app-shell`

## 前置条件
- [x] Stakeholder 已批准本 Proposal
- [x] Worktree 已创建：`../bluespec-worktrees/scaffold-ios-app-shell`

## 任务列表

### 任务 1：创建最小 iOS 工程
**文件**：`ios/BlueSpec.xcodeproj`、`ios/BlueSpec/`

**描述**：创建 SwiftUI iOS app target，确保工程可被 Xcode 和 `xcodebuild` 识别。

**验收标准**：
- [x] 存在 `BlueSpec` app target
- [x] 存在 `BlueSpecTests` unit test target
- [x] 工程位于 `ios/`
- [x] 未加入真实 CoreBluetooth 实现

**负责人**：Implementer

### 任务 2：建立分层目录
**文件**：`ios/BlueSpec/UI/`、`ios/BlueSpec/Domain/`、`ios/BlueSpec/Infrastructure/`

**描述**：建立符合项目宪法的 UI / Domain / Infrastructure 目录边界。

**验收标准**：
- [x] UI 层包含 App 入口、RootView 和扫描页占位视图
- [x] Domain 层包含实体和 Use Case 协议占位
- [x] Infrastructure 层包含 Bluetooth adapter 占位目录
- [x] Domain 不依赖 SwiftUI 或 CoreBluetooth

**负责人**：Implementer

### 任务 3：创建扫描页占位 UI
**文件**：`ios/BlueSpec/UI/Scan/`

**描述**：实现可在模拟器展示的扫描页占位界面，用于后续接入 BLE 状态机。

**验收标准**：
- [x] App 启动后可看到 BlueSpec 标题
- [x] 扫描页展示非硬件 mock 状态
- [x] 空状态和基础布局在模拟器中无明显重叠
- [x] 不请求蓝牙权限

**负责人**：Implementer

### 任务 4：建立最小 Domain 测试
**文件**：`ios/BlueSpecTests/`

**描述**：创建一个不依赖 CoreBluetooth 的 Domain 层单元测试，证明测试 target 可执行。

**验收标准**：
- [x] 至少一个 Domain 测试通过
- [x] 测试不依赖真实蓝牙硬件
- [x] 测试命令记录在完成报告中

**负责人**：Implementer

### 任务 5：执行 DoD 验证
**文件**：`docs/harness/verification-dod.md`

**描述**：运行适用的构建、测试和模拟器 UI smoke test。

**验收标准**：
- [x] `xcodebuild build` 通过
- [x] `xcodebuild test` 通过
- [x] simulator UI smoke test 通过
- [x] iPhone BLE smoke test 标记为 not applicable，并说明本 change 不包含 BLE 硬件行为

**验证记录**：
- `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcodebuild build -project ios/BlueSpec.xcodeproj -scheme BlueSpec -destination 'platform=iOS Simulator,name=iPhone 17'`：通过
- `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcodebuild test -project ios/BlueSpec.xcodeproj -scheme BlueSpec -destination 'platform=iOS Simulator,name=iPhone 17'`：通过，2 tests / 0 failures
- `rg "CoreBluetooth|CBCentralManager|scanForPeripherals|NSBluetooth" ios`：无匹配
- simulator UI smoke：iPhone 17 Simulator 安装并启动 `com.coolpeng.BlueSpec`，截图确认 BlueSpec 首屏、mock 状态文案和按钮可见，无蓝牙权限弹窗
- iPhone BLE smoke：not applicable，本 change 只创建 app shell 和 mock 状态，不包含真实 BLE 硬件行为

**负责人**：QA

## 依赖关系
- 任务 2 依赖任务 1
- 任务 3 依赖任务 2
- 任务 4 依赖任务 2
- 任务 5 依赖任务 1-4

## 验证
- [x] 所有任务已完成
- [x] DoD 验证通过
- [x] 可提交 review
