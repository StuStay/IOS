//
//  ReservationApp.swift
//  Reservation
//
//  Created by Mac-Mini_2021 on 17/11/2023.
//

import SwiftUI

@main
struct ReservationApp: App {
    var body: some Scene {
        WindowGroup {
            ReservationListView(viewModel: ReservationViewModel())
        }
    }
}
