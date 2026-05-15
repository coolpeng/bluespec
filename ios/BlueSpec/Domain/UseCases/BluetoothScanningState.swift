enum BluetoothScanningState: Equatable {
    case idle
    case mockScanning
    case mockEmpty
    case mockResults([DiscoveredPeripheralSummary])

    var isHardwareBacked: Bool {
        false
    }
}
