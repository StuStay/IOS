import SwiftUI

struct LogementListView: View {
    @ObservedObject var viewModel: LogementViewModel
    @State private var isRefreshing = false
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
                
                .navigationTitle("Logements")
                .refreshable {
                    viewModel.fetchLogements()
                }
                .disabled(isRefreshing)
            }
            .navigationBarItems(trailing:
                NavigationLink(destination: AddLogementView(lv: viewModel)) {
                    Text("Add")
                }
            )
        }
    }
}

struct LogementListView_Previews: PreviewProvider {
    static var previews: some View {
        LogementListView(viewModel: LogementViewModel())
    }
}

struct AddLogementView: View {
    @ObservedObject var lv: LogementViewModel
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var selectedCountryCode = "+1"

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Logement Details")) {
                    TextField("Enter le titre", text: $lv.titre)
                        .padding()
                        .disableAutocorrection(true)
                        .autocapitalization(.words)
                    TextField("Description du logement", text: $lv.description)
                        .padding()
                        .disableAutocorrection(true)
                        .autocapitalization(.sentences)
                    TextField("Nom du logement", text: $lv.nom)
                        .padding()
                        .disableAutocorrection(true)
                        .autocapitalization(.words)
                    Stepper(value: $lv.nombreChambre, in: 1...10) {
                        Text("Nombre de Chambres: \(lv.nombreChambre)")
                    }
                    .padding()
                    TextField("Prix du logement", value: $lv.prix, formatter: NumberFormatter())
                        .padding()
                        .keyboardType(.numberPad)
                    Section(header: Text("Contact du logement")) {
                                       HStack {
                                           Picker("", selection: $selectedCountryCode) {
                                               Text("+1").tag("+1")
                                               Text("+44").tag("+44")
                                               Text("+33").tag("+33")
                                               // Add more country codes as needed
                                           }
                                           .pickerStyle(MenuPickerStyle())
                                           .frame(width: 80)

                                           TextField("Phone Number", text: $lv.contact)
                                               .padding()
                                               .keyboardType(.phonePad)
                                       }
                                   }

                    TextField("Lieu du logement", text: $lv.lieu)
                        .padding()
                        .disableAutocorrection(true)
                        .autocapitalization(.words)
                }

                Section(header: Text("Add Logement")) {
                    Button(action: {
                        if validateInputs() {
                            lv.addLogement()
                        } else {
                            showAlert = true
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
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Invalid Input"),
                            message: Text(alertMessage),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                }
            }
            .navigationTitle("Add Logement")
        }
    }

    private func validateInputs() -> Bool {
        if lv.titre.isEmpty || lv.description.isEmpty || lv.nom.isEmpty || lv.contact.isEmpty || lv.lieu.isEmpty {
            alertMessage = "All fields are required."
            return false
        }

        // Add additional validation logic for each field
        // Example: Validate the length of the contact number and check if it starts with "+216" for Tunisia
        if lv.contact.count != 8 {
            alertMessage = "Invalid contact number. It should be 8 digits and start with +216 for Tunisia."
            return false
        }

        return true
    }
}
