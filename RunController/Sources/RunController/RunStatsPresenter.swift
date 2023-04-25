import Foundation
import Aryabhatta

/*
 Improve by factoring in Locale and settings.
 */
protocol RunStatsPresenting {
    // output can be speech or text
    associatedtype OutputType
    func present(duration: Duration) -> OutputType
    func present(distance: Distance) -> OutputType
    func present(pace: Pace) -> OutputType
}

final class RunStatsTextualPresenter: RunStatsPresenting {
    private lazy var numFormatter: NumberFormatter = {
       let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter
    }()
    private lazy var paceFormatter = PaceFormatter()
    
    func present(duration: Duration) -> String {
        if duration.hours > 0 {
            return String(format: "%02d:%02d:%02d", duration.hours, duration.mins, duration.secs)
        } else {
            return String(format: "%02d:%02d",duration.mins, duration.secs)
        }
    }
    
    func present(distance: Distance) -> String {
        return numFormatter.string(from: .init(floatLiteral: distance.kilometers)) ?? "-"
    }
    
    func present(pace: Pace) -> String {
        return paceFormatter.string(for: pace)
    }
}

public struct PaceFormatter {
    public enum Unit {
        case kmMin
        case miMin
    }
    public let unit: Unit = .kmMin
    public init() {}
    public func string(for pace: Pace) -> String {
        var val: Double
        switch unit {
        case .kmMin:
            val = pace.paceInKM
        case .miMin:
            val = pace.paceInMiles
        }
        guard val.isNaN == false && val.isFinite else { return "-" }
        let mins = Int(val)
        let secs = Int(60.0 * val.truncatingRemainder(dividingBy: 1))
        return String(format: "%d:%02d", mins, secs)
    }
}
