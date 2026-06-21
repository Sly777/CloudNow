import CoreHaptics
import Foundation
import GameController

/// Gate for high-frequency rumble diagnostics. Flip `verbose` to true to stream
/// per-frame [Rumble] logs while debugging; default off (no console flood, no per-frame I/O).
nonisolated enum RumbleLog {
    static let verbose = false

    static func frame(_ message: @autoclosure () -> String) {
        if verbose { print(message()) }
    }
}

final nonisolated class ControllerHaptics {
    private final class Motor: @unchecked Sendable {
        let locality: GCHapticsLocality
        var engine: CHHapticEngine?
        var player: CHHapticPatternPlayer?
        var playing = false
        var loggedError = false
        var lastMagnitude: UInt16 = 0

        init(locality: GCHapticsLocality, engine: CHHapticEngine) {
            self.locality = locality
            self.engine = engine
        }

        func log(_ error: Error) {
            guard !loggedError else { return }

            print("[ControllerHaptics] \(locality.rawValue) error: \(error)")
            loggedError = true
        }
    }

    private let queue: DispatchQueue
    private let strongMotor: Motor?
    private let weakMotor: Motor?
    private let gain: Float

    init?(controller: GCController, queue: DispatchQueue, adjust: Double = 0) {
        let a = Float(max(-1, min(1, adjust)))
        gain = a >= 0 ? 1 + a * 1.5 : 1 + a * 0.7

        guard let haptics = controller.haptics else {
            print("[Rumble] controller has NO haptics")
            return nil
        }
        print("[Rumble] haptics localities=\(haptics.supportedLocalities.map(\.rawValue))")

        self.queue = queue
        strongMotor = Self.makeMotor(
            locality: GCHapticsLocality.leftHandle,
            haptics: haptics
        )
        weakMotor = Self.makeMotor(
            locality: GCHapticsLocality.rightHandle,
            haptics: haptics
        )

        if strongMotor == nil, weakMotor == nil {
            return nil
        }

        if let strongMotor {
            setHandlers(for: strongMotor)
        }
        if let weakMotor {
            setHandlers(for: weakMotor)
        }
    }

    /// Must be called on `queue`.
    func setMotors(strong: UInt16, weak: UInt16) {
        if let strongMotor {
            apply(strong, to: strongMotor)
        }
        if let weakMotor {
            apply(weak, to: weakMotor)
        }
    }

    /// On `queue`.
    func stop() {
        stop(strongMotor)
        stop(weakMotor)
    }

    /// On `queue`.
    func cleanup() {
        cleanup(strongMotor)
        cleanup(weakMotor)
    }

    private static func makeMotor(
        locality: GCHapticsLocality,
        haptics: GCDeviceHaptics
    ) -> Motor? {
        guard haptics.supportedLocalities.contains(locality),
              let engine = haptics.createEngine(withLocality: locality)
        else {
            return nil
        }

        do {
            try engine.start()
            print("[Rumble] engine \(locality.rawValue) started")
        } catch {
            print("[ControllerHaptics] \(locality.rawValue) error: \(error)")
            return nil
        }

        return Motor(locality: locality, engine: engine)
    }

    private func intensity(for magnitude: UInt16) -> Float {
        guard magnitude != 0 else { return 0 }
        // GFN magnitudes are mostly in the low 5-15% of u16, and the low-freq motor
        // must clear an activation threshold, so a linear map feels like a faint buzz.
        return min(1, powf(Float(magnitude) / 65535, 0.4) * gain)
    }

    private func setHandlers(for motor: Motor) {
        motor.engine?.stoppedHandler = { [weak self, weak motor] _ in
            self?.queue.async {
                motor?.player = nil
                motor?.playing = false
            }
        }
        motor.engine?.resetHandler = { [weak self, weak motor] in
            self?.queue.async {
                motor?.player = nil
                motor?.playing = false
                do {
                    try motor?.engine?.start()
                } catch {
                    motor?.log(error)
                }
            }
        }
    }

    private func apply(_ magnitude: UInt16, to motor: Motor) {
        guard magnitude != motor.lastMagnitude else { return }
        motor.lastMagnitude = magnitude

        if motor.player == nil {
            guard magnitude != 0 else { return }
            motor.player = makePlayer(for: motor)
            guard motor.player != nil else { return }
        }

        let value = intensity(for: magnitude)
        RumbleLog.frame("[Rumble] \(motor.locality.rawValue) mag=\(magnitude) intensity=\(value)")
        let parameter = CHHapticDynamicParameter(
            parameterID: .hapticIntensityControl,
            value: value,
            relativeTime: 0
        )
        do {
            try motor.player?.sendParameters([parameter], atTime: CHHapticTimeImmediate)
        } catch {
            motor.log(error)
        }

        if !motor.playing, magnitude != 0 {
            do {
                try motor.player?.start(atTime: 0)
                motor.playing = true
            } catch {
                motor.log(error)
            }
        }
    }

    private func makePlayer(for motor: Motor) -> CHHapticPatternPlayer? {
        let event = CHHapticEvent(
            eventType: .hapticContinuous,
            parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0),
            ],
            relativeTime: 0,
            duration: TimeInterval(Double(GCHapticDurationInfinite))
        )

        do {
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            return try motor.engine?.makePlayer(with: pattern)
        } catch {
            motor.log(error)
            return nil
        }
    }

    private func stop(_ motor: Motor?) {
        guard let motor else { return }

        do {
            try motor.player?.stop(atTime: 0)
        } catch {
            motor.log(error)
        }
        motor.playing = false
        motor.lastMagnitude = 0
    }

    private func cleanup(_ motor: Motor?) {
        guard let motor else { return }

        do {
            try motor.player?.cancel()
        } catch {
            motor.log(error)
        }
        motor.engine?.stop(completionHandler: nil)
        motor.player = nil
        motor.engine = nil
        motor.playing = false
        motor.lastMagnitude = 0
    }
}
