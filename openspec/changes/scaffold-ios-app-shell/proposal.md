# 提案：创建 BlueSpec iOS App Shell

## 变更编号
`scaffold-ios-app-shell`

## 状态
**已批准，进入 Apply 阶段**

审批记录：
- 审批角色：Stakeholder
- 审批日期：2026-05-15

## 目标
创建 BlueSpec 的最小 iOS 应用骨架，使项目从 Harness 文档基线进入可构建、可测试、可展示 GUI 的工程阶段。

本变更只建立 App Shell 和工程边界，不实现真实 CoreBluetooth 扫描、连接、服务发现或特征读写。

## 背景
当前项目已经完成 Harness 初始化，具备 OpenSpec、Superpowers、DoD、Worktree 和治理规则。但仓库尚未包含可运行的 iOS 工程，因此 `docs/harness/verification-dod.md` 中的 `xcodebuild build/test` 还没有实际落点。

在进入 BLE 功能开发前，需要先建立一个最小 SwiftUI 工程，明确 UI / Domain / Infrastructure 分层、测试 target 和可验证的构建命令。

## 范围

### 包含
- 创建最小 BlueSpec iOS app target
- 创建 unit test target
- 建立 `UI`、`Domain`、`Infrastructure` 三层目录
- 创建主入口、根视图和扫描页占位 UI
- 创建 mock BLE adapter 边界，用于后续 Domain 状态机测试
- 建立最小构建和测试验证命令

### 不包含
- 不实现真实 `CBCentralManager`
- 不请求真实蓝牙权限
- 不扫描真实 BLE 外设
- 不连接设备、不发现服务、不读取特征
- 不实现 Figma 设计稿的高保真 UI 还原

## 方法论
- Proposal 阶段只产出规格文档，不写实现代码
- Apply 阶段必须使用独立 Worktree：`../bluespec-worktrees/scaffold-ios-app-shell`
- 实现阶段遵循 TDD：先建立可失败的结构/测试，再补最小实现
- GUI 可在 iOS Simulator 验证；BLE 硬件能力留到后续 change 在 iPhone 真机验证

## 收益
- 让 BlueSpec 拥有可构建、可测试的 iOS 工程基础
- 为后续 BLE 状态机和 CoreBluetooth 封装提供清晰边界
- 让 DoD 中的 Xcode 构建和测试门禁开始可执行
- 将 GUI 展示和 BLE 硬件验证阶段解耦

## 风险
- Xcode 工程文件可能产生较大 diff，需要保持变更范围克制
- 如果过早加入真实 BLE 代码，会破坏本 change 的 App Shell 边界
- Figma UI 还原若混入本 change，会导致范围膨胀

## 后续步骤
Stakeholder 审查并批准后，进入 Apply 阶段，创建 Worktree 并按 `tasks.md` 实施。
