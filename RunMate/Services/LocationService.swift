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

final class LocationService: NSObject {
    
    private var currentLocationSubject: CurrentValueSubject<CLLocation?, Never> = .init(nil)
    private lazy var locationManager = CLLocationManager()

    // todo: ref
    func start(withAuthStatus status: LocationPermissionStatus) throws -> AnyPublisher<CLLocation?, Never> {
        guard status == .grantedPermission else { throw LocationServiceError.notAuthorised }
        setUpLocationManager()
        return currentLocationSubject.eraseToAnyPublisher()
    }

    func stop() {
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
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

