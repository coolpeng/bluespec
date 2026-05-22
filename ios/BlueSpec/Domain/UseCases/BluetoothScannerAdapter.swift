protocol BluetoothScannerAdapter {
    var state: BluetoothScanningState { get }
    func startMockScan()
    func stopMockScan()
    func showEmptyResult()
    func showMockPeripherals(_ peripherals: [DiscoveredPeripheralSummary])
    func showPermissionRequired()
    func showBluetoothUnavailable()
    func showFailure(_ message: String)
}
