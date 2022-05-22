import Foundation
import SwiftUI
import FirebaseAuth
import Firebase

struct AppRootView: View {
    @StateObject var router: AppRouter = .init()
    var body: some View {
        switch router.config {
        case let .tab(runView, historyView):
            return AnyView(TabView {
                runView
                    .environmentObject(router)
                    .tabItem {
                        Text("🏃")
                    }.ignoresSafeArea(.all, edges: .top)

                historyView
                    .environmentObject(router)
                    .tabItem {
                        Text("🏃")
                    }.ignoresSafeArea(.all, edges: .top)
            })
        case let .fullScreen(view):
            return AnyView(view
                .environmentObject(router)
                .ignoresSafeArea())
        }
    }
}
