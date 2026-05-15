# 设计：BlueSpec iOS App Shell

## 概述
本变更创建 BlueSpec 的最小 SwiftUI App Shell。目标是建立工程、分层目录、测试 target 和基础页面骨架，为后续 BLE 扫描状态机和真实 CoreBluetooth 集成提供稳定落点。

## 架构边界

```
BlueSpec App
    │
    ▼
UI Layer
    - BlueSpecApp
    - RootView
    - Scan placeholder screen
    - ViewModels
    │
    ▼
Domain Layer
    - Entities
    - Use Case protocols
    - BLE state model placeholders
    │
    ▼
Infrastructure Layer
    - BLE adapter protocol conformance placeholders
    - No real CoreBluetooth implementation in this change
```

## 目录规划

```text
ios/
├── BlueSpec.xcodeproj
├── BlueSpec/
│   ├── App/
│   ├── UI/
│   │   └── Scan/
│   ├── Domain/
│   │   ├── Entities/
│   │   └── UseCases/
│   └── Infrastructure/
│       └── Bluetooth/
└── BlueSpecTests/
```

## UI 设计
App Shell 的 UI 仅提供可运行、可检查的占位体验：

- 应用启动进入根视图
- 根视图展示 BlueSpec 标题和扫描页占位状态
- 扫描页显示“未开始扫描 / 空结果 / mock 状态”一类非硬件状态
- 不要求还原 Figma Make 设计稿

Figma 设计稿可作为后续 UI 专项 change 的输入，例如 `implement-lightblue-gui-shell`。

## Domain 边界
本 change 只定义后续 BLE 功能所需的最小边界：

- 可测试的设备摘要实体，例如设备名称、标识符、RSSI 占位
- 扫描状态模型占位，例如 idle、mockScanning、mockEmpty
- BLE adapter 协议占位，供后续真实 CoreBluetooth adapter 实现

不得在本 change 中直接实现真实 `CBCentralManager`。

## 验证策略

### 可用模拟器验证
- Xcode build
- Unit tests
- SwiftUI 页面启动和布局 smoke test
- 非硬件 mock 状态展示

### 不适用验证
- BLE 扫描真机验证
- 设备连接真机验证
- 服务发现或特征读写真机验证

这些真机 BLE 验证将在后续 CoreBluetooth 功能 change 中执行。

## Worktree
Apply 阶段使用：

```bash
git worktree add ../bluespec-worktrees/scaffold-ios-app-shell -b feature/scaffold-ios-app-shell
cd ../bluespec-worktrees/scaffold-ios-app-shell
```

## 验收标准
- iOS 工程可通过 `xcodebuild build`
- 单元测试 target 可通过 `xcodebuild test`
- 目录结构符合 `openspec/project.md` 的 UI / Domain / Infrastructure 分层
- App 可在 iOS Simulator 启动到占位扫描界面
- 不包含真实 CoreBluetooth 硬件行为
