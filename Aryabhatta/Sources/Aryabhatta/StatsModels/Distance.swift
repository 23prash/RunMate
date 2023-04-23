import Foundation

public struct Distance {
    let meters: CGFloat
    public var miles: CGFloat {
        0.000621 * meters
    }
    public var kilometers: CGFloat {
        meters / 1000
    }
}
