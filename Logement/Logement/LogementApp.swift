//
//  LogementApp.swift
//  Logement
//
//  Created by Yassine ezzar on 8/11/2023.
//

import SwiftUI

@main
struct LogementApp: App {
    @StateObject private var appCoordinator = AppCoordinator()
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            AddLogementView()
                
        }
    }
}
