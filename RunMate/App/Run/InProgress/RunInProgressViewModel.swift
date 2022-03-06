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

    private let locationService: LocationServiceProtocol
    private let milageService: MilageServiceProtocol
    private let timerService: TimerProtocol
    private var latestLocation: CLLocation?
    private var disposeBag = Set<AnyCancellable>()
    private var startDate: Date?
    private var distance3SecAgo: Double = 0.0
    private var currentRunMilage: Double = 0.0 {
        didSet {
            distance = String(format: "%0.2f", currentRunMilage/1000)
        }
    }

    init(locationService: LocationServiceProtocol = LocationService(),
         timerService: TimerProtocol = RMTimer()) {
        self.locationService = locationService
        self.timerService = timerService
        self.milageService = MilageService(locationService: locationService)
    }

    func start() throws {
        startDate = .init()
        timerService.start()
            .sink { [weak self] in
            guard let self = self else { return }
            self.secs += 1
            self.time = self.secs.stringFromTimeInterval()
            if self.secs.truncatingRemainder(dividingBy: 3) == 0 {
                let distanceInKm = (self.currentRunMilage - self.distance3SecAgo)/1000
                let mins: Double = 3.0/60.0
                self.currentPace = String(format: "%0.2f", mins/distanceInKm)
                self.distance3SecAgo = self.currentRunMilage
            }
        }.store(in: &disposeBag)

        milageService
            .onMilageUpdate()
            .sink { milage in
                self.currentRunMilage = milage
                let mins: Double = Double(self.secs/60)
                let distanceInKm = self.currentRunMilage/1000
                if distanceInKm != 0 {
                    self.pace = String(format: "%0.2f", mins/distanceInKm)
                }
            }.store(in: &disposeBag)
    }

    func pause() {
        paused = true
        timerService.pause(true)
        locationService.pause(true)
    }

    func `continue`() {
        paused = false
        timerService.pause(false)
        locationService.pause(true)
    }

    func finish(router: AppRouter) {
        locationService.stop()
        RunDataService().save(run: .init(distance: currentRunMilage, start: startDate ?? Date(), time: secs))
        router.go(to: .history, in: .history)
    }
}
