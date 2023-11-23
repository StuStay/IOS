//
//  LogementListView.swift
//  StuStay
//
//  Created by yassine on 22/11/2023.
//

import SwiftUI

struct LogementListView: View {
    @ObservedObject var viewModel: LogementViewModel
    @State private var isRefreshing = false
    @ObservedObject var paymentViewModel: PaymentViewModel
    @ObservedObject var reclamationViewModel: ReclamationViewModel
    @ObservedObject var reservationViewModel: ReservationViewModel

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.logements) { logement in
                        VStack(alignment: .leading) {
                            Text("Titre: \(logement.titre)")
                            Text("Description: \(logement.description)")
                            Text("Nom: \(logement.nom)")
                            Text("Nombre de Chambres: \(logement.nombreChambre)")
                            Text("Prix: \(logement.prix)")
                            Text("Contact: \(logement.contact)")
                            Text("Lieu: \(logement.lieu)")
                        }
                    }
                    .onDelete { indexSet in
                        guard let index = indexSet.first else { return }
                        let logementToDelete = viewModel.logements[index]
                        viewModel.deleteLogement(logementID: logementToDelete.id)
                    }
                }
                .refreshable {
                    viewModel.fetchLogements()
                }
                .disabled(isRefreshing)

                Spacer()

                HStack {
                    NavigationLink(destination: AddLogementView(lv: viewModel)) {
                        Image(systemName: "plus.circle")
                            .imageScale(.large) // Set the image scale to large
                            .foregroundColor(.blue) // Set the icon color to blue
                            .padding(.horizontal, 20) // Add horizontal padding for better spacing
                    }
                    .overlay(
                        Divider(), alignment: .trailing // Add a divider to the trailing edge of the "Add" icon
                    )

                    NavigationLink(destination: PaymentListView(viewModel: paymentViewModel)) {
                        Image(systemName: "dollarsign.circle")
                            .imageScale(.large) // Set the image scale to large
                            .foregroundColor(.blue) // Set the icon color to blue
                            .padding(.horizontal, 20) // Add horizontal padding for better spacing
                    }
                    .overlay(
                        Divider(), alignment: .trailing // Add a divider to the trailing edge of the "Payment" icon
                    )

                    NavigationLink(destination: ReservationListView(viewModel: reservationViewModel)) {
                        Image(systemName: "doc.circle") // Change to paper icon
                            .imageScale(.large) // Set the image scale to large
                            .foregroundColor(.blue) // Set the icon color to blue
                            .padding(.horizontal, 20) // Add horizontal padding for better spacing
                    }
                    .overlay(
                        Divider(), alignment: .trailing // Add a divider to the trailing edge of the "Reservation" icon
                    )

                    NavigationLink(destination: ListeReclamationView(viewModel: reclamationViewModel)) {
                        Image(systemName: "gearshape.circle") // Change to setting icon
                            .imageScale(.large) // Set the image scale to large
                            .foregroundColor(.blue) // Set the icon color to blue
                            .padding(.horizontal, 20) // Add horizontal padding for better spacing
                    }
                }
            }
            

            // This empty Text view is added to trigger the navigation bar title update
            // without it, the navigation bar title might not show up immediately

        }
    }
}



struct LogementListView_Previews: PreviewProvider {
    static var previews: some View {
        // Create instances of your view models
        let logementViewModel = LogementViewModel()
        let paymentViewModel = PaymentViewModel()
        let reclamationViewModel = ReclamationViewModel()
        let reservationViewModel = ReservationViewModel()

        // Pass the view models to LogementListView
        LogementListView(
            viewModel: logementViewModel,
            paymentViewModel: paymentViewModel,
            reclamationViewModel: reclamationViewModel,
            reservationViewModel: reservationViewModel
        )
    }
}


struct AddLogementView: View {
    @ObservedObject var lv: LogementViewModel

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Titre")) {
                    HStack {
                        Image(systemName: "pencil.circle.fill")
                            .foregroundColor(.blue)
                        TextField("Enter le titre", text: $lv.titre)
                    }
                }

                Section(header: Text("Description")) {
                    HStack {
                        Image(systemName: "text.bubble.fill")
                            .foregroundColor(.blue)
                        TextField("Description du logement", text: $lv.description)
                    }
                }

                Section(header: Text("Nom")) {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .foregroundColor(.blue)
                        TextField("Nom du logement", text: $lv.nom)
                    }
                }

                Section(header: Text("Nombre de Chambres")) {
                    HStack {
                        Image(systemName: "bed.double.fill")
                            .foregroundColor(.blue)
                        Stepper(value: $lv.nombreChambre, in: 1...10) {
                            Text("Nombre de Chambres: \(lv.nombreChambre)")
                        }
                    }
                }

                Section(header: Text("Prix")) {
                    HStack {
                        Image(systemName: "creditcard.fill")
                            .foregroundColor(.blue)
                        TextField("Prix du logement", value: $lv.prix, formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                    }
                }

                Section(header: Text("Contact")) {
                    HStack {
                        Image(systemName: "phone.circle.fill")
                            .foregroundColor(.blue)
                        TextField("Contact du logement", text: $lv.contact)
                            .keyboardType(.phonePad)
                    }
                }

                Section(header: Text("Lieu")) {
                    HStack {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.blue)
                        TextField("Lieu du logement", text: $lv.lieu)
                    }
                }

                Button(action: {
                    lv.addLogement()
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
            .navigationTitle("Add Logement")
        }
        
    }
}
