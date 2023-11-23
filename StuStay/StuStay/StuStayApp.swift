//
//  StuStayApp.swift
//  StuStay
//
//  Created by yassine on 22/11/2023.
//
import SwiftUI
@main
struct StuStayApp: App {
    var body: some Scene {
        WindowGroup {
            // Initialize view models
            let logementViewModel = LogementViewModel()
            let paymentViewModel = PaymentViewModel()
            let reservationViewModel = ReservationViewModel()
            let reclamationViewModel = ReclamationViewModel()

            // Create the main view with navigation
            NavigationView {
                LogementListView(
                    viewModel: logementViewModel,
                    paymentViewModel: paymentViewModel,
                    reclamationViewModel: reclamationViewModel, reservationViewModel: reservationViewModel
                )
            }
            // You can customize other aspects of the app here
        }
    }
}
