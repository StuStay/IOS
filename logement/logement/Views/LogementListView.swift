import SwiftUI
import MapKit
import UserNotifications
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
                               LogementCardView(logement: logement)
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
                   
                   Spacer()
                   
                   // Your tab bar and navigation link for adding a new logement
                   // ...
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
    @State private var isFavorite = false

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
                           .lineLimit(nil) // Allow multiline description

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

                   HStack(spacing: 16) {
                       // Payer Button
                       Button(action: {
                           // Add your payment logic here
                       }) {
                           Text("Payer")
                               .font(.headline)
                               .padding()
                               .foregroundColor(.white)
                               .background(Color.blue)
                               .cornerRadius(10)
                               .shadow(color: .blue, radius: 5, x: 0, y: 5)
                       }

                       // Share Button
                       Button(action: {
                           shareLogement()
                       }) {
                           Image(systemName: "square.and.arrow.up")
                               .font(.headline)
                               .padding()
                               .foregroundColor(.white)
                               .background(Color.green)
                               .cornerRadius(10)
                       }

                       // Favorite Button
                       Button(action: {
                           isFavorite.toggle()
                       }) {
                           Image(systemName: isFavorite ? "heart.fill" : "heart")
                               .font(.headline)
                               .padding()
                               .foregroundColor(.cyan)
                               .background(Color.clear)
                               .cornerRadius(10)
                       }

                       // Edit Button
                       NavigationLink(destination: EditLogementView(logement: logement)) {
                           Image(systemName: "pencil")
                               .font(.headline)
                               .padding()
                               .foregroundColor(.white)
                               .background(Color.orange)
                               .cornerRadius(10)
                       }
                   }
                   .padding(.horizontal, 16)
               }
           }
           .navigationBarTitle("StuStay", displayMode: .inline)
           .foregroundColor(.white)
           .background(Color.gray.opacity(0.2))
           .edgesIgnoringSafeArea(.all)
       }

    func shareLogement() {
        let logementTitle = logement.titre ?? ""
        let logementDescription = logement.description ?? ""

        let logementURL = "https://yourlogementurl.com" // Replace with the actual URL

        let items: [Any] = [logementTitle, logementDescription, logementURL]

        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
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
    @State private var region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 36.8663, longitude: 10.1645), // Ariana, Tunisia
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    @State private var selectedLocation: CLLocationCoordinate2D?
  
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
                    Map(coordinateRegion: $region)
                                          .frame(height: 200)
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
                            scheduleNotification()
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
                        .background(Color(.sRGB, red: 10/255, green: 10/255, blue: 40/255, opacity: 1.0))
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
private func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Logement Added"
        content.body = "Your logement has been successfully added."

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        let request = UNNotificationRequest(identifier: "logementAdded", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }


