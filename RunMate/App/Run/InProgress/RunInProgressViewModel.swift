import Foundation
import CoreLocation
import Combine
import OSLog

enum Measurement {
    case distance(Float)
    case time(TimeInterval)
    case pace(Float)
}

struct MeasurementFormatter {
    let measurement: Measurement

    var unitString: String {
        switch measurement {
        case .distance:
            return "km" //todo: based on pref/locale
        case .time:
            // time has many units based on interval.
            assertionFailure("unsupported api")
            return "NA"
        case .pace:
            return "mins/km"
        }
    }

    var formattedString: String {
        switch measurement {
        case .distance:
            return "\(valueString) \(unitString)"
        case .time(let timeInterval):
            return "\(timeInterval.stringFromTimeInterval())"
        case .pace:
            return "\(valueString) \(unitString)"
        }
    }

    var valueString: String {
        switch measurement {
        case .distance(let val):
            return String(format: "%0.2f", val)
        case .time(let timeInterval):
            return String(format: "%0.2f", timeInterval)
        case .pace(let pace):
            return String(format: "%0.2f", pace)
        }
    }
}

final class RunInProgressViewModel: ObservableObject {
    @Published var time: String = "0.00"
    @Published var distance: String = "0.0Km"
    @Published var pace: String = "..."
    @Published var currentPace: String = "..."
    @Published private(set) var paused = false

    private var secs: TimeInterval = 0
    private let timer = Timer.publish(every: 1.0,
                                      on: .main,
                                      in: .common).autoconnect()

    private let locationService = LocationService()
    private var latestLocation: CLLocation?
    private var disposeBag = Set<AnyCancellable>()
    private var startDate: Date?
    private var distance3SecAgo: Float = 0.0
    private var currentRunMilage: Float = 0.0 {
        didSet {
            distance = String(format: "%0.2f", currentRunMilage/1000)
        }
    }

    func start() throws {
        startDate = .init()
        timer.sink { [weak self] _ in
            guard let self = self, !self.paused else { return }
            self.secs += 1
            self.time = self.secs.stringFromTimeInterval()
            if self.secs.truncatingRemainder(dividingBy: 3) == 0 {
                let distanceInKm = (self.currentRunMilage - self.distance3SecAgo)/1000
                let mins: Float = 3.0/60.0
                self.currentPace = String(format: "%0.2f", mins/distanceInKm)
                self.distance3SecAgo = self.currentRunMilage
            }
        }.store(in: &disposeBag)

        try locationService.start(withAuthStatus: .grantedPermission)
            .sink { [weak self] location in
                guard let self = self else { return }
                guard !self.paused else { self.latestLocation = location; return }
                guard let lastLocation = self.latestLocation else { self.latestLocation = location; return }

                let distance = location?.distance(from: lastLocation)
                self.currentRunMilage += Float(distance?.magnitude ?? 0)
                self.latestLocation = location

                let mins: Float = Float(self.secs/60)
                let distanceInKm = self.currentRunMilage/1000
                if distanceInKm != 0 {
                    self.pace = String(format: "%0.2f", mins/distanceInKm)
                }

                os_log(.debug, "Location update recieved: Milage is \(self.currentRunMilage))")
            }.store(in: &disposeBag)
    }

    func pause() {
        paused = true
    }

    func `continue`() {
        paused = false
    }

    func finish(router: AppRouter) {
        RunDataService().save(run: .init(distance: currentRunMilage, start: startDate ?? Date(), time: secs))
        router.go(to: .history, in: .history)
    }
}
