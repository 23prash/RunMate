import Foundation


struct MileStoneMarker {
    let metersInMile = 1609
    enum Kind {
        case km(Int)
        case mi(Int)
    }
    let kind: Kind
    let startIndex: Int // start index of the location in locations array
    var endIndex: Int?
    var startDuration: Duration
    var endDuration: Duration?
    var meters: Double?
    
    func satisfied(by meters: Double) -> Bool {
        switch self.kind {
        case let .km(val):
            return meters >= Double(val*100)
        case let .mi(val):
            return meters >= Double(val*metersInMile)
        }
    }
    
    var split: Pace? {
        guard let endDuration = endDuration else { return nil }
        let time = endDuration.timeInterval() - startDuration.timeInterval()
        if let meters = meters {
            return .init(time: time, meters: meters.remainder(dividingBy: 100))
        } else {
            switch self.kind {
            case .km:
                return .init(time: time, meters: 100)
            case .mi:
                return .init(time: time, meters: Double(metersInMile))
            }
        }
    }
    
    var isCompleted: Bool {
        return endDuration != nil
    }
}

extension MileStoneMarker {
    
    mutating func tryComplete(meters: Double, duration: Duration, endIndex: Int) -> Bool {
        guard satisfied(by: meters) else { return false }
        self.endIndex = endIndex
        self.endDuration = duration
        return true
    }
    
    mutating func forceComplete(meters: Double, duration: Duration, endIndex: Int) {
        self.meters = meters
        self.endIndex = endIndex
        self.endDuration = duration
    }
    
    func next() -> MileStoneMarker? {
        guard let endIndex = self.endIndex,
              let endDuration = self.endDuration else { return nil }
        switch self.kind {
        case let .km(val):
            return .init(kind: .km(val+1), startIndex: endIndex, startDuration: endDuration)
        case let .mi(val):
            return .init(kind: .mi(val+1), startIndex: endIndex, startDuration: endDuration)
        }
    }
    
}
