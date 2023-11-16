//
//  PaymentListView.swift
//  Payment
//
//  Created by hama boualeg on 9/11/2023.
//
import SwiftUI
import Alamofire


struct PaymentListView: View {
    @State private var payments: [Payment] = []
    let initialPayment = Payment(id: "", amount: 0, date: Date(), method: "Cash", numberOfRoomates: 1, isRecurringPayment: false, recurringPaymentFrequency: "Monthly")

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
            .navigationBarItems(trailing: NavigationLink(destination: PaymentDetailEditView(payment: initialPayment, onSave: { newPayment in
                savePayment(newPayment)
            })) {
                Image(systemName: "plus")
            })
            .onAppear {
                fetchPayments()
            }
        }
    }

    private func fetchPayments() {
        guard let url = URL(string: "http://localhost:3000/api/payments") else {
            return
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: [Payment].self, decoder: decoder) { response in
                switch response.result {
                case .success(let fetchedPayments):
                    DispatchQueue.main.async {
                        self.payments = fetchedPayments
                    }
                case .failure(let error):
                    print("Error fetching payments: \(error.localizedDescription)")
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        print("Response data: \(utf8Text)")
                    }
                }
            }
    }

    private func deletePayment(at offsets: IndexSet) {
        let paymentIDToDelete = payments[offsets.first!].id
        AF.request("http://localhost:3000/api/payments/\(paymentIDToDelete)", method: .delete)
            .response { response in
                switch response.result {
                case .success:
                    self.payments.remove(atOffsets: offsets)
                case .failure(let error):
                    print("Error deleting payment: \(error.localizedDescription)")
                }
            }
    }

    private func savePayment(_ payment: Payment) {
        AF.request("http://localhost:3000/api/payments", method: .post, parameters: payment, encoder: JSONParameterEncoder.default)
            .response { response in
                switch response.result {
                case .success:
                    self.payments.append(payment)
                case .failure(let error):
                    print("Error saving payment: \(error.localizedDescription)")
                }
            }
    }
}

struct PaymentRow: View {
    var payment: Payment

    var body: some View {
        VStack(alignment: .leading) {
            Text(payment.formattedAmount)
                .font(.headline)
            Text(payment.formattedDate)
                .font(.subheadline)
        }
        .padding(8)
    }
}

struct Payment: Identifiable, Decodable, Encodable {
    var id: String
    var amount: Int
    var date: Date
    var method: String
    var numberOfRoomates: Int
    var isRecurringPayment: Bool
    var recurringPaymentFrequency: String

    var formattedAmount: String {
        return "Amount: \(amount)"
    }

    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return "Date: \(dateFormatter.string(from: date))"
    }
}

struct PaymentDetailEditView: View {
    @State private var editedPayment: Payment
    @State private var navigateToStripePaymentSheetView = false
    @State private var showAlert = false
    @Environment(\.presentationMode) var presentationMode

    var onSave: (Payment) -> Void

    init(payment: Payment, onSave: @escaping (Payment) -> Void) {
        _editedPayment = State(initialValue: payment)
        self.onSave = onSave
    }

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Payment Information").font(.headline).foregroundColor(.blue)) {
                    Text("Payment Amount:")
                        .font(.headline)
                    TextField("Enter Payment Amount", text: Binding(
                        get: { String(editedPayment.amount) },
                        set: { editedPayment.amount = Int($0) ?? 0 }
                    ))
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

                    Text("Number of Roommates:")
                        .font(.headline)
                    Stepper(value: $editedPayment.numberOfRoomates, in: 1...10) {
                        Text("\(editedPayment.numberOfRoomates) Roommates")
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
                Text("Stripe Payment Sheet View")
            }
            .frame(minWidth: 300, minHeight: 400)
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("Payment Information")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentListView()
    }
}
