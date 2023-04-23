import Combine
import RunKeeper
import Aryabhatta
import os.log
import Foundation

public final class RunController: ObservableObject {
    @Published public private(set) var run: RunState = .init()
    private var runService: LiveRunServiceProtcol?
    private var statsService: RunStatsProvider?
    private var cancellable: Cancellable?
    private lazy var runStatsPresenter = RunStatsTextualPresenter()
    
    public init() {
    }
    
    public func start() throws {
        let runService = LiveRunService()
        let runObj = try runService.start()
        self.statsService = RunStatsProvider(run: runObj)
        self.runService = runService
        self.run.start()
        self.cancellable = Timer.publish(every: 1, on: .main, in: .default)
            .autoconnect()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] _ in
                guard let self else { return }
                self.updateRun()
            })
    }
    
    public func pause() throws {
        try runService?.pause()
    }
    
    public func resume() throws {
        try runService?.resume()
    }
    
    private func updateRun() {
        guard run.isPaused == false else { return }
        guard let statsService = statsService else { return }
        run.duration = runStatsPresenter.present(duration: statsService.duration)
        run.pace = runStatsPresenter.present(pace: statsService.pace)
        run.distance = runStatsPresenter.present(distance: statsService.distance)
    }
}

public struct RunState {
    public internal(set) var duration: String = "-"
    public let durationTitle: String = CopyWriter.duration
    
    public internal(set) var distance: String = "-"
    public let distanceTitle: String = CopyWriter.distanceKm
    
    public internal(set) var pace: String = "-"
    public let paceTitle: String = CopyWriter.paceKm
    
    public internal(set) var isPaused: Bool = false
    public internal(set) var runTitle: String = ""
    public internal(set) var isStarted: Bool = false
    
    public internal(set) var askLocationPermission: Bool = false
    
    public init(){}
    
    mutating func start() {
        isStarted = true
    }
}
