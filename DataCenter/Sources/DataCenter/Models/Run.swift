import Foundation
import CoreLocation
import Combine

public final class Run {
    private(set) var isPaused: Bool = false
    private var lastResumeTime: Date = .now
    private var _duration: TimeInterval = 0
    
    @Published public private(set) var locations: [CLLocation] = []
    public let startTime: Date = .now
    public init() {}
    
    public func duration() -> TimeInterval {
        guard !isPaused else { return _duration }
        return _duration + Date.now.timeIntervalSince(lastResumeTime)
    }
    
    public func pause() {
        guard isPaused == false else { return }
        defer {
            isPaused.toggle()
        }
        _duration += Date.now.timeIntervalSince(lastResumeTime)
    }
    
    public func resume() {
        guard isPaused else { return }
        defer {
            isPaused.toggle()
        }
        lastResumeTime = .now
    }
    
    public func append(location: CLLocation) {
        self.locations.append(location)
    }
}
