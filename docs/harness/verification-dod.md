# DoD 验证规范 — BlueSpec

**版本：** v1.2  
**生效日期：** 2026-05-12  
**最后更新：** 2026-05-15  
**权威来源：** `openspec/project.md`「TDD 与验证门禁」

---

## DoD 四步骤

声明任何实现任务完成，必须满足以下适用步骤：

```text
步骤 1：规格验证        → OpenSpec 文件齐全，scenario 可验证
步骤 2：构建验证        → xcodebuild build exit 0
步骤 3：测试验证        → xcodebuild test exit 0
步骤 4：运行时 smoke    → 按变更类型选择模拟器 UI 验证或 iPhone 真机 BLE 验证
```

当前 iOS 工程尚未创建时，文档类变更只执行步骤 1，并记录步骤 2-4 为不适用。

---

## 模拟器与真机边界

iOS Simulator 可用于 GUI、导航、布局、空状态、错误态、mock 数据和非硬件业务逻辑验证。CoreBluetooth 硬件能力不得以模拟器结果作为通过依据。

以下变更必须使用 iPhone 真机验证：

- BLE 外设扫描
- 设备连接和断开
- 服务发现
- 特征读取、写入、订阅通知
- 蓝牙权限、蓝牙关闭、系统设置跳转
- 后台、耗电、连接稳定性相关行为

真机 BLE 验证还必须准备可重复的外设环境。可接受的外设包括实际 BLE 设备、另一台运行 BLE peripheral 测试工具的手机、或团队约定的固定测试外设。若当前没有外设，不能声明 BLE 端到端流程通过，只能声明 mock/Domain/UI 层验证通过。

---

## 步骤 1：规格验证

每个功能性 change 必须包含：

- [ ] `proposal.md`
- [ ] `design.md`
- [ ] `tasks.md`
- [ ] `specs/{capability}/spec.md`
- [ ] 每个 requirement 至少包含一个 `Scenario:`
- [ ] `tasks.md` 的任务能映射到 requirement 或验证动作

初始化或 Harness 文档变更可以没有能力规格 delta，但必须在 `design.md` 中说明验收范围。

---

## 步骤 2：构建验证

iOS 工程创建后，默认构建命令为：

```bash
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcodebuild build -project ios/BlueSpec.xcodeproj -scheme BlueSpec -destination 'platform=iOS Simulator,name=iPhone 17'
```

通过标准：
- 命令 exit code 为 0
- 无编译错误
- 无新增编译警告

如果 scheme、project/workspace 路径、Xcode 路径或可用 Simulator destination 变化，必须在对应 change 的 `design.md`、`tasks.md` 或 PR 描述中说明实际命令。

---

## 步骤 3：测试验证

iOS 工程创建后，默认测试命令为：

```bash
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcodebuild test -project ios/BlueSpec.xcodeproj -scheme BlueSpec -destination 'platform=iOS Simulator,name=iPhone 17'
```

通过标准：
- 命令 exit code 为 0
- 所有单元测试通过
- 无 flaky test 证据
- Domain 和 Infrastructure 层核心逻辑有测试覆盖

---

## 步骤 4：运行时 Smoke Test

根据变更类型选择最小可验证路径：

| 变更类型 | 验证环境 | smoke test |
|----------|----------|------------|
| UI / GUI 变更 | iOS Simulator 或 iPhone 真机 | 关键屏幕在目标设备尺寸下无重叠、截断或不可访问控件 |
| Domain 状态机 | 单元测试，必要时配合模拟器 UI | 使用 mock BLE adapter 覆盖状态转换、错误路径和边界条件 |
| BLE 扫描 | iPhone 真机 + BLE 外设 | 启动应用 → 进入扫描页 → 蓝牙可用时开始扫描 → 结果列表或空状态正确展示 |
| 设备连接 | iPhone 真机 + BLE 外设 | 选择设备 → 发起连接 → 成功、失败、断开状态均可见 |
| 服务发现 | iPhone 真机 + BLE 外设 | 连接设备 → 发现服务 → 服务列表展示稳定 |
| 特征检查 | iPhone 真机 + BLE 外设 | 选择服务 → 查看特征 → 可读、可写、通知属性正确展示 |
| 权限处理 | iPhone 真机 | 蓝牙权限拒绝或蓝牙关闭 → 显示可理解状态和恢复指引 |

