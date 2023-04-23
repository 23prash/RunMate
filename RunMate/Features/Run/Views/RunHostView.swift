import SwiftUI
import SweatUI
import Shiny
import PermissionsSwiftUILocationAlways

struct RunView: View {
    @StateObject var viewModel = RunHostViewModel()

    var body: some View {
        if viewModel.data.run.isStarted {
            RunInProgressView(viewModel: viewModel)
                .ignoresSafeArea()
        } else {
            StartRunView(quote: viewModel.data.quote) {
                viewModel.didTapStart()
            }.JMModal(showModal: $viewModel.data.needsPermission, for: [.locationAlways])
        }
    }
}


struct StartRunView_Previews: PreviewProvider {
    static var previews: some View {
        RunView()
    }
}
