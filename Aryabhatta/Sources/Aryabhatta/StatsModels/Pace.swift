import Foundation

public struct Pace {
    let time: TimeInterval
    let meters: Double
    private var minutes: CGFloat {
        time / 60.0
    }
    private var distance: Distance {
        .init(meters: meters)
    }
    public var paceInMiles: Double {
        return minutes / distance.miles
    }
    public var paceInKM: Double {
        return minutes / distance.kilometers
    }
}
