# Proposal: add-ble-scan-state-machine

## 状态
**已批准，进入 Apply 阶段。**

## 背景
BlueSpec 已完成最小 iOS App Shell，并建立了 UI / Domain / Infrastructure 分层。当前扫描页仍是静态 mock 占位，尚未具备可测试的 BLE 扫描状态机，也没有稳定的 UI 状态映射。

真实 CoreBluetooth 扫描需要 iPhone 真机、BLE 外设、权限状态和异步回调验证。若直接接入硬件实现，容易把 Domain 状态建模、SwiftUI 展示、权限处理和硬件调试耦合在一起。

## 目标
本 change 先建立 BLE 扫描的可测试行为骨架：

- 定义不依赖 CoreBluetooth 的 Domain 扫描状态机
- 定义扫描命令、事件和状态转换规则
- 扩展 mock scanner adapter，用 mock 数据驱动 UI 状态
- 将当前扫描占位页升级为 mock 扫描列表 UI
- 用单元测试覆盖核心状态转换和 UI ViewModel 映射
- 保持本 change 不接入真实 `CBCentralManager`

## 非目标
本 change 不包含：

- 真实 CoreBluetooth 扫描
- iPhone 真机 BLE smoke test
- BLE 权限弹窗触发
- 设备连接、服务发现、特征读写
- 后台扫描、耗电或连接稳定性验证
- Figma 高保真视觉还原

## 方案概述
新增 `ble-scan` 能力规格。Domain 层负责扫描状态机和设备摘要模型，Infrastructure 层提供 mock scanner adapter，UI 层通过 ViewModel 将 Domain 状态映射为 SwiftUI 可展示状态。

状态机覆盖：

- `idle`
- `permissionRequired`
- `bluetoothUnavailable`
- `scanning`
- `empty`
- `discovered`
- `failed`
- `stopped`

UI 覆盖：

- 未开始扫描
- 扫描中
- 无设备
- mock 设备列表
- 权限/蓝牙不可用提示
- 错误状态

## 验证策略

- OpenSpec 文件结构检查
- Domain 单元测试覆盖状态转换
- ViewModel 单元测试覆盖 UI 文案和按钮状态
- `xcodebuild build` 通过
- `xcodebuild test` 通过
- Simulator UI smoke test 验证 mock 扫描页
- iPhone BLE smoke test 标记为 not applicable，并说明本 change 不包含真实 BLE 硬件行为

## 风险与缓解

| 风险 | 缓解 |
|------|------|
| 状态模型过早绑定 CoreBluetooth 类型 | Domain 禁止依赖 CoreBluetooth，只使用项目自定义实体 |
| mock UI 与未来真实扫描行为不一致 | 用 scanner adapter 协议隔离数据来源，真实 adapter 后续复用同一状态机 |
| 状态数量过多导致实现复杂 | 本 change 仅覆盖扫描前、中、后和基础错误，不处理连接/服务/特征 |
| 用户误以为已支持真实 BLE | UI 文案和 PR 说明明确 mock-only，真机 BLE smoke 标记 not applicable |

## 审批记录

- Stakeholder：用户
- 日期：2026-05-22
- 结论：批准进入 Apply
