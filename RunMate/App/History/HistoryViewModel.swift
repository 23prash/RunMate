//
//  HistoryViewModel.swift
//  RunMate
//
//  Created by Prashant Pukale on 2/14/22.
//

import Foundation

struct RunModel: Identifiable, Hashable {
    var id: Date
    let date: String
    let time: String
    let distance: String

    init(run: Run) {
        id = run.start
        date = RunDateFormatter.defaultFormatter.string(from: run.start)
        time = run.time.stringFromTimeInterval()
        distance = String(format: "%0.2f", run.distance/1000)
    }
}

final class HistoryViewModel: ObservableObject {
    let dataService: RunDataService
    init(service: RunDataService = .init()) {
        dataService = service
        runs = dataService
            .getAll()
            .map({ RunModel(run: $0) })
    }
    @Published var runs: [RunModel]

    func deleteRun(at indices: IndexSet) {
        runs = dataService
            .deleteRuns(at: indices)
            .map({ .init(run: $0) })
    }
}
