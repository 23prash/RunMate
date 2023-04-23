import Foundation

public struct Pace {
    private let minTimeForPace: TimeInterval = 30
    let time: TimeInterval
    let meters: Double
    private var minutes: CGFloat {
        time / 60.0
    }
    private var distance: Distance {
        .init(meters: meters)
    }
    public var paceInMiles: Double {
        guard time > minTimeForPace else { return 0 }
        return minutes / distance.miles
    }
    public var paceInKM: Double {
        guard time > minTimeForPace else { return 0 }
        return minutes / distance.kilometers
    }
}
