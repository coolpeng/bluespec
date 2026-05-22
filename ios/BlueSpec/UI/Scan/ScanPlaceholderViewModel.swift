import Foundation
import Observation

struct ScanDeviceRow: Equatable, Identifiable {
    let id: UUID
    let name: String
    let rssiText: String
}

@Observable
final class ScanPlaceholderViewModel {
    private let scanner: BluetoothScannerAdapter

    private(set) var state: BluetoothScanningState

    init(scanner: BluetoothScannerAdapter = MockBluetoothScannerAdapter()) {
        self.scanner = scanner
        self.state = scanner.state
    }

    var title: String {
        "Nearby Devices"
    }

    var primaryActionTitle: String {
        isScanning ? "Stop Mock Scan" : "Start Mock Scan"
    }

    var primaryActionSystemImage: String {
        isScanning ? "stop.circle" : "magnifyingglass"
    }

    var isScanning: Bool {
        state.isScanning
    }

    var deviceRows: [ScanDeviceRow] {
        state.discoveredPeripherals.map { peripheral in
            ScanDeviceRow(
                id: peripheral.id,
                name: peripheral.displayName,
                rssiText: "\(peripheral.rssi) dBm"
            )
        }
    }

    var message: String {
        switch state {
        case .idle:
            return "Ready to scan. Real Bluetooth scanning will be added in a later change."
        case .scanning:
            return "Mock scanning..."
        case .empty:
            return "No mock peripherals found."
        case .discovered(let devices):
            return devices.count == 1 ? "1 mock peripheral found." : "\(devices.count) mock peripherals found."
        case .failed(let failure):
            switch failure {
            case .mockFailure(let message):
                return message
            }
        case .permissionRequired:
            return "Bluetooth permission is required for real scanning. Mock mode does not request it."
        case .bluetoothUnavailable:
            return "Bluetooth is unavailable. Mock mode can still show scan states."
        case .stopped:
            return "Mock scanning stopped."
        }
    }

    func startMockScan() {
        scanner.startMockScan()
        refreshState()
    }

    func stopMockScan() {
        scanner.stopMockScan()
        refreshState()
    }

    func showEmptyResult() {
        scanner.showEmptyResult()
        refreshState()
    }

    func showMockPeripherals(_ peripherals: [DiscoveredPeripheralSummary]) {
        scanner.showMockPeripherals(peripherals)
        refreshState()
    }

    func showPermissionRequired() {
        scanner.showPermissionRequired()
        refreshState()
    }

    func showBluetoothUnavailable() {
        scanner.showBluetoothUnavailable()
        refreshState()
    }

    func showFailure(_ message: String) {
        scanner.showFailure(message)
        refreshState()
    }

    private func refreshState() {
        state = scanner.state
    }
}
