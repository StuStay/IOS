//
//  PaymentListView.swift
//  StuStay
//
//  Created by yassine on 22/11/2023.
//

import SwiftUI

struct PaymentListView: View {
    @ObservedObject var viewModel: PaymentViewModel
    @State private var isRefreshing = false
    

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.payments.indices, id: \.self) { index in
                        let payment = viewModel.payments[index]
                        VStack(alignment: .leading) {
                            Text("Amount: \(payment.amount)")
                            Text("Date: \(PaymentListView.dateFormatter.string(from: payment.date))")
                            Text("Method: \(payment.method)")
                        }
                    }
                    .onDelete { indexSet in
                        // Handle delete action
                        let indicesToDelete = IndexSet(indexSet)
                        guard let firstIndex = indicesToDelete.first else { return }
                        let paymentIDToDelete = viewModel.payments[firstIndex].id // Assuming you have an 'id' property in your Payment model
                        viewModel.deletePayment(paymentID: paymentIDToDelete)
                    }
                }
                .navigationTitle("Payments")
                .refreshable {
                    // Fetch payments when pull-to-refresh occurs
                    viewModel.fetchPayments()
                }
                .disabled(isRefreshing) // Disable the list while refreshing
            }
            
            .navigationBarItems(trailing:
                NavigationLink(destination: AddPaymentView(paymentViewModel: viewModel)) {
                Image(systemName: "plus.circle")
                    .imageScale(.large) // Set the image scale to large
                    .foregroundColor(.blue) // Set the icon color to blue
                    .padding(.horizontal, 20)
                }
            )
        }
        
    }
}

struct PaymentListView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentListView(viewModel: PaymentViewModel())
    }
}

struct AddPaymentView: View {
    @ObservedObject var paymentViewModel: PaymentViewModel
    @State private var navigateToCreditCardForm = false
    @Environment(\.presentationMode) var presentationMode
    @State private var showAlert = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Amount")) {
                    HStack {
                        Image(systemName: "dollarsign.circle.fill")
                            .foregroundColor(.blue)
                        TextField("Enter amount", text: Binding(
                            get: { "\(paymentViewModel.amount)" },
                            set: {
                                // Use a regular expression to check if the entered text is a valid number
                                let isValid = $0.isEmpty || $0.range(of: #"^\d+$"#, options: .regularExpression) != nil

                                if isValid {
                                    if let newValue = Int($0) {
                                        paymentViewModel.amount = newValue
                                    }
                                } else {
                                    // Show the alert when the entered amount is not a valid number
                                    showAlert = true
                                }
                            }
                        ))
                        .keyboardType(.numberPad)
                    }
                }

                Section(header: Text("Date")) {
                    HStack {
                        Image(systemName: "calendar.circle.fill")
                            .foregroundColor(.blue)
                        DatePicker("Select date", selection: $paymentViewModel.date, displayedComponents: .date)
                    }
                }

                Section(header: Text("Payment Method")) {
                    HStack {
                        Image(systemName: "creditcard.fill")
                            .foregroundColor(.blue)
                        Picker("Select method", selection: $paymentViewModel.method) {
                            Text("Credit Card").tag("Credit Card")
                            Text("Cash").tag("Cash")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }

                Section(header: Text("Number of Roommates")) {
                    HStack {
                        Image(systemName: "person.2.fill")
                            .foregroundColor(.blue)
                        Stepper(value: $paymentViewModel.numberOfRoommates, in: 1...10) {
                            Text("Number of Roommates: \(paymentViewModel.numberOfRoommates)")
                        }
                    }
                }

                Section(header: Text("Recurring Payment")) {
                    Toggle(isOn: $paymentViewModel.isRecurringPayment) {
                        Text("Recurring Payment")
                    }

                    if paymentViewModel.isRecurringPayment {
                        HStack {
                            Image(systemName: "clock.arrow.circlepath")
                                .foregroundColor(.blue)
                            Picker("Select Frequency", selection: $paymentViewModel.recurringPaymentFrequency) {
                                Text("Monthly").tag("Monthly")
                                Text("Yearly").tag("Yearly")
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                    }
                }

                Button(action: {
                    if isValidInputP() {
                        if paymentViewModel.method == "Credit Card" {
                            paymentViewModel.addPayment()
                            navigateToCreditCardForm = true
                        } else {
                            paymentViewModel.addPayment()
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }) {
                    Text("ADD")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Invalid Amount"),
                    message: Text("Please enter a valid number for the amount."),
                    dismissButton: .default(Text("OK"))
                )
            }
            
            .navigationTitle("Add Payment")
            .background(
                Group {
                    if paymentViewModel.method == "Credit Card" {
                        NavigationLink(
                            destination: CreditCardFormView(onDismiss: { navigateToCreditCardForm = false }),
                            isActive: $navigateToCreditCardForm
                        ) {
                            EmptyView()
                        }
                        .isDetailLink(false)
                        .hidden()
                    }
                }
            )

        }
        
    }

    func isValidInputP() -> Bool {
        return paymentViewModel.amount > 0
        // Additional validation if needed
    }
}
