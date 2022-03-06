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
            Text("Time")
                .font(.footnote)
        }
    }

    private var distanceView: some View {
        VStack {
            Text(viewModel.distance)
                .font(.largeTitle)
            Text("Distance")
                .font(.footnote)
        }
    }

    private var paceView: some View {
        VStack {
            Text(viewModel.pace)
                .font(.largeTitle)
            Text("Avg Pace(mins/km)")
                .font(.footnote)
        }
    }

    private var currentPaceView: some View {
        VStack {
            Text(viewModel.currentPace)
                .font(.largeTitle)
            Text("Pace(mins/km)")
                .font(.footnote)
        }
    }

    private var pauseButton: some View {
        Button  {
            withAnimation {
                viewModel.pause()
            }
        } label: {
            RoundedButtonImage(title: .pause, style: .secondary)

        }
    }

    private var playButton: some View {
        Button  {
            withAnimation {
                viewModel.continue()
            }
        } label: {
            RoundedButtonImage(title: .play, style: .secondary)
        }
    }

    private var finishButton: some View {
        Button  {
            withAnimation {
                viewModel.finish(router: router)
            }
        } label: {
            RoundedButtonLabel(title: "🏁", style: .success)
        }
    }

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Spacer()
                timeView
                Spacer()
                distanceView
                Spacer()
                Spacer()
            }

            Spacer()

            HStack {
                Spacer()
                paceView
                Spacer()
                Spacer()
                currentPaceView
                Spacer()
            }

            Spacer()

            HStack {
                Spacer()
                pauseButton
                if viewModel.paused {
                    Spacer()
                    playButton
                        .transition(.move(edge: .trailing))
                    Spacer()
                    finishButton
                        .transition(.move(edge: .trailing))
                    Spacer()
                }
                Spacer()
            }

            Spacer()
        }
    }
}

struct RunInProgressView_Previews: PreviewProvider {
    static var previews: some View {
        RunInProgressView(viewModel: RunInProgressViewModel())
    }
}
