//
//  RunMateApp.swift
//  RunMate
//
//  Created by Prashant Pukale on 7/18/21.
//

import SwiftUI
import Firebase
import FirebaseAuth

@main
struct RunMateApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            AppRootView()
                .ignoresSafeArea(.all, edges: [.top])
        }
    }
}
