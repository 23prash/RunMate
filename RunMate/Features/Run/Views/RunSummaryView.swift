//
//  RunSummaryView.swift
//  RunMate
//
//  Created by macbook on 24/4/2023.
//

import SwiftUI
import SweatUI

struct RunSummaryView: View {
    @StateObject var viewModel: RunHostViewModel
    
    private func metricView(title: String, metric: String) -> some View {
        HStack {
            Text(title)
                .alignmentGuide(.leading, computeValue: { _ in return 0.0 })
                .font(.title)
            Text(metric)
                .font(.subheadline)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: .space2x) {
            Text("Run Summary")
            Divider()
            metricView(title: viewModel.data.run.distanceTitle, metric: viewModel.data.run.distance)
            Divider()
            metricView(title: viewModel.data.run.durationTitle, metric: viewModel.data.run.duration)
            Divider()
            metricView(title: viewModel.data.run.paceTitle, metric: viewModel.data.run.avgPace)
            Divider()
            ForEach(Array(viewModel.data.run.splits.enumerated()), id: \.offset) { index, pace in
                HStack {
                    Text("\(index + 1)")
                    Text(viewModel.format(pace: pace))
                }
            }
            Button {
            } label: {
                ButtonText.primary("Save Run")
            }.buttonStyle(SweatUIButtonStyle.primary)
        }.padding(.horizontal)
    }
}

struct RunSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        RunSummaryView(viewModel: .init())
    }
}
