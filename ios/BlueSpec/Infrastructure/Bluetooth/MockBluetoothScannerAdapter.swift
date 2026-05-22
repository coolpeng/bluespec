final class MockBluetoothScannerAdapter: BluetoothScannerAdapter {
    private(set) var state: BluetoothScanningState = .idle

    func startMockScan() {
        state = state.applying(.startScan)
    }

    func stopMockScan() {
        state = state.applying(.stopScan)
    }

    func showEmptyResult() {
        state = state.applying(.scanCompleted)
    }

    func showMockPeripherals(_ peripherals: [DiscoveredPeripheralSummary]) {
        state = state.applying(.peripheralsUpdated(peripherals))
    }

    func showPermissionRequired() {
        state = state.applying(.permissionBecameRequired)
    }

    func showBluetoothUnavailable() {
        state = state.applying(.adapterBecameUnavailable)
    }

    func showFailure(_ message: String) {
        state = state.applying(.scanFailed(.mockFailure(message)))
    }
}
