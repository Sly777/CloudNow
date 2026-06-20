@testable import CloudNow
import XCTest

final class InputEncoderPerfTests: XCTestCase {
    private var encoder: InputEncoder!
    private var packet: EncodedInputPacket!

    override func setUp() {
        super.setUp()
        encoder = InputEncoder()
        packet = EncodedInputPacket()
    }

    override func tearDown() {
        packet = nil
        encoder = nil
        super.tearDown()
    }

    func testEncodeGamepadV2Performance() {
        let opts = XCTMeasureOptions()
        opts.iterationCount = 10
        var consumedByteCount = 0

        measure(metrics: [XCTClockMetric()], options: opts) {
            for _ in 0 ..< PerfScale.encoderInnerLoop {
                encoder.encodeGamepad(
                    controllerId: 0,
                    buttons: 0xFFFF,
                    leftTrigger: 200,
                    rightTrigger: 50,
                    leftStickX: 12000,
                    leftStickY: -8000,
                    rightStickX: 100,
                    rightStickY: -100,
                    gamepadBitmap: 0b0001,
                    into: packet
                )
                consumedByteCount &+= packet.count
            }
        }

        XCTAssertGreaterThan(consumedByteCount, 0)
    }

    func testEncodeGamepadV3Performance() {
        let encoder = InputEncoder()
        encoder.setProtocolVersion(3)
        let opts = XCTMeasureOptions()
        opts.iterationCount = 10
        var consumedByteCount = 0

        measure(metrics: [XCTClockMetric()], options: opts) {
            for _ in 0 ..< PerfScale.encoderInnerLoop {
                encoder.encodeGamepad(
                    controllerId: 0,
                    buttons: 0xFFFF,
                    leftTrigger: 200,
                    rightTrigger: 50,
                    leftStickX: 12000,
                    leftStickY: -8000,
                    rightStickX: 100,
                    rightStickY: -100,
                    gamepadBitmap: 0b0001,
                    into: packet
                )
                consumedByteCount &+= packet.count
            }
        }

        XCTAssertGreaterThan(consumedByteCount, 0)
    }

    func testEncodeMouseMovePerformance() {
        let opts = XCTMeasureOptions()
        opts.iterationCount = 10
        var consumedByteCount = 0

        measure(metrics: [XCTClockMetric()], options: opts) {
            for _ in 0 ..< PerfScale.encoderInnerLoop {
                encoder.encodeMouseMove(dx: 12, dy: -7, into: packet)
                consumedByteCount &+= packet.count
            }
        }

        XCTAssertGreaterThan(consumedByteCount, 0)
    }

    func testEncodeMouseButtonPerformance() {
        let opts = XCTMeasureOptions()
        opts.iterationCount = 10
        var consumedByteCount = 0

        measure(metrics: [XCTClockMetric()], options: opts) {
            for _ in 0 ..< PerfScale.encoderInnerLoop {
                encoder.encodeMouseButton(down: true, button: 1, into: packet)
                consumedByteCount &+= packet.count
            }
        }

        XCTAssertGreaterThan(consumedByteCount, 0)
    }

    func testEncodeMouseWheelPerformance() {
        let opts = XCTMeasureOptions()
        opts.iterationCount = 10
        var consumedByteCount = 0

        measure(metrics: [XCTClockMetric()], options: opts) {
            for _ in 0 ..< PerfScale.encoderInnerLoop {
                encoder.encodeMouseWheel(delta: 3, into: packet)
                consumedByteCount &+= packet.count
            }
        }

        XCTAssertGreaterThan(consumedByteCount, 0)
    }

    func testEncodeKeyboardPerformance() {
        let opts = XCTMeasureOptions()
        opts.iterationCount = 10
        var consumedByteCount = 0

        measure(metrics: [XCTClockMetric()], options: opts) {
            for _ in 0 ..< PerfScale.encoderInnerLoop {
                encoder.encodeKeyboard(down: true, vk: 0x41, scancode: 0x1E, modifiers: 0, into: packet)
                consumedByteCount &+= packet.count
            }
        }

        XCTAssertGreaterThan(consumedByteCount, 0)
    }
}
