// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/

import AVFoundation
import CAudioKitEX
import AudioKit

public class MonoFader: Node {

    let input: Node
    
    /// Connected nodes
    public var connections: [Node] { [input] }

    /// Underlying AVAudioNode
    public var avAudioNode = instantiate(effect: "mfdr")

    // MARK: - Parameters

    /// Allow gain to be any non-negative number
    public static let gainRange: ClosedRange<AUValue> = 0.0 ... Float.greatestFiniteMagnitude

    /// Specification details for gain
    public static let gainDef = NodeParameterDef(
        identifier: "gain",
        name: "Gain",
        address: akGetParameterAddress("MonoFaderParameterGain"),
        defaultValue: 1,
        range: MonoFader.gainRange,
        unit: .linearGain)

    /// Amplification Factor
    @Parameter(gainDef) public var gain: AUValue

    /// Amplification Factor in db - 0 is unity (gain = 1.0)
    public var dB: AUValue {
        set { gain = pow(10.0, newValue / 20.0) }
        get { return 20.0 * log10(gain) }
    }

    // MARK: - Initialization

    /// Initialize this fader node
    ///
    /// - Parameters:
    ///   - input: Node whose output will be amplified
    ///   - gain: Amplification factor (Default: 1, Minimum: 0)
    ///
    public init(_ input: Node, gain: AUValue = 1) {
        self.input = input
        
        setupParameters()
        
        self.gain = gain
    }

    deinit {
        // Log("* { Fader }")
    }

    // MARK: - Automation

    /// Gain automation helper
    /// - Parameters:
    ///   - events: List of events
    ///   - startTime: start time
    public func automateGain(events: [AutomationEvent], startTime: AVAudioTime? = nil) {
        $gain.automate(events: events, startTime: startTime)
    }

    /// Stop automation
    public func stopAutomation() {
        $gain.stopAutomation()
    }
}
