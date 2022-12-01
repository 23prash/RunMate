//
//  RunInProgressView.swift
//  RunMate
//
//  Created by Prashant Pukale on 2/5/22.
//

import SwiftUI

struct RunInProgressView: View {
    @EnvironmentObject var router: AppRouter
    @ObservedObject private var viewModel: RunInProgressViewModel
    init(viewModel: RunInProgressViewModel) {
        self.viewModel = viewModel
        try? viewModel.start()
    }

    private var timeView: some View {
        VStack {
            Text(viewModel.time)
                .font(.largeTitle)
                .padding()
            Text("Time")
                .font(.footnote)
        }
    }

    private var distanceView: some View {
        VStack {
            Text(viewModel.distance)
                .font(.largeTitle)
                .padding()
            Text("Distance")
                .font(.footnote)
        }
    }

    private var paceView: some View {
        VStack {
            Text(viewModel.pace)
                .font(.largeTitle)
                .padding()
            Text("Avg Pace(mins/km)")
                .font(.footnote)
        }
    }

    private var currentPaceView: some View {
        VStack {
            Text(viewModel.currentPace)
                .font(.largeTitle)
                .padding()
            Text("Pace(mins/km)")
                .font(.footnote)
        }
    }

    private var pauseButton: some View {
        Button  {
            withAnimation {
                viewModel.pausePlay()
            }
        } label: {
            RoundedButtonImage(title: viewModel.paused ? .play : .pause,
                               subtitle: viewModel.paused ? "Resume" : "Pause",
                               style: .secondary)
        }
    }

    private var finishButton: some View {
        Button  {
            withAnimation {
                viewModel.finish(router: router)
            }
        } label: {
            RoundedButtonLabel(title: "🏁", subtitle: "Finish", style: .success)
        }
    }

    var body: some View {
        VStack {
            timeView
                .wrappedInDividers()
            distanceView
                .wrappedInDividers(on: [.bottom])

            HStack {
                paceView
                    .padding(.horizontal, 16)
                currentPaceView
                    .padding(.horizontal, 16)
            }.wrappedInDividers(on: [.bottom])

            Spacer()

            HStack {
                Spacer()
                pauseButton
                if viewModel.paused {
                    Spacer()
                    finishButton
                        .transition(.move(edge: .trailing))
                }
                Spacer()
            }
        }.padding([.top], 32)
    }

}

struct RunInProgressView_Previews: PreviewProvider {
    static var previews: some View {
        RunInProgressView(viewModel: RunInProgressViewModel())
    }
}
