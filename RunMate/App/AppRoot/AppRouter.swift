import Foundation
import SwiftUI

enum Screen {
    case startRun
    case runCountdown
    case runInProgress
    case history
}

enum Tab {
    case startRun
    case history
}

struct TabConfig {
    let viewInStartTab: AnyView
    let viewInHistory: AnyView
    let viewInFullScreen: AnyView?

    func with(view: AnyView, in tab: Tab?) -> Self {
        switch tab {
        case .startRun:
            return .init(viewInStartTab: view,
                         viewInHistory: viewInHistory,
                         viewInFullScreen: nil)
        case .history:
            return .init(viewInStartTab: viewInStartTab,
                         viewInHistory: view,
                         viewInFullScreen: nil)
        case .none:
            return .init(viewInStartTab: viewInStartTab,
                         viewInHistory: viewInHistory,
                         viewInFullScreen: view)
        }
    }
}

final class AppRouter: ObservableObject {
    @Published var config: TabConfig
    init() {
        config = .init(viewInStartTab: Self.prepare(.startRun),
                       viewInHistory: Self.prepare(.history),
                       viewInFullScreen: nil)
    }

    func go(to screen: Screen, in tab: Tab? = nil) {
        config = config.with(view: Self.prepare(screen), in: tab)
    }

    private static func prepare(_ screen: Screen) -> AnyView {
        switch screen {
        case .startRun:
            return AnyView(RunView())
        case .runCountdown:
            return AnyView(RunCountDownView())
        case .runInProgress:
            return AnyView(RunInProgressView(viewModel: .init()))
        case .history:
            return AnyView(RunHistoryView(viewModel: HistoryViewModel()))
        }
    }
}
