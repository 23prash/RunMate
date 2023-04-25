import Combine
import CoreLocation
import DataCenter

public protocol LiveRunServiceProtcol: Service {
    func start() throws -> Run
    func complete() throws
    func pause() throws
    func resume() throws
}

public enum LiveRunError: Error {
    case locationServiceError(LiveLocationServiceError)
    case invalidOperation
}

public final class LiveRunService: LiveRunServiceProtcol {
    public private(set) var state: ServiceState = .notStarted
    private let locationService: LiveLocationServiceProtocol
    private var run: Run?
    
    public init(_ locationService: LiveLocationServiceProtocol = LiveLocationService()) {
        self.locationService = locationService
    }
    
    public func start() throws -> Run {
        let _run = Run()
        self.run = _run
        
        try state.transition(to: .start)
        try locationService.start()
        locationService.onUpdate = { [weak self] loc in
            self?.run?.append(location: loc)
        }
        return _run
    }
    
    public func complete() throws {
        try state.transition(to: .complete)
        try locationService.terminate()
        run?.complete()
    }
    
    public func pause() throws {
        try state.transition(to: .pause)
        try locationService.pause()
        run?.pause()
    }
    
    public func resume() throws {
        try state.transition(to: .resume)
        try locationService.resume()
        run?.resume()
    }
}
