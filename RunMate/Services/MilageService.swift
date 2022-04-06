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
    func start() throws -> AnyPublisher<Double, Never>
    func pause(_ enable: Bool)
}

final class MilageService: MilageServiceProtocol {
    private let locationService: LocationServiceProtocol
    private var lastLocation: CLLocation?
    private(set) var currentMilage: Double = 0.0
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
                let delta = location.distance(from: lastLocation)
                self.currentMilage += delta
                self.milagePublisher.send(self.currentMilage)
                self.lastLocation = location
            }.store(in: &disposeBag)
    }

    func onMilageUpdate() -> AnyPublisher<Double, Never> {
        return milagePublisher.eraseToAnyPublisher()
    }
    @discardableResult
    func start() throws ->  AnyPublisher<Double, Never> {
        _ = try locationService.start()
        return milagePublisher.eraseToAnyPublisher()
    }
    func pause(_ enable: Bool) {
        locationService.pause(enable)
    }
}
