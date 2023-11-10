//
//  PaymentListView.swift
//  Payment
//
//  Created by hama boualeg on 9/11/2023.
//
import SwiftUI

struct PaymentListView: View {
    @State private var payments: [Payment] = []

    var body: some View {
        NavigationView {
            List {
                ForEach(payments) { payment in
                    NavigationLink(destination: PaymentDetailEditView(payment: payment, onSave: { updatedPayment in
                        if let index = payments.firstIndex(where: { $0.id == updatedPayment.id }) {
                            payments[index] = updatedPayment
                        }
                    })) {
                        PaymentRow(payment: payment)
                    }
                }
                .onDelete(perform: deletePayment)
            }
            .navigationBarTitle("Payments")
            .navigationBarItems(trailing: NavigationLink(destination: PaymentDetailEditView(onSave: { newPayment in
                payments.append(newPayment)
            })) {
                Image(systemName: "plus")
            })
        }
    }

    private func deletePayment(at offsets: IndexSet) {
        payments.remove(atOffsets: offsets)
    }
}

struct PaymentRow: View {
    var payment: Payment

    var body: some View {
        VStack(alignment: .leading) {
            Text("Amount: \(payment.amount)")
                .font(.headline)
            Text("Date: \(formattedDate(for: payment.date))")
                .font(.subheadline)
        }
        .padding(8)
    }

    private func formattedDate(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct Payment: Identifiable {
    let id = UUID()
    var amount: String
    var date: Date
    var method: String
    var numberOfRoomates: Int
    var isRecurringPayment: Bool
    var recurringPaymentFrequency: String
}

struct PaymentDetailEditView: View {
    @State private var editedPayment: Payment
    @State private var navigateToStripePaymentSheetView = false
    @State private var showAlert = false
    @Environment(\.presentationMode) var presentationMode

    var onSave: (Payment) -> Void

    init(payment: Payment = Payment(amount: "", date: Date(), method: "Cash", numberOfRoomates: 1, isRecurringPayment: false, recurringPaymentFrequency: "Monthly" ), onSave: @escaping (Payment) -> Void) {
        _editedPayment = State(initialValue: payment)
        self.onSave = onSave
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Payment Information").font(.headline).foregroundColor(.blue)) {
                    Text("Payment Amount:")
                        .font(.headline)

                    TextField("Enter Payment Amount", text: $editedPayment.amount)
                        .padding(2)

                    Text("Payment Date:")
                        .font(.headline)
                    DatePicker("Select Payment Date", selection: $editedPayment.date, displayedComponents: .date)
                        .padding(2)

                    Text("Payment Method:")
                        .font(.headline)
                    Picker("Select Payment Method", selection: $editedPayment.method){
                        Text("Credit Card").tag("Credit Card")
                        Text("Cash").tag("Cash")
                    }
                    .padding(2)

                    Text("Number of Roomates:")
                        .font(.headline)
                    Stepper(value: $editedPayment.numberOfRoomates, in: 1...10) {
                        Text("\(editedPayment.numberOfRoomates) Roomates")
                    }

                    Toggle(isOn: $editedPayment.isRecurringPayment) {
                        Text("Recurring Payment").font(.headline)
                    }
                    .padding(2)

                    if editedPayment.isRecurringPayment {
                        Text("Payment Frequency")
                            .font(.headline)
                        Picker("Select Payment Frequency", selection: $editedPayment.recurringPaymentFrequency) {
                            Text("Monthly").tag("Monthly")
                            Text("Yearly").tag("Yearly")
                        }
                        .padding()
                    }
                }

                Button("Save") {
                    if editedPayment.method == "Credit Card" {
                        showAlert = true
                    } else {
                        onSave(editedPayment)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .foregroundColor(.blue)
                .padding()
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Credit Card"),
                    message: Text("You have selected Credit Card. Do you want to proceed to payment?"),
                    primaryButton: .default(Text("OK")) {
                        navigateToStripePaymentSheetView = true
                    },
                    secondaryButton: .cancel()
                )
            }
            .sheet(isPresented: $navigateToStripePaymentSheetView) {
             
                StripePaymentSheetView(onDismiss: {
                    onSave(editedPayment)
                    presentationMode.wrappedValue.dismiss()
                })          }
            .frame(minWidth: 300, minHeight: 400)
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("Payment Informations")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentListView()
    }
}
