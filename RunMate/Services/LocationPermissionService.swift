import Foundation
import CoreLocation
import Combine

enum LocationPermissionStatus: Equatable {
    case needToAsk
    case grantedPermission
    case deniedPermission
    
    static func from(status: CLAuthorizationStatus) -> Self {
        switch status {
        case .notDetermined:
            return .needToAsk
        case .restricted:
            return .deniedPermission
        case .denied:
            return .deniedPermission
        case .authorizedAlways:
            return .grantedPermission
        case .authorizedWhenInUse:
            return .grantedPermission
        case .authorized:
            return .grantedPermission
        @unknown default:
            assertionFailure("location auth status \(status) not handled")
            return .needToAsk
        }
    }
}

final class LocationPermissionService: NSObject {
    
    private let clManager = CLLocationManager()
    private lazy var currentStatusSubject: CurrentValueSubject<LocationPermissionStatus, Never> = {
        return .init(.from(status: clManager.authorizationStatus))
    }()
    
    @discardableResult
    func askPermission() -> AnyPublisher<LocationPermissionStatus, Never> {
        if currentStatusSubject.value == .needToAsk {
            clManager.delegate = self
            clManager.requestWhenInUseAuthorization()
        }
        return currentStatusSubject.eraseToAnyPublisher()
    }
}

extension LocationPermissionService: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        currentStatusSubject.send(.from(status: manager.authorizationStatus))
    }
    
}
