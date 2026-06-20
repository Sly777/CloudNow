import XCTest
@testable import CloudNow

final class SmokeTests: XCTestCase {
    func test_testableReachesInternalSymbols() {
        XCTAssertEqual(SDPMunger.preferCodec("", codec: .h264), "")
        _ = InputEncoder()
    }
}
