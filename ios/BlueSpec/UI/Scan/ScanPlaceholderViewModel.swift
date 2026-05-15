import Foundation
import Observation

@Observable
final class ScanPlaceholderViewModel {
    private let scanner: BluetoothScannerAdapter

    var state: BluetoothScanningState {
        scanner.state
    }

    init(scanner: BluetoothScannerAdapter = MockBluetoothScannerAdapter()) {
        self.scanner = scanner
    }

    var title: String {
        "Nearby Devices"
    }

    var message: String {
        switch state {
        case .idle:
            return "Ready to scan. Real Bluetooth scanning will be added in a later change."
        case .mockScanning:
            return "Mock scanning..."
        case .mockEmpty:
            return "No mock peripherals found."
        case .mockResults(let devices):
            return "\(devices.count) mock peripherals found."
        }
    }

    func startMockScan() {
        scanner.startMockScan()
    }
}
