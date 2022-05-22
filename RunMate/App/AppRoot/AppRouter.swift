import Foundation
import SwiftUI
import FirebaseAuth

final class AppRouter: ObservableObject {
    @Published var config: RootViewState
    private var handle: AuthStateDidChangeListenerHandle?

    init() {
        config = .fullScreen(Self.prepare(.fullScreenLoading))

        handle = Auth.auth()
            .addStateDidChangeListener({ [weak self] auth, user in
                guard let _ = user else {
                    self?.go(to: .landing)
                    return
                }
                self?.go(to: .startRun, in: .startRun)
            })
        try? Auth.auth().signOut()
    }

    func go(to screen: Screen, in tab: Tab) {
        config = config.place(view: Self.prepare(screen), in: tab)
    }

    func go(to screen: Screen) {
        config = .fullScreen(Self.prepare(screen))
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
        case .landing:
            return AnyView(LandingView())
        case .signIn:
            return AnyView(SignInView())
        case .signUp:
            return AnyView(SignUpView())
        case .fullScreenLoading:
            return AnyView(FullScreenLoader())
        }
    }
}
