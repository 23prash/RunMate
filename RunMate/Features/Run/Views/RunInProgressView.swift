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
                .font(.system(size: 70, weight: .semibold))
                .foregroundColor(Theme.primaryBrand)
            Text(durationTitle)
                .font(.footnote)
                .foregroundColor(.secondary)
        }
    }
    
    private func distanceView(_ distance: String, distanceTitle: String) -> some View {
        VStack(spacing: .space1x) {
            Text(distance)
                .font(.system(size: 60, weight: .semibold))
                .foregroundColor(Theme.primaryBrand)
            Text(distanceTitle)
                .font(.footnote)
                .foregroundColor(.secondary)
        }.frame(maxWidth: .infinity)
    }
    
    private func paceView(_ pace: String, paceTitle: String) -> some View {
        VStack(spacing: .space1x) {
            Text(pace)
                .font(.system(size: 60, weight: .semibold))
                .foregroundColor(Theme.primaryBrand)
            Text(paceTitle)
                .font(.footnote)
                .foregroundColor(.secondary)
        }.frame(maxWidth: .infinity)
    }
    
    private func pausePlayView() -> some View {
        HStack(spacing: .space3x) {
            PlayPauseButton(isPaused: $pause) {
                viewModel.pause(pause)
            }.frame(maxWidth: 100, maxHeight: 100)
            
            FinishButton {
                viewModel.complete()
            }.frame(maxWidth: 100, maxHeight: 100)
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            durationView(viewModel.data.run.duration, durationTitle: viewModel.data.run.durationTitle)
            Divider()
            distanceView(viewModel.data.run.distance, distanceTitle: viewModel.data.run.distanceTitle)
            Divider()
            HStack {
                paceView(viewModel.data.run.pace, paceTitle: viewModel.data.run.paceTitle)
                Divider()
                paceView(viewModel.data.run.avgPace, paceTitle: viewModel.data.run.avgPaceTitle)
            }.fixedSize(horizontal: false, vertical: true)
            Divider()
            Spacer()
            pausePlayView()
            Spacer()
        }
    }
}

struct RunInProgressView_Previews: PreviewProvider {
    static var previews: some View {
        RunInProgressView(viewModel: .init())
    }
}
