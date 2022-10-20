//
//  StartRunView.swift
//  RunMate
//
//  Created by Prashant Pukale on 7/18/21.
//

import SwiftUI
import Combine
import MapKit

struct StartRunView: View {
    @ObservedObject
    private var viewModel = StartRunViewModel()

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
                                       subtitle: nil,
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
