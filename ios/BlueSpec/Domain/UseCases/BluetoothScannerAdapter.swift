protocol BluetoothScannerAdapter {
    var state: BluetoothScanningState { get }
    func startMockScan()
    func stopMockScan()
}
