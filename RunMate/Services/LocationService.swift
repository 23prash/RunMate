//
//  LocationService.swift
//  RunMate
//
//  Created by Prashant Pukale on 7/18/21.
//

import CoreLocation
import Combine
import os.log

enum LocationServiceError: Error {
    case notAuthorised
}

protocol LocationServiceProtocol {
    func onLocationUpdate() -> AnyPublisher<CLLocation?, Never>
    func start() throws -> AnyPublisher<CLLocation?, Never>
    func stop()
    func pause(_ pause: Bool)
}

final class LocationService: NSObject, LocationServiceProtocol {
    
    private var currentLocationSubject: CurrentValueSubject<CLLocation?, Never> = .init(nil)
    private lazy var locationManager = CLLocationManager()

    func start() throws -> AnyPublisher<CLLocation?, Never> {
        guard locationManager.authorizationStatus.👍 else { throw LocationServiceError.notAuthorised }
        setUpLocationManager()
        return currentLocationSubject.eraseToAnyPublisher()
    }

    func pause(_ pause: Bool) {
        if pause {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
        } else {
            locationManager.startUpdatingLocation()
            locationManager.delegate = self
        }
    }

    func stop() {
        pause(true)
        currentLocationSubject.send(completion: .finished)
    }

    func onLocationUpdate() -> AnyPublisher<CLLocation?, Never> {
        return currentLocationSubject.eraseToAnyPublisher()
    }

    private func setUpLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
}

extension LocationService: CLLocationManagerDelegate {
    
    // MARK: - Location Updates
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            currentLocationSubject.send(location)
            os_log(.debug, "recieved location update")
        }
    }
}
