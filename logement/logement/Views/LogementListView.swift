import SwiftUI

struct LogementListView: View {
    
    @ObservedObject var viewModel: LogementViewModel
    @State private var isRefreshing = false
    @State private var scrollToTop: Bool = false
    enum Tab {
            case logements, payment, reservation, reclame
        }
    var body: some View {
            NavigationView {
                VStack {
                    List {
                        ForEach(viewModel.logements) { logement in
                            NavigationLink(destination: LogementDetailView(logement: logement)) {
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
                        }
                        .onDelete { indexSet in
                            guard let index = indexSet.first else { return }
                            let logementToDelete = viewModel.logements[index]
                            viewModel.deleteLogement(logementID: logementToDelete.id)
                        }
                    }
                    .navigationBarTitle("")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            HStack {
                                Button(action: {
                                    // Handle action when home icon is tapped
                                }) {
                                    Image(systemName: "house.fill")
                                }
                                Text("StuStay")
                                    .foregroundColor(.cyan)
                                    .padding(.horizontal, 80)
                            }
                        }
                    }
                    .refreshable {
                        viewModel.fetchLogements()
                    }
                    .disabled(isRefreshing)
                }
                .navigationBarItems(leading: Spacer(), trailing:
                    NavigationLink(destination: AddLogementView(lv: viewModel)) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                            .foregroundColor(.cyan)
                    }
                )
                .tabItem {
                    Label("Logements", systemImage: "house.fill")
                }
                .tag(Tab.logements)
                .tabItem {
                    Label("Payment", systemImage: "creditcard.fill")
                }
                .tag(Tab.payment)
                .tabItem {
                    Label("Reservation", systemImage: "calendar.circle.fill")
                }
                .tag(Tab.reservation)
                .tabItem {
                    Label("Reclame", systemImage: "megaphone.fill")
                }
                .tag(Tab.reclame)
            }
        }
    }




struct LogementDetailView: View {
    var logement: Logement
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Image("your_placeholder_image")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipped()
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(logement.titre ?? "")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.cyan)
                    
                    Text(logement.description ?? "")
                        .font(.body)
                        .foregroundColor(.gray)
                    
                    Divider()
                    
                    Text("Details")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.cyan)
                    
                    Text("Nombre de Chambres: \(logement.nombreChambre)")
                        .font(.body)
                        .foregroundColor(.gray)
                    
                    Text("Prix: \(logement.prix) TND")
                        .font(.body)
                        .foregroundColor(.gray)
                    
                    Divider()
                    
                    Text("Contact")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.cyan)
                    
                    Text(logement.contact ?? "")
                        .font(.body)
                        .foregroundColor(.gray)
                    
                    Divider()
                }
                .padding(16)
                
                Spacer() // Add space at the bottom
                
                Button(action: {
                    // Add your payment logic here
                }) {
                    Text("Payer")
                        .font(.headline)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 16)
            }
        }
        .navigationBarTitle("Logement Detail", displayMode: .inline)
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
}



struct LogementListView_Previews: PreviewProvider {
    static var previews: some View {
        LogementListView(viewModel: LogementViewModel())
    }
}

struct AddLogementView: View {
    @ObservedObject var lv: LogementViewModel
    @State private var selectedImage: UIImage?
       @State private var isImagePickerPresented = false
       @State private var showAlert = false
       @State private var alertMessage = ""
       @State private var selectedCountryCode = "+1"
    @State private var images: [UIImage] = []
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Logement Details")) {
                    HStack {
                        Image(systemName: "pencil")
                            .foregroundColor(.cyan)
                        TextField("Enter le titre", text: $lv.titre)
                            .padding()
                            .disableAutocorrection(true)
                            .autocapitalization(.words)
                    }
                    

                    HStack {
                        Image(systemName: "text.bubble")
                            .foregroundColor(.cyan)
                        TextField("Description du logement", text: $lv.description)
                        
                            .padding()
                            .disableAutocorrection(true)
                            .autocapitalization(.sentences)
                    }

                    HStack {
                        Image(systemName: "house")
                            .foregroundColor(.cyan)
                        TextField("Nom du logement", text: $lv.nom)
                            .padding()
                            .disableAutocorrection(true)
                            .autocapitalization(.words)
                    }

                    HStack {
                        Image(systemName: "number")
                            .foregroundColor(.cyan)
                        Stepper(value: $lv.nombreChambre, in: 1...10) {
                            Text("Nombre de Chambres: \(lv.nombreChambre)")
                        }
                        .padding()
                    }

                    HStack {
                        Image(systemName: "creditcard")
                            .foregroundColor(.cyan)
                        TextField("Prix du logement", value: $lv.prix, formatter: NumberFormatter())
                            .padding()
                            .keyboardType(.numberPad)
                    }

                    Section(header: Text("Contact du logement")) {
                        HStack {
                            Image(systemName: "phone")
                                .foregroundColor(.cyan)
                            Picker("", selection: $selectedCountryCode) {
                                Text("+1").tag("+1")
                                Text("+44").tag("+44")
                                Text("+33").tag("+33")
                                Text("+216").tag("+216")
                            }
                            .pickerStyle(MenuPickerStyle())
                            .frame(width: 80)

                            TextField("Phone Number", text: $lv.contact)
                                .foregroundColor(.cyan)
                                .padding()
                                .keyboardType(.phonePad)
                        }
                    }

                    HStack {
                        Image(systemName: "location")
                            .foregroundColor(.cyan)
                        TextField("Lieu du logement", text: $lv.lieu)
                            .padding()
                            .disableAutocorrection(true)
                            .autocapitalization(.words)
                    }
                }
                Section(header: Text("Images")) {
                    Button("Ajouter des images") {
                        self.isImagePickerPresented.toggle()
                    }
                    .sheet(isPresented: $isImagePickerPresented, onDismiss: loadImage) {
                        CustomImagePicker(images: $images, isImagePickerPresented: $isImagePickerPresented)
                    }

                    if !images.isEmpty {
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(images, id: \.self) { image in
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 100)
                                }
                            }
                        }
                    }
                }

                Section(header: Text("Add Logement")) {
                    Button(action: {
                        if validateInputs() {
                            lv.addLogement()
                        } else {
                            showAlert = true
                        }
                    }) {
                        HStack {
                           // Image(systemName: "plus.circle.fill")
                            Text("ADD")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .padding()
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .shadow(color: .blue, radius: 5, x: 0, y: 5)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Invalid Input"),
                            message: Text(alertMessage),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                }
            }
        }
    }
    func loadImage() {
        
    }
    private func validateInputs() -> Bool {
        if lv.titre.isEmpty || lv.description.isEmpty || lv.nom.isEmpty || lv.contact.isEmpty || lv.lieu.isEmpty {
            alertMessage = "All fields are required."
            return false
        }

        if lv.contact.count != 8 {
            alertMessage = "Invalid contact number. It should be 8 digits and start with +216 for Tunisia."
            return false
        }

        return true
    }
}

