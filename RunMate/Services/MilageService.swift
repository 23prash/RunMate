//
//  MilageService.swift
//  RunMate
//
//  Created by Prashant Pukale on 3/6/22.
//
import Foundation
import Combine
import CoreLocation

protocol MilageServiceProtocol {
    func onMilageUpdate() -> AnyPublisher<Double, Never>
}

final class MilageService: MilageServiceProtocol {
    private let locationService: LocationServiceProtocol
    private var lastLocation: CLLocation?
    private let milagePublisher: CurrentValueSubject<Double, Never> = .init(0)
    private var disposeBag: Set<AnyCancellable> = []
    init(locationService: LocationServiceProtocol) {
        self.locationService = locationService
        setup()
    }

    private func setup() {
        locationService
            .onLocationUpdate()
            .sink { [weak self] location in
                guard let self = self, let location = location else { return }
                guard let lastLocation = self.lastLocation else { self.lastLocation = location; return }
                let distance = location.distance(from: lastLocation)
                self.milagePublisher.send(distance)
            }.store(in: &disposeBag)
    }

    func onMilageUpdate() -> AnyPublisher<Double, Never> {
        return milagePublisher.eraseToAnyPublisher()
    }
}
