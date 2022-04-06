//
//  PaceService.swift
//  RunMate
//
//  Created by Prashant Pukale on 3/13/22.
//

import Combine
import CoreLocation

final class PaceService {
    @Published private(set) var pace: Double = 0
    private let locationSevice: LocationServiceProtocol
    private var disposeBag = Set<AnyCancellable>()
    private let size = 5
    private var locations = [CLLocation]()
    init(locationSevice: LocationServiceProtocol) {
        self.locationSevice = locationSevice
        setup()
    }
    private func setup() {
        locationSevice.onLocationUpdate()
            .map { location -> Double in
                guard let location = location else { return self.pace }
                guard self.locations.count == self.size else {
                    self.locations.append(location)
                    return self.pace
                }

                self.locations.append(location)
                var distance: Double = 0
                for i in 1..<self.locations.count {
                    distance += self.locations[i].distance(from: self.locations[i-1])
                }
                guard let lastTime = self.locations.last?.timestamp else {
                    return self.pace
                }
                guard let firstTime = self.locations.first?.timestamp else {
                    return self.pace
                }

                self.locations = Array(self.locations.dropFirst())

                return Calculations.avgPace(distance: distance,
                                            timeInterval: lastTime.timeIntervalSince(firstTime))

            }.assign(to: \.pace, on: self)
            .store(in: &disposeBag)
    }
}
