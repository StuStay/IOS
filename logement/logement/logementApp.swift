//
//  logementApp.swift
//  logement
//
//  Created by yassine on 21/11/2023.
//

import SwiftUI

@main
struct logementApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            LogementView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
