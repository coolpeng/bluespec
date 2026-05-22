import XCTest
@testable import BlueSpec

final class BluetoothScanningStateTests: XCTestCase {
    func testScanStatesAreNotHardwareBacked() {
        XCTAssertFalse(BluetoothScanningState.idle.isHardwareBacked)
        XCTAssertFalse(BluetoothScanningState.scanning.isHardwareBacked)
        XCTAssertFalse(BluetoothScanningState.empty.isHardwareBacked)
        XCTAssertFalse(BluetoothScanningState.permissionRequired.isHardwareBacked)
        XCTAssertFalse(BluetoothScanningState.bluetoothUnavailable.isHardwareBacked)
    }

    func testStartScanTransitionsFromIdleToScanning() {
        let nextState = BluetoothScanningState.idle.applying(.startScan)

        XCTAssertEqual(nextState, .scanning)
        XCTAssertTrue(nextState.isScanning)
    }

    func testScanCompletedWithoutPeripheralsTransitionsToEmpty() {
        let nextState = BluetoothScanningState.scanning.applying(.scanCompleted)

        XCTAssertEqual(nextState, .empty)
    }

    func testPeripheralsUpdatedTransitionsToDiscovered() {
        let peripheral = DiscoveredPeripheralSummary(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
            displayName: "Blue Demo",
            rssi: -42
        )

        let nextState = BluetoothScanningState.scanning.applying(.peripheralsUpdated([peripheral]))

        XCTAssertEqual(nextState, .discovered([peripheral]))
        XCTAssertEqual(nextState.discoveredPeripherals, [peripheral])
    }

    func testScanFailureTransitionsToFailed() {
        let nextState = BluetoothScanningState.scanning.applying(.scanFailed(.mockFailure("Mock scan failed")))

        XCTAssertEqual(nextState, .failed(.mockFailure("Mock scan failed")))
    }

    func testStopScanTransitionsToStopped() {
        let nextState = BluetoothScanningState.scanning.applying(.stopScan)

        XCTAssertEqual(nextState, .stopped)
        XCTAssertFalse(nextState.isScanning)
    }

    func testPermissionAndAvailabilityEventsAreExplicitStates() {
        XCTAssertEqual(
            BluetoothScanningState.idle.applying(.permissionBecameRequired),
            .permissionRequired
        )
        XCTAssertEqual(
            BluetoothScanningState.idle.applying(.adapterBecameUnavailable),
            .bluetoothUnavailable
        )
    }

    func testMockAdapterCanDriveDeterministicScanOutcomes() {
        let adapter = MockBluetoothScannerAdapter()
        let peripheral = DiscoveredPeripheralSummary(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!,
            displayName: "Mock Sensor",
            rssi: -55
        )

        adapter.startMockScan()
        XCTAssertEqual(adapter.state, .scanning)

        adapter.showEmptyResult()
        XCTAssertEqual(adapter.state, .empty)

        adapter.startMockScan()
        adapter.showMockPeripherals([peripheral])
        XCTAssertEqual(adapter.state, .discovered([peripheral]))

        adapter.showPermissionRequired()
        XCTAssertEqual(adapter.state, .permissionRequired)

        adapter.showBluetoothUnavailable()
        XCTAssertEqual(adapter.state, .bluetoothUnavailable)

        adapter.showFailure("No mock transport")
        XCTAssertEqual(adapter.state, .failed(.mockFailure("No mock transport")))

        adapter.stopMockScan()
        XCTAssertEqual(adapter.state, .stopped)
    }
}

final class ScanPlaceholderViewModelTests: XCTestCase {
    func testViewModelMapsMockScanFlowToControlsAndRows() {
        let viewModel = ScanPlaceholderViewModel(scanner: MockBluetoothScannerAdapter())
        let peripheral = DiscoveredPeripheralSummary(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!,
            displayName: "Mock Sensor",
            rssi: -55
        )

        XCTAssertEqual(viewModel.primaryActionTitle, "Start Mock Scan")
        XCTAssertEqual(viewModel.primaryActionSystemImage, "magnifyingglass")
        XCTAssertFalse(viewModel.isScanning)

        viewModel.startMockScan()
        XCTAssertEqual(viewModel.state, .scanning)
        XCTAssertEqual(viewModel.primaryActionTitle, "Stop Mock Scan")
        XCTAssertEqual(viewModel.primaryActionSystemImage, "stop.circle")
        XCTAssertTrue(viewModel.isScanning)

        viewModel.showMockPeripherals([peripheral])
        XCTAssertEqual(viewModel.message, "1 mock peripheral found.")
        XCTAssertEqual(
            viewModel.deviceRows,
            [ScanDeviceRow(id: peripheral.id, name: "Mock Sensor", rssiText: "-55 dBm")]
        )

        viewModel.stopMockScan()
        XCTAssertEqual(viewModel.state, .stopped)
        XCTAssertEqual(viewModel.primaryActionTitle, "Start Mock Scan")
        XCTAssertFalse(viewModel.isScanning)
    }

    func testViewModelMapsEmptyFailurePermissionAndUnavailableStates() {
        let viewModel = ScanPlaceholderViewModel(scanner: MockBluetoothScannerAdapter())

        viewModel.startMockScan()
        viewModel.showEmptyResult()
        XCTAssertEqual(viewModel.message, "No mock peripherals found.")

        viewModel.showFailure("Mock transport failed")
        XCTAssertEqual(viewModel.message, "Mock transport failed")

        viewModel.showPermissionRequired()
        XCTAssertEqual(
            viewModel.message,
            "Bluetooth permission is required for real scanning. Mock mode does not request it."
        )

        viewModel.showBluetoothUnavailable()
        XCTAssertEqual(
            viewModel.message,
            "Bluetooth is unavailable. Mock mode can still show scan states."
        )
    }
}
