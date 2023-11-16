//
//  StripePaymentSheetView.swift
//  Payment
//
//  Created by hama boualeg on 10/11/2023.
//
import SwiftUI

struct StripePaymentSheetView: View {
    @State private var cardNumber = ""
    @State private var expirationDate = ""
    @State private var cvv = ""
    @State private var selectedCardType: CardType = .edinar
    @State private var showAlert = false
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

            HStack {
                TextField("Expiration Date", text: $expirationDate)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("CVV", text: $cvv)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }

            Button("Pay") {
                showAlert = true
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(8)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Payment Successful"),
                    message: Text("Thank you for your payment"),
                    primaryButton: .default(Text("OK")) {
                        onDismiss()
                        presentationMode.wrappedValue.dismiss()
                    },
                    secondaryButton: .cancel()
                )
            }
            Spacer()
        }
        .padding()
    }
}

struct StripePaymentSheetView_Previews: PreviewProvider {
    static var previews: some View {
        StripePaymentSheetView(onDismiss: {})
    }
}


