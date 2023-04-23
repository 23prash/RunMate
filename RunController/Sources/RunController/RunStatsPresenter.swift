import Foundation
import Aryabhatta

/*
 Improve by factoring in Locale.
 */
protocol RunStatsPresenting {
    // output can be speech or text
    associatedtype OutputType
    func present(duration: Duration) -> OutputType
    func present(distance: Distance) -> OutputType
    func present(pace: Pace) -> OutputType
}

final class RunStatsTextualPresenter: RunStatsPresenting {
    func present(duration: Duration) -> String {
        return "\(duration.hours) : \(duration.mins) : \(duration.secs)"
    }
    func present(distance: Distance) -> String {
        return "\(distance.kilometers)"
    }
    func present(pace: Pace) -> String {
        return "\(pace.paceInKM)"
    }
}
