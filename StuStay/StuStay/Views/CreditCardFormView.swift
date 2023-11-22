//
//  CreditCardFormView.swift
//  StuStay
//
//  Created by yassine on 22/11/2023.
//

import SwiftUI

struct CreditCardFormView: View {
    @State private var cardNumber = ""
    @State private var expirationDate = ""
    @State private var cvv = ""
    @State private var selectedCardType: CardType = .edinar
    @State private var showAlert = false
    @State private var paymentSuccessful = false
    @State private var shouldDismiss = false
    // New flag to control dismissal
    @State private var showFailedAlert = false // Flag for showing failed alert
    @Environment(\.presentationMode) var presentationMode
    var onDismiss: () -> Void

    enum CardType: String, CaseIterable {
        case edinar = "Edinar"
        case bh = "BH"
        case stb = "STB"

        var imageName: String {
            switch self {
            case .edinar: return "edinar_icon"
            case .bh: return "bh_icon"
            case .stb: return "stb_icon"
            }
        }

        var image: some View {
            Image(imageName)
                .resizable()
                .frame(width: 30, height: 20)
        }
    }

    var body: some View {
        VStack {
            Text("Credit Card")
                .font(.headline)
                .padding()

            Picker("Select Card Type", selection: $selectedCardType) {
                ForEach(CardType.allCases, id: \.self) { cardType in
                    Label {
                        Text(cardType.rawValue)
                    } icon: {
                        cardType.image
                    }
                    .tag(cardType)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            TextField("Card Number", text: $cardNumber)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)

            HStack {
                TextField("Expiration Date", text: $expirationDate)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("CVV", text: $cvv)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
            }

            NavigationLink(
                destination: EmptyView(),
                isActive: $showAlert
            ) {
                Button("Pay") {
                    if isValidInput() {
                        showAlert = true
                    } else {
                        showFailedAlert = true
                    }
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(8)
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Payment Successful"),
                    message: Text("Thank you for your payment"),
                    dismissButton: .default(Text("OK")) {
                        onDismiss()
                        if shouldDismiss {
                            // Dismiss the current view using the presentationMode
                            presentationMode.wrappedValue.dismiss()
                        }
                        // Reset showAlert to false after the alert is dismissed
                        showAlert = false
                    }
                )
            }
            .alert(isPresented: $showFailedAlert) {
                Alert(
                    title: Text("Payment Failed"),
                    message: Text("Please enter a valid card number and CVV"),
                    dismissButton: .cancel()
                )
            }
            Spacer()
        }
        .padding()
    }

    func isValidInput() -> Bool {
        // Check if the card number is an integer with 16 digits and CVV is a 3-digit number
        guard let cardNumberInt = Int(cardNumber), cardNumber.count == 16,
              let cvvInt = Int(cvv), cvv.count == 3 else {
            // If not valid, show the failed alert
            showFailedAlert = true
            return false
        }

        // Set shouldDismiss to true if the card number and CVV are valid
        shouldDismiss = true
        return true
    }
}

struct CreditCardFormView_Previews: PreviewProvider {
    static var previews: some View {
        CreditCardFormView(onDismiss: {})
    }
}

