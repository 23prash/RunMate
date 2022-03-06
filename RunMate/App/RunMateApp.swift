//
//  RunMateApp.swift
//  RunMate
//
//  Created by Prashant Pukale on 7/18/21.
//

import SwiftUI

@main
struct RunMateApp: App {
    var body: some Scene {
        WindowGroup {
            AppRootView()
                .ignoresSafeArea(.all, edges: [.top])
        }
    }
}
