import Foundation
import SwiftUI

struct AppRootView: View {
    @StateObject var router: AppRouter = .init()

    private var tabView: some View {
        TabView {
            router
                .config
                .viewInStartTab
                .environmentObject(router)
                .tabItem {
                    Text("🏃")
                }.ignoresSafeArea(.all, edges: .top)

            router
                .config
                .viewInHistory
                .environmentObject(router)
                .tabItem {
                    Text("History")
                }.ignoresSafeArea(.all, edges: .top)
        }
    }

    var body: some View {
        if let fullScreenView = router.config.viewInFullScreen {
            ZStack {
                tabView
                    .hidden()

                fullScreenView
                    .environmentObject(router)
            }
        } else {
            tabView
        }
    }
}
