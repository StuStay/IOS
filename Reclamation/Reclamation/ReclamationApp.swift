//
//  ReclamationApp.swift
//  Reclamation
//
//  Created by Yassine ezzar on 8/11/2023.
//
import Foundation
import SwiftUI

@main
struct ReclamationApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ListeReclamationView(viewModel: ReclamationViewModel())
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
