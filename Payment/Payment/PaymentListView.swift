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
                    Text("Add")
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
    @State private var showCreditCardAlert = false
    @State private var navigateToCreditCardForm = false
    @Environment(\.presentationMode) var presentationMode
    @State private var showAlert = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Amount")) {
                    TextField("Enter amount", text: Binding(
                        get: { "\(paymentViewModel.amount)" },
                        set: {
                            if let newValue = Int($0) {
                                paymentViewModel.amount = newValue
                            }
                        }
                    ))
                    .keyboardType(.numberPad)
                }

                Section(header: Text("Date")) {
                    DatePicker("Select date", selection: $paymentViewModel.date, displayedComponents: .date)
                }

                Section(header: Text("Payment Method")) {
                    Picker("Select method", selection: $paymentViewModel.method) {
                        Text("Credit Card").tag("Credit Card")
                        Text("Cash").tag("Cash")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                Section(header: Text("Number of Roommates")) {
                    Stepper(value: $paymentViewModel.numberOfRoommates, in: 1...10) {
                        Text("Number of Roommates: \(paymentViewModel.numberOfRoommates)")
                    }
                }

                Section(header: Text("Recurring Payment")) {
                    Toggle(isOn: $paymentViewModel.isRecurringPayment) {
                        Text("Recurring Payment")
                    }

                    if paymentViewModel.isRecurringPayment {
                        Picker("Select Frequency", selection: $paymentViewModel.recurringPaymentFrequency) {
                            Text("Monthly").tag("Monthly")
                            Text("Yearly").tag("Yearly")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }

                Button(action: {
                                    if isValidInput() {
                                        if paymentViewModel.method == "Credit Card" {
                                            paymentViewModel.addPayment()
                                            showCreditCardAlert = true
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
                            .navigationTitle("Add Payment")
                            .background(
                                NavigationLink(
                                    destination: CreditCardFormView(onDismiss: { navigateToCreditCardForm = false }),
                                    isActive: $navigateToCreditCardForm
                                ) {
                                    EmptyView()
                                }
                                .isDetailLink(false)
                                .hidden()
                            )
                            .alert(isPresented: $showAlert) {
                                Alert(
                                    title: Text("Invalid Amount"),
                                    message: Text("Please enter a valid number for the amount."),
                                    dismissButton: .default(Text("OK"))
                                )
                            }
                        }
                    }

                    func isValidInput() -> Bool {
                        guard paymentViewModel.amount > 0 else {
                            showAlert(title: "Invalid Amount", message: "Please enter a valid amount.")
                            return false
                        }

                        // Additional validation if needed

                        return true
                    }

                    func showAlert(title: String, message: String) {
                        showAlert = true
                    }
                }
