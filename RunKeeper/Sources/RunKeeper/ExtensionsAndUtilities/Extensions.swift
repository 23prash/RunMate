import CoreLocation

extension CLAuthorizationStatus {
    var 👍: Bool { self == .authorizedAlways || self == .authorizedWhenInUse }
    var 👎: Bool { !👍 }
}

