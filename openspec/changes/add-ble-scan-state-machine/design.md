# Design: add-ble-scan-state-machine

## 设计目标
建立一个不依赖真实蓝牙硬件的 BLE 扫描状态机，使扫描页可以通过 mock 数据展示完整的扫描体验，并为后续 CoreBluetooth adapter 接入提供稳定边界。

## 架构边界

| 层级 | 本 change 职责 | 禁止事项 |
|------|----------------|----------|
| UI | 展示扫描状态、列表、空状态、错误状态和用户命令 | 不直接依赖 CoreBluetooth，不持有硬件对象 |
| Domain | 定义扫描状态、事件、设备摘要和状态转换 | 不依赖 SwiftUI 或 CoreBluetooth |
| Infrastructure | 提供 mock scanner adapter，模拟扫描结果和错误 | 不创建 `CBCentralManager`，不请求蓝牙权限 |

依赖方向保持：

```text
UI → Domain ← Infrastructure
```

UI 和 Infrastructure 均依赖 Domain 协议与实体，但 Domain 不依赖 UI 或 Infrastructure。

## Domain 模型

### 扫描状态
扫描状态应表达用户可感知的扫描流程：

- `idle`：尚未开始扫描
- `permissionRequired`：需要蓝牙权限或权限不可用的抽象状态
- `bluetoothUnavailable`：蓝牙关闭或当前环境不可扫描
- `scanning`：正在扫描
- `empty`：扫描完成但没有发现设备
- `discovered([DiscoveredPeripheralSummary])`：发现一个或多个设备
- `failed(ScanFailure)`：扫描失败
- `stopped`：用户主动停止扫描

状态命名在实现时可根据 Swift 语义微调，但必须覆盖上述可验证语义。

### 扫描事件
状态转换由事件驱动：

- `startScan`
- `stopScan`
- `adapterBecameUnavailable`
- `permissionBecameRequired`
- `peripheralsUpdated`
- `scanCompleted`
- `scanFailed`

### 设备摘要
设备摘要沿用或扩展现有 `DiscoveredPeripheralSummary`，保持硬件无关：

- stable id
- display name
- RSSI
- optional metadata for mock display

不得在 Domain 实体中直接暴露 CoreBluetooth 类型。

## Mock Adapter
Mock adapter 应能驱动以下场景：

- start 后进入 scanning
- 返回空结果
- 返回 mock 设备列表
- 返回权限/蓝牙不可用状态
- 返回失败状态
- stop 后进入 stopped 或 idle

Mock 数据应稳定、可测试，不依赖计时器随机性。若需要模拟异步，应通过可控方法或测试注入触发。

## UI 设计
当前 `ScanPlaceholderView` 升级为扫描页。界面保持轻量，但要呈现真实产品骨架：

- 顶部保留 `BlueSpec` / `Nearby Devices` 信息结构
- 主操作按钮支持开始/停止 mock 扫描
- 扫描中显示进度状态
- 空状态说明当前没有发现设备
- 设备列表显示名称和 RSSI
- 权限/蓝牙不可用/失败状态显示可理解文案

UI 文案需要明确这是 mock 扫描，不触发真实蓝牙权限。

## 状态流

```text
User taps Start
  → ViewModel sends startScan
  → Domain transitions idle → scanning
  → Mock adapter publishes empty / discovered / failed / unavailable
  → ViewModel maps Domain state to UI
  → SwiftUI renders progress, empty state, list, or error

User taps Stop
  → ViewModel sends stopScan
  → Domain transitions scanning/discovered/empty/failed → stopped
  → UI returns to stopped/ready state
```

## 验证设计

### 单元测试
必须覆盖：

- `idle → scanning`
- `scanning → empty`
- `scanning → discovered`
- `scanning → failed`
- `scanning → stopped`
- unavailable / permission 状态映射
- ViewModel 文案和按钮状态映射
- Domain 不依赖 CoreBluetooth

### 模拟器验证
Simulator UI smoke test 验证：

- app 能启动到扫描页
- mock 扫描状态可见
- mock 设备列表或空状态可见
- 无蓝牙权限弹窗
- 页面无明显重叠或截断

### 真机验证
iPhone BLE smoke test 为 not applicable。本 change 不包含真实 BLE 硬件行为。

## 迁移与兼容
本 change 可以重命名或替换当前 `BluetoothScanningState`，但必须保持 `app-shell` 长期规格仍成立：

- app 可在模拟器启动
- 不请求蓝牙权限
- 不启动真实 BLE 扫描
- Domain 可在无硬件环境测试

## 后续工作
本 change 完成并归档后，后续可创建：

- `add-corebluetooth-scanner-adapter`
- `add-bluetooth-permission-handling`
- `add-device-connection-state-machine`
