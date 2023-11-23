//
//  PaymentApp.swift
//  Payment
//
//  Created by hama boualeg on 8/11/2023.
//

import SwiftUI

@main
struct PaymentApp: App {
    var body: some Scene {
        WindowGroup {
            PaymentListView(viewModel: PaymentViewModel())
        }
    }
}
