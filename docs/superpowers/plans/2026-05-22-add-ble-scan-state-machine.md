# BLE Scan State Machine Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a hardware-free BLE scan Domain state machine and deterministic mock scan UI that can be tested in Simulator without CoreBluetooth.

**Architecture:** Domain owns scan states, events, failures, device summaries, and transition logic. Infrastructure provides a deterministic mock adapter that emits Domain snapshots. UI ViewModel maps Domain state into SwiftUI display state and commands.

**Tech Stack:** Swift 5.9, SwiftUI, Observation, XCTest, XcodeGen/Xcode project already present under `ios/`.

---

## File Structure

- Modify: `ios/BlueSpec/Domain/Entities/DiscoveredPeripheralSummary.swift` — keep hardware-free device summary and add deterministic fixture support if needed.
- Replace: `ios/BlueSpec/Domain/UseCases/BluetoothScanningState.swift` — define scan state, events, failures, and reducer.
- Modify: `ios/BlueSpec/Domain/UseCases/BluetoothScannerAdapter.swift` — expose current scan state and deterministic mock commands.
- Modify: `ios/BlueSpec/Infrastructure/Bluetooth/MockBluetoothScannerAdapter.swift` — deterministic adapter for empty, discovered, failed, permission, unavailable, and stopped states.
- Modify: `ios/BlueSpec/UI/Scan/ScanPlaceholderViewModel.swift` — map scan states to UI copy, buttons, and list rows.
- Modify: `ios/BlueSpec/UI/Scan/ScanPlaceholderView.swift` — show scan controls, status, empty/error states, and mock device rows.
- Replace: `ios/BlueSpecTests/BluetoothScanningStateTests.swift` — Domain state transition tests.
- Modify: `ios/BlueSpecTests/BluetoothScanningStateTests.swift` — ViewModel mapping tests live beside Domain tests in the existing test target file.
- Modify: `openspec/changes/add-ble-scan-state-machine/tasks.md` — mark completed tasks and record verification.

No file in this change may import `CoreBluetooth`.

---

### Task 1: Domain State Machine

**Files:**
- Test: `ios/BlueSpecTests/BluetoothScanningStateTests.swift`
- Modify: `ios/BlueSpec/Domain/UseCases/BluetoothScanningState.swift`
- Modify: `ios/BlueSpec/Domain/Entities/DiscoveredPeripheralSummary.swift`

- [x] **Step 1: Write failing Domain state transition tests**

Replace `ios/BlueSpecTests/BluetoothScanningStateTests.swift` with tests for:
- idle to scanning
- scanning to empty
- scanning to discovered
- scanning to failed
- scanning to stopped
- permission required
- bluetooth unavailable
- hardware-free state

- [x] **Step 2: Run RED**

```bash
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcodebuild test -project ios/BlueSpec.xcodeproj -scheme BlueSpec -destination 'platform=iOS Simulator,name=iPhone 17'
```

Expected: fails because `BluetoothScanEvent`, `BluetoothScanFailure`, and `applying(_:)` do not exist yet.

- [x] **Step 3: Implement Domain types**

Implement:
- `BluetoothScanFailure`
- `BluetoothScanEvent`
- `BluetoothScanningState.applying(_:)`
- `BluetoothScanningState.isScanning`
- `BluetoothScanningState.discoveredPeripherals`
- `BluetoothScanningState.isHardwareBacked`

- [x] **Step 4: Run GREEN**

Run the same `xcodebuild test` command.

Expected: Domain tests pass.

---

### Task 2: Mock Scanner Adapter

**Files:**
- Modify: `ios/BlueSpec/Domain/UseCases/BluetoothScannerAdapter.swift`
- Modify: `ios/BlueSpec/Infrastructure/Bluetooth/MockBluetoothScannerAdapter.swift`
- Test: `ios/BlueSpecTests/BluetoothScanningStateTests.swift`

- [x] **Step 1: Extend failing adapter tests**

