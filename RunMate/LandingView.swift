//
//  ContentView.swift
//  RunMate
//
//  Created by Prashant Pukale on 7/18/21.
//

import SwiftUI

struct LandingView: View {
    var body: some View {
        AppRootView()
            .ignoresSafeArea(.all, edges: [.top])
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LandingView()
    }
}
