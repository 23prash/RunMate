import Foundation
import CoreLocation
import Combine
import OSLog
import SwiftUI

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
    private let paceService: PaceService
    private let timerService: TimerProtocol
    private var latestLocation: CLLocation?
    private var disposeBag = Set<AnyCancellable>()
    private var startDate: Date?
    private var locations: [CLLocation] = []
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
        paceService = PaceService(locationSevice: locationService)
    }

    func start() throws {
        startDate = .init()
        timerService.start()
            .map({ timeInSec in timeInSec.stringFromTimeInterval() })
            .assign(to: \.time, on: self)
            .store(in: &disposeBag)

        timerService.atTimeInterval()
            .combineLatest(try milageService.start())
            .map({ time, milage in
                return (meters: milage, avgPace: Calculations.avgPace(distance: milage, timeInterval: time))
            }).sink(receiveValue: { (meters: Double, avgPace: Double) in
                self.pace = String(format: "%0.2f", avgPace)
                self.distance = String(format: "%0.2f", meters/1000)
            }).store(in: &disposeBag)

        paceService.$pace
            .map({ value in String(format: "%0.2f", value)})
            .assign(to: \.currentPace, on: self)
            .store(in: &disposeBag)
    }

    func pausePlay() {
        paused.toggle()
        timerService.pause(paused)
        milageService.pause(paused)
    }

    func `continue`() {
        paused = false
        timerService.pause(false)
        milageService.pause(false)
    }

    func finish(router: AppRouter) {
        locationService.stop()
        RunDataService().save(run: .init(distance: currentRunMilage, start: startDate ?? Date(), time: secs))
        router.go(to: .history, in: .history)
    }

    private func saveLocations() {
        let locs = locations.map({ return (lat: $0.coordinate.latitude, long: $0.coordinate.longitude) })
        let file = "run_file.txt"
        //save
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = URL(fileURLWithPath: "myFile", relativeTo: directoryURL)
    }
}

struct Calculations {
    static func avgPace(distance meters: Double, timeInterval: TimeInterval) -> Double {
        let distanceInKm = meters/1000
        let mins: Double = timeInterval/60.0
        return mins/distanceInKm
    }
    /**
     Creates a personalized greeting for a recipient.

     - Parameter speed: Speed in meters/second
     */
    static func paceFromSpeed(_ speed: Double) -> Double {
        return speed * 16.6666667
    }
    static func avg(_ values: [Double]) -> Double {
        var result: Double = 0
        values.forEach { value in
            result += value
        }
        return (values.isEmpty ? 0 : result/Double(values.count))
    }
}
