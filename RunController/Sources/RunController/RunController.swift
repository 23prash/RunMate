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
    
    public func complete() throws {
        try runService?.complete()
        statsService?.completeRun()
        run.complete()
        run.splits = statsService?.kmSplits() ?? []
    }
    
    private func updateRun() {
        guard run.isPaused == false else { return }
        guard run.isCompleted == false else { return }
        guard let statsService = statsService else { return }
        run.duration = runStatsPresenter.present(duration: statsService.duration)
        run.avgPace = runStatsPresenter.present(pace: statsService.avgPace)
        run.distance = runStatsPresenter.present(distance: statsService.distance)
        run.pace = runStatsPresenter.present(pace: statsService.currentPace)
    }
}

public struct RunState {
    public enum State {
        case notStarted
        case inProgress(paused: Bool)
        case finished
    }
    
    public internal(set) var duration: String = "-"
    public let durationTitle: String = CopyWriter.duration
    
    public internal(set) var distance: String = "-"
    public let distanceTitle: String = CopyWriter.distanceKm
    
    public internal(set) var avgPace: String = "-"
    public let avgPaceTitle: String = CopyWriter.avgPaceKm
    
    public internal(set) var pace: String = "-"
    public let paceTitle: String = CopyWriter.paceKm
    
    public internal(set) var isPaused: Bool {
        get {
            guard case let .inProgress(value) = state else { return false }
            return value
        }
        set {
            state = .inProgress(paused: newValue)
        }
    }
    
    public var isCompleted: Bool {
        guard case .finished = state else { return false }
        return true
    }
    
    public internal(set) var runTitle: String = ""
    
    public internal(set) var state: RunState.State = .notStarted
    
    public internal(set) var askLocationPermission: Bool = false
    
    public var splits: [Pace] = []
    
    public init(){}
    
    mutating func start() {
        self.state = .inProgress(paused: false)
    }
    
    mutating func complete() {
        self.state = .finished
    }
}
