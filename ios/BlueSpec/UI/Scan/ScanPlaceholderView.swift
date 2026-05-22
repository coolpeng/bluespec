import SwiftUI

struct ScanPlaceholderView: View {
    @State var viewModel: ScanPlaceholderViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header

                controls

                deviceSection
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Color(.systemGroupedBackground))
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(viewModel.title)
                .font(.largeTitle)
                .fontWeight(.semibold)

            HStack(spacing: 8) {
                statusPill

                if viewModel.isScanning {
                    ProgressView()
                        .controlSize(.small)
                }
            }

            Text(viewModel.message)
                .font(.body)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var statusPill: some View {
        Text(stateLabel)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(.thinMaterial, in: Capsule())
    }

    private var controls: some View {
        HStack(spacing: 12) {
            Button {
                if viewModel.isScanning {
                    viewModel.stopMockScan()
                } else {
                    viewModel.startMockScan()
                }
            } label: {
                Label(viewModel.primaryActionTitle, systemImage: viewModel.primaryActionSystemImage)
            }
            .buttonStyle(.borderedProminent)

            Menu {
                Button {
                    viewModel.showEmptyResult()
                } label: {
                    Label("Empty", systemImage: "tray")
                }

                Button {
                    viewModel.showMockPeripherals(Self.samplePeripherals)
                } label: {
                    Label("Devices", systemImage: "dot.radiowaves.left.and.right")
                }

                Button {
                    viewModel.showFailure("Mock scan failed")
                } label: {
                    Label("Failure", systemImage: "exclamationmark.triangle")
                }

                Button {
                    viewModel.showPermissionRequired()
                } label: {
                    Label("Permission", systemImage: "lock")
                }

                Button {
                    viewModel.showBluetoothUnavailable()
                } label: {
                    Label("Unavailable", systemImage: "bolt.horizontal.circle")
                }
            } label: {
                Label("Mock State", systemImage: "slider.horizontal.3")
            }
            .buttonStyle(.bordered)
        }
    }

    private var deviceSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Devices")
                .font(.headline)

            if viewModel.deviceRows.isEmpty {
                ContentUnavailableView("No Devices", systemImage: "antenna.radiowaves.left.and.right")
                    .frame(maxWidth: .infinity, minHeight: 220)
                    .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8))
            } else {
                LazyVStack(spacing: 10) {
                    ForEach(viewModel.deviceRows) { row in
                        deviceRow(row)
                    }
                }
            }
        }
    }

    private func deviceRow(_ row: ScanDeviceRow) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "dot.radiowaves.left.and.right")
                .font(.title3)
                .foregroundStyle(.blue)
                .frame(width: 32, height: 32)

            VStack(alignment: .leading, spacing: 4) {
                Text(row.name)
                    .font(.body)
                    .fontWeight(.medium)

                Text(row.rssiText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 12)
        }
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8))
    }

    private var stateLabel: String {
        switch viewModel.state {
        case .idle:
            return "Idle"
        case .scanning:
            return "Scanning"
        case .empty:
            return "Empty"
        case .discovered:
            return "Discovered"
        case .failed:
            return "Failed"
        case .stopped:
            return "Stopped"
        case .permissionRequired:
            return "Permission Required"
        case .bluetoothUnavailable:
            return "Bluetooth Unavailable"
        }
    }

    private static let samplePeripherals = [
        DiscoveredPeripheralSummary(
            id: UUID(uuidString: "10000000-0000-0000-0000-000000000001")!,
            displayName: "BlueSpec Tag",
            rssi: -48
        ),
        DiscoveredPeripheralSummary(
            id: UUID(uuidString: "10000000-0000-0000-0000-000000000002")!,
            displayName: "Workbench Sensor",
            rssi: -62
        )
    ]
}

#Preview {
    ScanPlaceholderView(viewModel: ScanPlaceholderViewModel())
}
