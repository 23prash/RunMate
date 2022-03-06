//
//  RunView.swift
//  RunMate
//
//  Created by Prashant Pukale on 7/18/21.
//

import SwiftUI
import Combine
import MapKit

struct RunView: View {
    @State
    private var milageValue = ""
    
    @ObservedObject
    private var viewModel = RunViewModel()

    @EnvironmentObject
    var router: AppRouter

    
    // MARK:-
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $viewModel.locationRegion)
            CircularGradientView()
            VStack {
                Spacer()
                Button {
                    viewModel.startRun(router: router)
                } label: {
                    RoundedButtonLabel(title: "Start",
                                       style: .success)
                }.disabled(!viewModel.enableStartButton)
                .padding()
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
}
