@testable import CloudNow
import XCTest

final class SDPMungerPerfTests: XCTestCase {
    func testPreferCodecH264Performance() {
        let sdp = makeOfferSDP()
        let sanity = SDPMunger.preferCodec(sdp, codec: .h264)
        XCTAssertFalse(sanity.isEmpty)

        let opts = XCTMeasureOptions()
        opts.iterationCount = 10
        var consumedByteCount = 0

        measure(metrics: [XCTClockMetric()], options: opts) {
            for _ in 0 ..< PerfScale.sdpInnerLoop {
                let result = SDPMunger.preferCodec(sdp, codec: .h264)
                consumedByteCount &+= result.utf8.count
            }
        }

        XCTAssertGreaterThan(consumedByteCount, 0)
    }

    func testPreferCodecH265Performance() {
        let sdp = makeOfferSDP()
        let sanity = SDPMunger.preferCodec(sdp, codec: .h265)
        XCTAssertFalse(sanity.isEmpty)

        let opts = XCTMeasureOptions()
        opts.iterationCount = 10
        var consumedByteCount = 0

        measure(metrics: [XCTClockMetric()], options: opts) {
            for _ in 0 ..< PerfScale.sdpInnerLoop {
                let result = SDPMunger.preferCodec(sdp, codec: .h265)
                consumedByteCount &+= result.utf8.count
            }
        }

        XCTAssertGreaterThan(consumedByteCount, 0)
    }

    func testInjectBandwidthPerformance() {
        let sdp = makeOfferSDP()
        let sanity = SDPMunger.injectBandwidth(sdp, videoKbps: 35000)
        XCTAssertFalse(sanity.isEmpty)

        let opts = XCTMeasureOptions()
        opts.iterationCount = 10
        var consumedByteCount = 0

        measure(metrics: [XCTClockMetric()], options: opts) {
            for _ in 0 ..< PerfScale.sdpInnerLoop {
                let result = SDPMunger.injectBandwidth(sdp, videoKbps: 35000)
                consumedByteCount &+= result.utf8.count
            }
        }

        XCTAssertGreaterThan(consumedByteCount, 0)
    }

    func testRewriteH265TierFlagPerformance() {
        let sdp = makeOfferSDP()
        let sanity = SDPMunger.rewriteH265TierFlag(sdp)
        XCTAssertFalse(sanity.isEmpty)

        let opts = XCTMeasureOptions()
        opts.iterationCount = 10
        var consumedByteCount = 0

        measure(metrics: [XCTClockMetric()], options: opts) {
            for _ in 0 ..< PerfScale.sdpInnerLoop {
                let result = SDPMunger.rewriteH265TierFlag(sdp)
                consumedByteCount &+= result.utf8.count
            }
        }

        XCTAssertGreaterThan(consumedByteCount, 0)
    }

    func testRewriteH265LevelIdPerformance() {
        let sdp = makeOfferSDP()
        let sanity = SDPMunger.rewriteH265LevelId(sdp)
        XCTAssertFalse(sanity.isEmpty)

        let opts = XCTMeasureOptions()
        opts.iterationCount = 10
        var consumedByteCount = 0

        measure(metrics: [XCTClockMetric()], options: opts) {
            for _ in 0 ..< PerfScale.sdpInnerLoop {
                let result = SDPMunger.rewriteH265LevelId(sdp)
                consumedByteCount &+= result.utf8.count
            }
        }

        XCTAssertGreaterThan(consumedByteCount, 0)
    }
}
