
public enum ServiceState {
    case running
    case notStarted
    case completed
    case paused
    
    mutating func transition(to state: ServiceStateTransition) throws {
        switch self {
        case .running:
            guard state == .pause || state == .complete else { throw ServiceError.invalidOperation }
            self = state.endState
        case .notStarted:
            guard state == .start else { throw ServiceError.invalidOperation }
            self = state.endState
        case .completed:
            throw ServiceError.invalidOperation
        case .paused:
            guard state == .resume || state == .complete else { throw ServiceError.invalidOperation }
            self = state.endState
        }
    }
}

enum ServiceError: Error {
    case invalidOperation
}

public enum ServiceStateTransition {
    case start
    case complete
    case pause
    case resume
    
    var endState: ServiceState {
        switch self {
        case .start:
            return .running
        case .complete:
            return .completed
        case .pause:
            return .paused
        case .resume:
            return .running
        }
    }
}

public protocol Service {
    var state: ServiceState { get }
}
