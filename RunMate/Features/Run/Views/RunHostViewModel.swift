import Foundation
import RunController
import Combine
import os.log
import MapKit
import RunKeeper
import Aryabhatta

final class RunHostViewModel: ObservableObject {
    struct Data {
        var quote: String = QuoteProvider(type: .preRun).getQuote()
        var askLocationPermission = false
        var runStarted = false
        var error: AlertError? = nil {
            didSet {
                showAlert = error != nil
            }
        }
        var showAlert: Bool = false
        var run: RunState = .init()
    }
    @Published var data: Data = .init()
    private var cancellable = Set<AnyCancellable>()
    private let runController = RunController()
    
    init() {
        runController.$run
            .sink { [weak self] runState in
                self?.data.run = runState
            }.store(in: &cancellable)
    }
    
    func didTapStart() {
        do {
            try runController.start()
            data.askLocationPermission = false
        } catch LiveLocationServiceError.permissionError(let canAsk) {
            if canAsk {
                data.askLocationPermission = true
            } else {
                data.error = getLocationError()
            }
        } catch {
            print("Unknown error on run start.")
        }
    }
    
    func complete() {
        do {
            try runController.complete()
        } catch {
            os_log("Error: \(error)")
        }
    }
    
    func pause(_ value: Bool) {
        do {
            if value {
                try runController.pause()
            } else {
                try runController.resume()
            }
        } catch {
            os_log("Error: \(error)")
        }
    }
    
    private func getLocationError() -> AlertError {
        return .init(
            title: L10n.locationErrorTitle,
            message: L10n.locationErrorMessage,
            primaryAction: .init(title: L10n.openSettings) { [weak self] in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url) { _ in
                        self?.data.error = nil
                    }
                }
            },
            secondaryAction: .init(title: L10n.cancel) { [weak self] in
                self?.data.error = nil
            }
        )
    }
    
    func format(pace: Pace) -> String {
        return PaceFormatter().string(for: pace)
    }
}
