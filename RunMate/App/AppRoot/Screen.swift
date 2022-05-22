//
//  Screen.swift
//  RunMate
//
//  Created by Prashant Pukale on 4/16/22.
//

import SwiftUI

enum Screen {
    case startRun
    case runCountdown
    case runInProgress
    case history

    case signUp
    case signIn
    case landing
    case fullScreenLoading
}

enum Tab {
    case startRun
    case history
}

enum RootViewState {
    case fullScreen(AnyView)
    case tab(run: AnyView, history: AnyView)

    func place(view: AnyView, in tab: Tab) -> Self {
        guard case let .tab(runView, historyView) = self else {
            return .tab(run: AnyView(EmptyView()), history: AnyView(EmptyView()))
                .place(view: view, in: tab)
        }
        switch tab {
        case .startRun:
            return .tab(run: view, history: historyView)
        case .history:
            return .tab(run: runView, history: view)
        }
    }

    var isTab: Bool {
        switch self {
        case .fullScreen:
            return false
        case .tab:
            return true
        }
    }

    var isFullScreen: Bool {
        switch self {
        case .fullScreen:
            return true
        case .tab:
            return false
        }
    }
}

//struct TabConfig {
//    let viewInStartTab: AnyView
//    let viewInHistory: AnyView
//    let viewInFullScreen: AnyView?
//
//    func with(view: AnyView, in tab: Tab) -> Self {
//        switch tab {
//        case .startRun:
//            return .init(viewInStartTab: view,
//                         viewInHistory: viewInHistory,
//                         viewInFullScreen: nil)
//        case .history:
//            return .init(viewInStartTab: viewInStartTab,
//                         viewInHistory: view,
//                         viewInFullScreen: nil)
//        case .none:
//            return .init(viewInStartTab: viewInStartTab,
//                         viewInHistory: viewInHistory,
//                         viewInFullScreen: view)
//        }
//    }
//}
