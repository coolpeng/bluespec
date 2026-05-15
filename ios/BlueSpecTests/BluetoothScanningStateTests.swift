import XCTest
@testable import BlueSpec

final class BluetoothScanningStateTests: XCTestCase {
    func testAppShellStatesAreNotHardwareBacked() {
        XCTAssertFalse(BluetoothScanningState.idle.isHardwareBacked)
        XCTAssertFalse(BluetoothScanningState.mockScanning.isHardwareBacked)
        XCTAssertFalse(BluetoothScanningState.mockEmpty.isHardwareBacked)
    }

    func testMockAdapterTransitionsToEmptyState() {
        let adapter = MockBluetoothScannerAdapter()

        XCTAssertEqual(adapter.state, .idle)

        adapter.startMockScan()

        XCTAssertEqual(adapter.state, .mockEmpty)
    }
}
