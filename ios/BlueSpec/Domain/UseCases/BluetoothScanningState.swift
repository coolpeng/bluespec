enum BluetoothScanFailure: Equatable {
    case mockFailure(String)
}

enum BluetoothScanEvent: Equatable {
    case startScan
    case stopScan
    case adapterBecameUnavailable
    case permissionBecameRequired
    case peripheralsUpdated([DiscoveredPeripheralSummary])
    case scanCompleted
    case scanFailed(BluetoothScanFailure)
}

enum BluetoothScanningState: Equatable {
    case idle
    case permissionRequired
    case bluetoothUnavailable
    case scanning
    case empty
    case discovered([DiscoveredPeripheralSummary])
    case failed(BluetoothScanFailure)
    case stopped

    var isHardwareBacked: Bool {
        false
    }

    var isScanning: Bool {
        self == .scanning
    }

    var discoveredPeripherals: [DiscoveredPeripheralSummary] {
        if case .discovered(let peripherals) = self {
            return peripherals
        }

        return []
    }

    func applying(_ event: BluetoothScanEvent) -> BluetoothScanningState {
        switch event {
        case .startScan:
            return .scanning
        case .stopScan:
            return .stopped
        case .adapterBecameUnavailable:
            return .bluetoothUnavailable
        case .permissionBecameRequired:
            return .permissionRequired
        case .peripheralsUpdated(let peripherals):
            return peripherals.isEmpty ? .empty : .discovered(peripherals)
        case .scanCompleted:
            return .empty
        case .scanFailed(let failure):
            return .failed(failure)
        }
    }
}
