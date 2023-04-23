import SwiftUI
import RunController
import MapKit
import SweatUI

struct RunInProgressView: View {
    @StateObject var viewModel: RunHostViewModel
    @State var pause: Bool = false
    
    private func durationView(_ duration: String, durationTitle: String) -> some View {
        VStack(spacing: .space1x) {
            Text(duration)
                .font(.title)
            Text(durationTitle)
                .font(.footnote)
                .foregroundColor(.secondary)
        }
    }
    
    private func distanceView(_ distance: String, distanceTitle: String) -> some View {
        VStack(spacing: .space1x) {
            Text(distance)
                .font(.title2)
            Text(distanceTitle)
                .font(.footnote)
                .foregroundColor(.secondary)
        }.frame(maxWidth: .infinity)
    }
    
    private func paceView(_ pace: String, paceTitle: String) -> some View {
        VStack(spacing: .space1x) {
            Text(pace)
                .font(.title2)
            Text(paceTitle)
                .font(.footnote)
                .foregroundColor(.secondary)
        }.frame(maxWidth: .infinity)
    }
    
    private func runStatsView(_ run: RunState) -> some View {
        VStack {
            durationView(run.duration, durationTitle: run.durationTitle)
                .padding(.top)
            Divider().padding(.horizontal)
            HStack {
                distanceView(run.distance, distanceTitle: run.distanceTitle)
                Divider()
                paceView(run.pace, paceTitle: run.paceTitle)
            }.fixedSize(horizontal: false, vertical: true)
            Divider().padding(.horizontal)
        }
    }
    
    private func pausePlayView() -> some View {
        HStack {
            Button {
                pause.toggle()
                viewModel.pause(pause)
            } label: {
                ButtonText.primary(pause ? "Resume" : "Pause")
            }.buttonStyle(SweatUIButtonStyle.primary)
                .padding()

            Button {
            } label: {
                ButtonText.secondary("Finish")
            }.buttonStyle(SweatUIButtonStyle.secondary)
                .padding()
        }
    }
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $viewModel.data.location)
            VStack {
                runStatsView(viewModel.data.run)
                    .makeCard(cornerRadius: 20.0)
                    .safeAreaInset(edge: .top) {
                        EmptyView().frame(height: 50)
                    }
                    .padding(.horizontal)
                Spacer()
                pausePlayView()
                    .frame(maxWidth: .infinity)
                    .makeCard(cornerRadius: 20)
                    .padding()
            }
        }
    }
}

struct RunInProgressView_Previews: PreviewProvider {
    static var previews: some View {
        RunInProgressView(viewModel: .init())
    }
}
