import CoreLocation
import Combine

public protocol LiveLocationServiceProtocol: Service, AnyObject {
    func start() throws
    func terminate() throws
    func pause() throws
    func resume() throws
    
    var onUpdate: ((CLLocation) -> Void)? { get set }
}

public enum LiveLocationServiceError: Error {
    case permissionError(canAsk: Bool)
    case invalidOperation
}

public final class LiveLocationService: NSObject, LiveLocationServiceProtocol {
    private lazy var locationManager = CLLocationManager()

    public private(set) var state: ServiceState = .notStarted
    public var onUpdate: ((CLLocation) -> Void)?
    
    public func start() throws {
        try state.transition(to: .start)
        guard locationManager.authorizationStatus.👍 else {
            throw LiveLocationServiceError.permissionError(canAsk: locationManager.authorizationStatus == .notDetermined)
        }
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    public func terminate() throws {
        try state.transition(to: .complete)
        locationManager.stopUpdatingLocation()
    }
    
    public func pause() throws {
        try state.transition(to: .pause)
        locationManager.delegate = nil
    }
    
    public func resume() throws {
        try state.transition(to: .resume)
        locationManager.delegate = self
    }
}

extension LiveLocationService: CLLocationManagerDelegate {
    
    // MARK: - Location Updates
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            onUpdate?(location)
        }
    }
}
