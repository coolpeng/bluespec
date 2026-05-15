final class MockBluetoothScannerAdapter: BluetoothScannerAdapter {
    private(set) var state: BluetoothScanningState = .idle

    func startMockScan() {
        state = .mockEmpty
    }

    func stopMockScan() {
        state = .idle
    }
}
