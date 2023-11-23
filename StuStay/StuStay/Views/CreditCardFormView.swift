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
    @State private var paymentProcessed = false

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
            Image(systemName: imageName)
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

            HStack {
                Image(systemName: "creditcard.fill")
                    .resizable()
                    .frame(width: 20, height: 15)
                    .foregroundColor(.blue)
                TextField("Card Number", text: $cardNumber)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }

            HStack {
                Image(systemName: "calendar.circle.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.blue)
                TextField("Expiration Date", text: $expirationDate)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Image(systemName: "lock.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.blue)
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
                        onDismiss() // Call the onDismiss closure the first time
                           presentationMode.wrappedValue.dismiss() // Dismiss the current view
                           presentationMode.wrappedValue.dismiss() // Dismiss the previous view
                    },
                    secondaryButton: .cancel()
                )
            }

            Spacer()
        }
        .padding()
    }
}

struct CreditCardFormView_Previews: PreviewProvider {
    static var previews: some View {
        CreditCardFormView(onDismiss: {})
    }
}