Add tests for:
- `startMockScan()` transitions to scanning
- `showEmptyResult()` transitions to empty
- `showMockPeripherals()` transitions to discovered
- `showPermissionRequired()` transitions to permissionRequired
- `showBluetoothUnavailable()` transitions to bluetoothUnavailable
- `showFailure()` transitions to failed
- `stopMockScan()` transitions to stopped

- [x] **Step 2: Run RED**

Run `xcodebuild test`.

Expected: fails because adapter protocol and methods do not exist yet.

- [x] **Step 3: Implement adapter protocol and mock adapter**

Expose deterministic methods on `BluetoothScannerAdapter` and implement them in `MockBluetoothScannerAdapter` by applying Domain events.

- [x] **Step 4: Run GREEN**

Run `xcodebuild test`.

Expected: adapter tests pass.

---

### Task 3: ViewModel Mapping

**Files:**
- Modify: `ios/BlueSpecTests/BluetoothScanningStateTests.swift`
- Modify: `ios/BlueSpec/UI/Scan/ScanPlaceholderViewModel.swift`

- [x] **Step 1: Write failing ViewModel mapping tests**

Create tests for:
- idle title/message/action
- scanning message and stop action
- empty message
- discovered device rows
- failed message
- permission required message
- bluetooth unavailable message

- [x] **Step 2: Run RED**

Run `xcodebuild test`.

Expected: fails because ViewModel rows/actions/mappings do not exist.

- [x] **Step 3: Implement ViewModel display model**

Add a lightweight `ScanDeviceRow` and map Domain state to:
- title
- message
- primary button title/icon
- secondary button title/icon if needed
- device rows
- `isScanning`

- [x] **Step 4: Run GREEN**

Run `xcodebuild test`.

Expected: ViewModel tests pass.

---

### Task 4: SwiftUI Mock Scan Page

**Files:**
- Modify: `ios/BlueSpec/UI/Scan/ScanPlaceholderView.swift`

- [x] **Step 1: Update SwiftUI view**

Render:
- title and message
- start/stop button with system icon
- deterministic mock state buttons/menu for discovered, empty, failed, permission, unavailable
- list rows with device name and RSSI

- [x] **Step 2: Run build**

```bash
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcodebuild build -project ios/BlueSpec.xcodeproj -scheme BlueSpec -destination 'platform=iOS Simulator,name=iPhone 17'
```

Expected: build succeeds.

- [x] **Step 3: Run tests**

Run `xcodebuild test`.

Expected: all tests pass.

---

### Task 5: Verification And OpenSpec Completion

**Files:**
- Modify: `openspec/changes/add-ble-scan-state-machine/tasks.md`

- [x] **Step 1: Scope guard**

```bash
rg "CoreBluetooth|CBCentralManager|scanForPeripherals|NSBluetooth" ios
```

Expected: no matches.

- [x] **Step 2: Simulator UI smoke**

Install and launch the app in iPhone 17 Simulator, then capture screenshot:

```bash
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcrun simctl boot 'iPhone 17'
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcrun simctl install booted '<path-to-BlueSpec.app>'
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcrun simctl launch booted com.coolpeng.BlueSpec
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcrun simctl io booted screenshot /tmp/bluespec-ble-scan-state-machine.png
```

Expected: scan page is visible, mock states are represented, and no Bluetooth permission prompt appears.

- [x] **Step 3: Update tasks**

Mark all completed acceptance criteria in `openspec/changes/add-ble-scan-state-machine/tasks.md`.

- [ ] **Step 4: Commit**

```bash
git add ios openspec/changes/add-ble-scan-state-machine docs/superpowers/plans/2026-05-22-add-ble-scan-state-machine.md
git commit -m "feat(ble): add scan state machine" -m "OpenSpec: add-ble-scan-state-machine"
```

Expected: commit succeeds.

---

## Self-Review

- Spec coverage: all `ble-scan` requirements map to Tasks 1-5.
- Placeholder scan: no implementation placeholders remain in this plan.
- Scope check: real CoreBluetooth scanning is deferred to a future change.
- Verification: build, test, scope guard, and Simulator UI smoke are required before completion.
