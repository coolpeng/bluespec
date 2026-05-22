# BLE Scan 规格 Delta

## ADDED Requirements

### Requirement: BLE Scan Must Be Modeled As A Hardware-Free Domain State Machine
BlueSpec SHALL model BLE scanning as a Domain state machine that does not depend on SwiftUI or CoreBluetooth.

#### Scenario: Start scanning from idle
- **Given** the scan state is idle
- **When** the user starts a mock scan
- **Then** the scan state becomes scanning
- **And** no CoreBluetooth object is created

#### Scenario: Stop scanning
- **Given** the scan state is scanning
- **When** the user stops scanning
- **Then** the scan state becomes stopped or returns to a ready state
- **And** the UI exposes a non-scanning state

### Requirement: BLE Scan Must Represent User-Visible Outcomes
BlueSpec SHALL represent the major user-visible scan outcomes as explicit states.

#### Scenario: No peripherals found
- **Given** a mock scan is running
- **When** the mock adapter reports no peripherals
- **Then** the scan state becomes empty
- **And** the UI displays an empty state

#### Scenario: Peripherals discovered
- **Given** a mock scan is running
- **When** the mock adapter reports one or more peripherals
- **Then** the scan state contains the discovered peripheral summaries
- **And** the UI displays a device list with name and RSSI

#### Scenario: Scan failed
- **Given** a mock scan is running
- **When** the mock adapter reports an error
- **Then** the scan state becomes failed
- **And** the UI displays a user-readable error state

### Requirement: BLE Scan Must Represent Permission And Availability States
BlueSpec SHALL represent Bluetooth permission and availability as explicit states without triggering real permission prompts in this change.

#### Scenario: Permission required
- **Given** the mock adapter reports that permission is required
- **When** the scan state is updated
- **Then** the scan state becomes permissionRequired
- **And** the UI displays a permission-related message
- **And** no real Bluetooth permission prompt is shown

#### Scenario: Bluetooth unavailable
- **Given** the mock adapter reports Bluetooth unavailable
- **When** the scan state is updated
- **Then** the scan state becomes bluetoothUnavailable
- **And** the UI displays an unavailable-state message

### Requirement: BLE Scan Mock UI Must Be Verifiable In Simulator
BlueSpec SHALL provide a mock scan UI that can be verified in iOS Simulator without BLE hardware.

#### Scenario: Verify mock scan UI in simulator
- **Given** the app has launched in iOS Simulator
- **When** the user interacts with the mock scan controls
- **Then** scanning, empty, discovered, failed, permission, and unavailable states are reachable through deterministic mock behavior or tests
- **And** no real BLE scan is started
- **And** iPhone BLE smoke test is reported as not applicable for this change
