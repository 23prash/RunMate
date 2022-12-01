//
//  HistoryView.swift
//  RunMate
//
//  Created by Prashant Pukale on 2/14/22.
//

import Foundation
import SwiftUI

struct RunHistoryCell: View {
    let run: RunModel
    init(run: RunModel) {
        self.run = run
    }

    var body: some View {
        VStack {
            HStack {
                Text(run.time)
                Spacer()
                Text(run.distance)
            }
            HStack {
                Text(run.date)
                Spacer()
            }
        }
    }
}

struct RunHistoryView: View {
    @ObservedObject private var viewModel: HistoryViewModel
    init(viewModel: HistoryViewModel) {
        self.viewModel = viewModel
    }
    @EnvironmentObject var router: AppRouter

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.runs, id: \.self) { run in
                    RunHistoryCell(run: run)
                }.onDelete(perform: delete(at:))
            }.navigationTitle("History")
        }
    }

    func delete(at indices: IndexSet) {
        viewModel.deleteRun(at: indices)
    }
}
