//
//  RunMateApp.swift
//  RunMate
//
//  Created by macbook on 10/4/2023.
//

import SwiftUI
import DataCenter

@main
struct RunMateApp: App {
    let persistenceController = try! PersistenceController.shared()

    var body: some Scene {
        WindowGroup {
            RunView()
        }
    }
}
