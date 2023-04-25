import SwiftUI
import SweatUI
import Shiny
import PermissionsSwiftUILocationAlways

struct RunView: View {
    @StateObject var viewModel = RunHostViewModel()

    var body: some View {
        switch viewModel.data.run.state {
        case .notStarted:
            StartRunView(quote: viewModel.data.quote) {
                viewModel.didTapStart()
            }.JMModal(showModal: $viewModel.data.needsPermission, for: [.locationAlways])
        case .inProgress:
            RunInProgressView(viewModel: viewModel)
        case .finished:
            RunSummaryView(viewModel: viewModel)
        }
    }
}


struct StartRunView_Previews: PreviewProvider {
    static var previews: some View {
        RunView()
    }
}
