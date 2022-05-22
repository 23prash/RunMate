import SwiftUI

struct LandingView: View {
    @EnvironmentObject var router: AppRouter

    var body: some View {
        ZStack {

            Color.white

            VStack {
                Spacer()
                Text(Constants.appName)
                    .animatableSystemFont(size: 99)
                    .foregroundColor(.brandColor)
                Spacer()
                Spacer()
                Button {
                    router.go(to: .signIn)
                } label: {
                    ActionButtonLabel(title: "Sign In", type: .secondary)
                }

                Button {
                    router.go(to: .signUp)
                } label: {
                    ActionButtonLabel(title: "Sign Up", type: .primary)

                }.padding()
                Spacer()
            }
        }
    }
}
