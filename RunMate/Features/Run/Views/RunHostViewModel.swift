import Foundation
import RunController
import Combine
import os.log
import MapKit
import RunKeeper

final class RunHostViewModel: ObservableObject {
    private let quoteProvider = QuoteProvider(type: .preRun)
    struct Data {
        var quote: String
        var needsPermission = false
        var runStarted = false
        var run: RunState
        var location: MKCoordinateRegion = .init()
    }
    @Published var data: Data
    private var cancellable = Set<AnyCancellable>()
    private(set) lazy var runController = RunController()
    private lazy var locationService = LiveLocationService()
    
    init() {
        self.data = .init(quote: quoteProvider.getQuote(), run: .init())
        runController.$run
            .sink { runState in
                self.data.run = runState
            }.store(in: &cancellable)
    }
    
    func didTapStart() {
        do {
            try runController.start()
            data.needsPermission = false
            try locationService.start()
            locationService.onUpdate = { [weak self] loc in
                self?.data.location = .init(center: loc.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            }
        } catch {
            os_log("Error: \(error)")
            data.needsPermission = true
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
}
