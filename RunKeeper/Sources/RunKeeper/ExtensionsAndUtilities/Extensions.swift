import CoreLocation

extension CLAuthorizationStatus {
    var 👍: Bool { self == .authorizedAlways }
    var 👎: Bool { !👍 }
}

