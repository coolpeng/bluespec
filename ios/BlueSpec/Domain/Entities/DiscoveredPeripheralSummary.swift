import Foundation

struct DiscoveredPeripheralSummary: Equatable, Identifiable {
    let id: UUID
    let displayName: String
    let rssi: Int

    init(id: UUID, displayName: String, rssi: Int) {
        self.id = id
        self.displayName = displayName
        self.rssi = rssi
    }
}
