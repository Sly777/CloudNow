@testable import CloudNow
import XCTest

final class SmokeTests: XCTestCase {
    func test_testableReachesInternalSymbols() {
        XCTAssertEqual(SDPMunger.preferCodec("", codec: .h264), "")
        _ = InputEncoder()
    }
}
