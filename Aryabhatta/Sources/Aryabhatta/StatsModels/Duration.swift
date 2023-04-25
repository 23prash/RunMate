import Foundation

public struct Duration {
    public let hours: Int
    public let mins: Int
    public let secs: Int
}

extension Duration {
    init(with timeInterval: TimeInterval) {
        let time = NSInteger(timeInterval)
        self.secs = time % 60
        self.mins = (time / 60) % 60
        self.hours = (time / 3600)
    }
    
    func timeInterval() -> TimeInterval {
        return Double((hours * 3600) + (mins * 60) + secs)
    }
}
