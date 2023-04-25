import Foundation
import RunController
import Combine
import os.log
import MapKit
import RunKeeper
import Aryabhatta

final class RunHostViewModel: ObservableObject {
    private let quoteProvider = QuoteProvider(type: .preRun)
    struct Data {
        var quote: String
        var needsPermission = false
        var runStarted = false
        var run: RunState
    }
    @Published var data: Data
    private var cancellable = Set<AnyCancellable>()
    private(set) lazy var runController = RunController()
    
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
        } catch {
            os_log("Error: \(error)")
            data.needsPermission = true
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
    
    func format(pace: Pace) -> String {
        return PaceFormatter().string(for: pace)
    }
}
