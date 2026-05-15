# App Shell 规格

## Requirements

### Requirement: App Shell Must Provide a Runnable iOS Entry Point
BlueSpec SHALL provide a minimal SwiftUI iOS application entry point that can launch into a root view without requiring Bluetooth hardware.

#### Scenario: Launch app shell in simulator
- **Given** the iOS app target has been built
- **When** the app launches in iOS Simulator
- **Then** the root view is displayed
- **And** no Bluetooth permission prompt is shown
- **And** no real BLE scan is started

### Requirement: App Shell Must Establish Layer Boundaries
BlueSpec SHALL establish UI, Domain, and Infrastructure directories that reflect the project constitution.

#### Scenario: Inspect layer directories
- **Given** the app shell has been created
- **When** the source tree is inspected
- **Then** UI files are located under `ios/BlueSpec/UI/`
- **And** Domain files are located under `ios/BlueSpec/Domain/`
- **And** Infrastructure files are located under `ios/BlueSpec/Infrastructure/`

### Requirement: Domain Must Be Testable Without Bluetooth Hardware
BlueSpec SHALL include at least one Domain-layer unit test that runs without CoreBluetooth or BLE hardware.

#### Scenario: Run domain unit test
- **Given** the unit test target exists
- **When** `xcodebuild test` is executed
- **Then** the Domain test passes
- **And** the test does not require an iPhone, BLE peripheral, or Bluetooth permission

### Requirement: BLE Hardware Behavior Must Be Deferred
The app shell SHALL NOT implement real CoreBluetooth scanning, connection, service discovery, or characteristic inspection.

#### Scenario: Review app shell scope
- **Given** the app shell change is under review
- **When** the implementation is inspected
- **Then** no concrete `CBCentralManager` scanning behavior is present
- **And** any BLE adapter remains mockable or protocol-based
- **And** iPhone BLE smoke test is reported as not applicable for this change
