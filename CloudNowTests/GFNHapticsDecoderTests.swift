@testable import CloudNow
import XCTest

/// These prove self-consistency with our reading of the GFN/OpenNOW format, NOT protocol correctness (no live capture). Protocol correctness is confirmed by on-device hardware QA.
final class GFNHapticsDecoderTests: XCTestCase {
    func testBareLegacyPacketDecodesRumbleCommand() {
        let data = Data([0x0B, 0x01, 0x01, 0x00, 0x06, 0x00, 0x02, 0x00, 0x34, 0x12, 0x78, 0x56])

        XCTAssertEqual(
            GFNHapticsDecoder.decode(data),
            RumbleCommand(controllerId: 2, weak: 0x1234, strong: 0x5678)
        )
    }

    func testWrappedLegacyPacketDecodesRumbleCommand() {
        let data = Data([0x22, 0x0B, 0x01, 0x00, 0x00, 0x01, 0x00, 0x06, 0x00, 0x01, 0x00, 0x11, 0x11, 0x22, 0x22])

        XCTAssertEqual(
            GFNHapticsDecoder.decode(data),
            RumbleCommand(controllerId: 1, weak: 0x1111, strong: 0x2222)
        )
    }

    func testWrappedOcPacketDecodesHighByteMagnitudes() {
        let data = Data([0x22, 0x11, 0x00, 0x00, 0x00, 0x07, 0x00, 0x00, 0x05, 0x00, 0x00, 0x00, 0xAB, 0xCD])

        XCTAssertEqual(
            GFNHapticsDecoder.decode(data),
            RumbleCommand(controllerId: 1, weak: 0xAB00, strong: 0xCD00)
        )
    }

    func testTruncatedLegacyPacketReturnsNil() {
        let data = Data([0x0B, 0x01, 0x01, 0x00, 0x06, 0x00, 0x02])

        XCTAssertNil(GFNHapticsDecoder.decode(data))
    }

    func testLegacyPacketWithUnexpectedKindReturnsNil() {
        let data = Data([0x0B, 0x01, 0x02, 0x00, 0x06, 0x00, 0x02, 0x00, 0x34, 0x12, 0x78, 0x56])

        XCTAssertNil(GFNHapticsDecoder.decode(data))
    }

    func testHandshakeFirstWordReturnsNilThroughLegacyKindCheck() {
        let data = Data([0x0E, 0x02, 0x01, 0x00, 0x06, 0x00, 0x02, 0x00, 0x34, 0x12])

        XCTAssertNil(GFNHapticsDecoder.decode(data))
    }

    func testFrameStartingWithHandshakeByteReturnsNilThroughLegacyKindCheck() {
        let data = Data([0x0E, 0x00, 0x06, 0x00, 0x03, 0x00, 0x0F, 0x00, 0xF0, 0x00])

        XCTAssertNil(GFNHapticsDecoder.decode(data))
    }

    func testIgnoredWrappersReturnNil() {
        XCTAssertNil(GFNHapticsDecoder.decode(Data([0x21, 0x00])))
        XCTAssertNil(GFNHapticsDecoder.decode(Data([0x23, 0x00])))
    }

    func testBareKindFirstLegacyPacketDecodesViaDefaultArm() {
        let data = Data([0x01, 0x00, 0x06, 0x00, 0x03, 0x00, 0x0F, 0x00, 0xF0, 0x00])

        XCTAssertEqual(
            GFNHapticsDecoder.decode(data),
            RumbleCommand(controllerId: 3, weak: 0x000F, strong: 0x00F0)
        )
    }
}
