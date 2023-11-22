//
//  ReservationApp.swift
//  Reservation
//
//  Created by Mac-Mini_2021 on 17/11/2023.
//

import SwiftUI

@main
struct logementApp: App {
    var body: some Scene {
        WindowGroup {
            LogementListView(viewModel: LogementViewModel())
        }
    }
}
