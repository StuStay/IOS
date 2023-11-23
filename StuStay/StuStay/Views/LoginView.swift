//
//  LoginView.swift
//  StuStay
//
//  Created by hama on 23/11/2023.
//
import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var isLoginSuccessful = false

    var body: some View {
        NavigationView {
            VStack {
                Spacer()

                Text("Login")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    .padding()

                Image(systemName: "person.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
                    .padding()

                TextField("Username", text: $username)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.1)))

                SecureField("Password", text: $password)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.1)))

                NavigationLink(
                    destination: LogementListView(
                        viewModel: LogementViewModel(),
                        paymentViewModel: PaymentViewModel(),
                        reclamationViewModel: ReclamationViewModel(),
                        reservationViewModel: ReservationViewModel()
                    ),
                    isActive: $isLoginSuccessful,
                    label: { EmptyView() }
                )
                .hidden()

                Button(action: {
                    // Perform authentication logic here
                    // For simplicity, always set isLoginSuccessful to true
                    isLoginSuccessful = true
                }) {
                    Text("Login")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()

                Spacer()
            }
            .padding()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
