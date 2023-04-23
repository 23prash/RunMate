import DataCenter
import Foundation
import CoreLocation
import Combine

public final class RunStatsProvider {
    private let run: Run
    private var metersCovered: Double = 0
    private var cancellable = Set<AnyCancellable>()
    public init(run: Run) {
        self.run = run
        metersCovered = self.metersCovered(by: run.locations)
        run.$locations
            .sink { loc in
                self.updateMilage(for: loc)
            }.store(in: &cancellable)
    }
    
    public var duration: Duration {
        .init(with: run.duration())
    }
    
    public var pace: Pace {
        .init(time: run.duration(), meters: metersCovered)
    }
    
    public var distance: Distance {
        .init(meters: metersCovered)
    }
    
    private func updateMilage(for locations: [CLLocation]) {
        metersCovered = metersCovered(by: Array(locations.suffix(2)))
    }
    
    private func metersCovered(by points: [CLLocation]) -> Double {
        var result: Double = 0
        guard points.count >= 2 else { return result }
        for i in 0..<points.count-1 {
            let first = points[i]
            let second = points[i+1]
            result += distanceBetweenCoordinates(lat1: first.coordinate.latitude, lon1: first.coordinate.longitude,
                                                 lat2: second.coordinate.latitude, lon2: second.coordinate.longitude)
        }
        return result
    }
    
    private func distanceBetweenCoordinates(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double {
        let earthRadius = 6371000.0 // Earth's radius in meters
        let dLat = (lat2 - lat1) * .pi / 180.0
        let dLon = (lon2 - lon1) * .pi / 180.0
        let a = sin(dLat / 2) * sin(dLat / 2) + cos(lat1 * .pi / 180.0) * cos(lat2 * .pi / 180.0) * sin(dLon / 2) * sin(dLon / 2)
        let c = 2 * atan2(sqrt(a), sqrt(1 - a))
        let distance = earthRadius * c
        return distance
    }

}
