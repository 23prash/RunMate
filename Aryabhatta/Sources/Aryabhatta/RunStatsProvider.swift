import DataCenter
import Foundation
import CoreLocation
import Combine
import os.log

public final class RunStatsProvider {
    private let run: Run
    private var metersCovered: Double = 0
    private var cancellable = Set<AnyCancellable>()
    private var markers: [MileStoneMarker] = [.init(kind: .km(1), startIndex: 0, startDuration: .init(with: 0)),
                                              .init(kind: .mi(1), startIndex: 0, startDuration: .init(with: 0))]
    
    public init(run: Run) {
        self.run = run
        metersCovered = self.metersCovered(by: run.locations)
        run.$locations
            .sink { loc in
                self.update(for: loc)
            }.store(in: &cancellable)
    }
    
    public var duration: Duration {
        .init(with: run.duration())
    }
    
    public var avgPace: Pace {
        .init(time: run.duration(), meters: metersCovered)
    }
    
    public var currentPace: Pace {
        let interval: TimeInterval = 10
        let distance = metersCovered(inLast: interval)
        return .init(time: interval, meters: distance)
    }
    
    public var distance: Distance {
        .init(meters: metersCovered)
    }
    
    public func kmSplits() -> [Pace] {
        markers.compactMap { _marker in
            var marker = _marker
            guard case .km = marker.kind else { return nil }
            return marker.split
        }
    }
    
    public func completeRun() {
        completeAllMarkers()
    }
    
    private func update(for locations: [CLLocation]) {
        metersCovered += metersCovered(by: Array(locations.suffix(2)))
        updateMarkers(for: locations)
    }
    
    private func updateMarkers(for locations: [CLLocation]) {
        var markersToAppend = [MileStoneMarker]()
        markers = markers.map({ _marker in
            var marker = _marker
            guard marker.endIndex == nil else { return marker }
            if marker.tryComplete(meters: metersCovered, duration: duration, endIndex: locations.endIndex) {
                os_log("Marker completed at %@", metersCovered)
                if let next = marker.next() {
                    markersToAppend.append(next)
                } else {
                    os_log("Invalid state next marker not found.", type: .error)
                }
            }
            return marker
        })
        markers.append(contentsOf: markersToAppend)
    }
    
    private func completeAllMarkers() {
        markers = markers.map({ _marker in
            var marker = _marker
            guard marker.isCompleted else {
                marker.forceComplete(meters: metersCovered, duration: duration, endIndex: run.locations.endIndex)
                return marker
            }
            return marker
        })
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
    
    private func metersCovered(inLast time: TimeInterval = 10.0) -> Double {
        guard let lastRunLocationTime = run.locations.last?.timestamp else { return 0 }
        guard let indexOfFirstLocation = run.locations.firstIndex(where: { location in
            lastRunLocationTime.timeIntervalSince(location.timestamp) <= time
        }) else { return 0 }
        
        let timeStampAtFirstIndex = run.locations[indexOfFirstLocation].timestamp
        // if resumed within last timeInterval.
        if run.lastResumeTime.timeIntervalSince(timeStampAtFirstIndex) > 0  {
            return 0
        } else {
            return metersCovered(by: Array(run.locations.suffix(from: indexOfFirstLocation)))
        }
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
