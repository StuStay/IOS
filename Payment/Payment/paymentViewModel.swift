//
//  paymentViewModel.swift
//  Payment
//
//  Created by hama boualeg on 17/11/2023.
//

import Foundation

class PaymentViewModel: ObservableObject {
    @Published var amount: Int = 0
    @Published var date: Date = Date()
    @Published var method: String = "Cash"
    @Published var numberOfRoommates: Int = 0
    @Published var isRecurringPayment: Bool = false
    @Published var recurringPaymentFrequency: String = ""
    
    @Published var payments: [Payment] = []

    func addPayment() {
        PaymentService.shared.Paymentadd(
            amount: amount,
            date: date,
            method: method,
            numberOfRoommates: numberOfRoommates,
            isRecurringPayment: isRecurringPayment,
            recurringPaymentFrequency: recurringPaymentFrequency
        ) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let newPayment):
                // Handle the newly created payment object with ID
                print("Success: New payment added - \(newPayment)")
                // Optionally, you may want to fetch updated payments after adding a new one
                self.fetchPayments()
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }

    func fetchPayments() {
        PaymentService.shared.getPayment { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                switch result {
                case .success(let payments):
                    self.payments = payments
                    print("Fetched \(payments.count) payments.")
                case .failure(let error):
                    print("Error fetching payments: \(error)")
                }
            }
        }
    }

    func deletePayment(paymentID: String) {
        PaymentService.shared.deletePayment(paymentID: paymentID) { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                switch result {
                case .success(let deletedPayment):
                    print("Success: Payment deleted - \(deletedPayment)")
                    // Optionally, you may want to fetch updated payments after deleting one
                    self.fetchPayments()
                case .failure(let error):
                    print("Error deleting payment: \(error)")
                }
            }
        }
    }
}



