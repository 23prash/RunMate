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
            }.JMModal(showModal: $viewModel.data.askLocationPermission, for: [.locationAlways], autoDismiss: true)
                .alert(isPresented: $viewModel.data.showAlert, error: viewModel.data.error) { error in
                    Button(error.primaryAction.title, action: error.primaryAction.handler)
                    if let secondary = error.secondaryAction {
                        Button(secondary.title, action: secondary.handler)
                    }
                } message: { error in
                    Text(error.message)
                }
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