模拟器验证可以作为 UI 辅助证据，但不能替代真机 BLE smoke test。

### Simulator UI Smoke 执行策略

默认采用命令行驱动的 Simulator UI smoke test，以便验证过程可重复、可记录，并尽量不打断本机前台工作。默认流程为：

```bash
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcrun simctl boot '<simulator name>'
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcrun simctl install booted '<path-to-app>'
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcrun simctl launch booted '<bundle-id>'
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcrun simctl io booted screenshot '<evidence-path>.png'
```

通过标准：
- app 能安装并启动
- 截图中关键首屏、状态文案和主要控件可见
- 页面无明显重叠、截断或不可访问控件
- 对于不包含真实 BLE 的 change，不出现蓝牙权限弹窗

默认不打开 Xcode GUI，也不强制将 Simulator.app 带到前台。以下场景才需要显式执行 `open -a Simulator`，并进行可见窗口走查：

- Stakeholder 明确要求肉眼查看页面
- 视觉评审、交互走查或 Figma 对稿
- 截图证据不足以判断布局、动画、手势或状态变化
- 需要人工操作系统弹窗、权限设置或复杂导航路径

Xcode GUI 默认不作为验证入口。只有在需要调试 scheme、断点、日志、签名或项目配置时，才打开 Xcode。

---

## iOS 专项检查清单

### SwiftUI

- [ ] View 不包含 BLE 业务逻辑
- [ ] ViewModel 只暴露 UI 需要的状态和命令
- [ ] iOS 17+ 优先使用 `@Observable`
- [ ] 大量扫描结果使用合适的列表性能策略
- [ ] 空状态、加载中、错误状态完整

### Domain

- [ ] 状态机显式建模
- [ ] 所有状态转换有测试或验证证据
- [ ] Use Case 不依赖 SwiftUI
- [ ] Entity 不直接依赖 CoreBluetooth 类型，除非有明确包装边界

### CoreBluetooth

- [ ] `CBCentralManager` 状态被映射为 Domain 状态
- [ ] 权限拒绝、蓝牙关闭、连接失败、外设断开均有处理
- [ ] 扫描有停止策略
- [ ] 异步回调不会造成重复状态更新或竞争
- [ ] BLE 硬件路径已在 iPhone 真机验证，未仅依赖模拟器
- [ ] 真机验证使用的 BLE 外设、iOS 版本和设备型号已记录

### 性能与内存

- [ ] 无明显主线程阻塞
- [ ] 无循环引用风险
- [ ] 扫描和连接流程不会无限持有外设对象
- [ ] 可疑内存增长需通过 Instruments 或手动复测说明

### 可访问性

- [ ] 关键按钮和设备列表项有可访问标签
- [ ] 动态字体下布局不重叠
- [ ] 错误和权限状态可被 VoiceOver 理解

---

## 完成报告格式

声明完成时使用以下格式：

```md
## Verification
- OpenSpec structure: pass
- xcodebuild build: pass / not applicable / failed
- xcodebuild test: pass / not applicable / failed
- simulator UI smoke test: pass / not applicable / failed
- iPhone BLE smoke test: pass / not applicable / failed
- BLE test device: <device model / iOS version / peripheral used / not applicable>

## Notes
- <未执行验证的原因或剩余风险>
```

---

## 版本历史

| 版本 | 日期 | 变更内容 |
|------|------|----------|
| v1.2 | 2026-05-15 | 将默认构建/测试命令更新为当前 `ios/BlueSpec.xcodeproj` 路径和实际可用的 iPhone 17 Simulator；补充 Simulator UI smoke 默认采用命令行安装、启动、截图验证，明确仅在视觉评审、交互走查、Figma 对稿或 Stakeholder 要求时打开 Simulator 图形窗口；说明 Xcode GUI 默认不作为验证入口 |
| v1.1 | 2026-05-13 | 明确 iOS Simulator 与 iPhone 真机验证边界；规定 CoreBluetooth 硬件路径必须使用 iPhone 真机和 BLE 外设验证；完成报告新增 simulator UI smoke test、iPhone BLE smoke test 和 BLE test device |
| v1.0 | 2026-05-12 | 初始版本；建立 DoD 四步骤、iOS 专项检查清单和完成报告格式 |
