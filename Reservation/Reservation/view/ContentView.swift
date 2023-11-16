import SwiftUI
import MapKit

struct ReservationListView: View {
    @State private var reservations: [Reservation] = []
    
    var body: some View {
        NavigationView {
            List {
                ForEach(reservations, id: \.id) { reservation in
                    NavigationLink(destination: ReservationDetailView(reservation: reservation, updateAction: updateReservation)) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(reservation.name)
                                .font(.headline)
                            HStack {
                                Text("Location:")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text(reservation.location)
                                    .font(.subheadline)
                            }
                            HStack {
                                Text("Check In:")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text(formattedDate(reservation.checkInDate))
                                    .font(.subheadline)
                            }
                            HStack {
                                Text("Phone:")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text(reservation.phone)
                                    .font(.subheadline)
                            }
                            HStack {
                                Text("Roommates:")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("\(reservation.numberOfRoommates)")
                                    .font(.subheadline)
                            }
                            
                            // Add a Map for the location
                            MapView(location: reservation.location)
                                .frame(height: 150)
                                .cornerRadius(10)
                                .padding(.top, 5)
                        }
                        .padding(10)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    }
                    .listRowBackground(Color.clear)
                }
                .onDelete(perform: deleteReservation)
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Reservations")
            .navigationBarItems(trailing: NavigationLink(destination: AddReservationView(addAction: addReservation)) {
                Image(systemName: "plus")
            })
        }
        .background(Color.gray.opacity(0.1).ignoresSafeArea())
    }
    
    func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: date)
    }
    func addReservation(reservation: Reservation) {
        // Adding reservation locally
        reservations.append(reservation)
        
        // Adding reservation to the server
        addReservationToServer(reservation: reservation) { result in
            switch result {
            case .success(let message):
                print("Successfully added reservation: \(message)")
                // Perform any UI updates or handle success accordingly
                
            case .failure(let error):
                print("Error adding reservation: \(error)")
                // Handle the error or show an alert to the user
            }
        }
    }
    func addReservationToServer(reservation: Reservation, completion: @escaping (Result<String, Error>) -> Void) {
        let urlString = "http://localhost:3000/api/reservations" // Replace this with your server URL
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        let encoder = JSONEncoder()
        guard let jsonData = try? encoder.encode(reservation) else {
            completion(.failure(NSError(domain: "Error encoding reservation", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                
                if let message = json?["message"] as? String {
                    completion(.success(message))
                } else if let errorMessage = json?["error"] as? String {
                    completion(.failure(NSError(domain: errorMessage, code: 0, userInfo: nil)))
                } else {
                    completion(.failure(NSError(domain: "Unexpected response", code: 0, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    
    func updateReservation(reservation: Reservation) {
        if let index = reservations.firstIndex(where: { $0.id == reservation.id }) {
            reservations[index] = reservation
        }
    }
    
    // Function to delete reservation at specified offsets
    func deleteReservation(at offsets: IndexSet) {
        reservations.remove(atOffsets: offsets)
    }
}

    struct MapView: UIViewRepresentable {
        var location: String

        func makeUIView(context: Context) -> MKMapView {
            MKMapView(frame: .zero)
        }

        func updateUIView(_ uiView: MKMapView, context: Context) {
            // Convert the location string to a coordinate and set it on the map
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(location) { placemarks, error in
                if let location = placemarks?.first?.location?.coordinate {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = location
                    uiView.addAnnotation(annotation)
                    uiView.setRegion(MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)), animated: true)
                }
            }
        }
    }

    struct ReservationDetailView: View {
        @State private var editedReservation: Reservation
        var updateAction: (Reservation) -> Void

        init(reservation: Reservation, updateAction: @escaping (Reservation) -> Void) {
            self._editedReservation = State(initialValue: reservation)
            self.updateAction = updateAction
        }

        var body: some View {
            NavigationView {
                Group {
                    List {
                        Section(header: Text("Name")) {
                            TextField("Enter your name", text: $editedReservation.name)
                        }

                        Section(header: Text("Location")) {
                            TextField("City/Area", text: $editedReservation.location)
                        }

                        Section(header: Text("Gender")) {
                            Picker("Gender", selection: $editedReservation.selectedgender) {
                                Text("Homme").tag("Homme")
                                Text("Femme").tag("Femme")
                            }
                        }

                        Section(header: Text("Check In")) {
                            DatePicker("Check In", selection: $editedReservation.checkInDate)
                        }

                        Section(header: Text("Check Out")) {
                            DatePicker("Check Out", selection: $editedReservation.checkOutDate)
                        }

                        Section(header: Text("Phone")) {
                            TextField("Your phone", text: $editedReservation.phone)
                        }

                        Section(header: Text("Number of Roommates")) {
                            Stepper(value: $editedReservation.numberOfRoommates, in: 1...10) {
                                Text("Number of Roommates: \(editedReservation.numberOfRoommates)")
                            }
                        }

                        Section(header: Text("Price")) {
                            HStack {
                                TextField("Min", text: $editedReservation.minPrice)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                Text("to")
                                TextField("Max", text: $editedReservation.maxPrice)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                        }

                        Button("Save Changes") {
                            updateAction(editedReservation)
                        }
                    }
                }
                .navigationTitle("Edit Reservation")
            }
        }
    }

    struct AddReservationView: View {
        @State private var name = ""
        @State private var location = ""
        @State private var selectedGender = "Homme"
        @State private var checkInDate = Date()
        @State private var checkOutDate = Date()
        @State private var phone = ""
        @State private var numberOfRoommates = 0
        @State private var minPrice = ""
        @State private var maxPrice = ""

        var addAction: (Reservation) -> Void

        var body: some View {
            NavigationView {
                Group {
                    Form {
                        Section(header: Text("Name")) {
                            TextField("Enter your name", text: $name)
                        }

                        Section(header: Text("Location")) {
                            TextField("City/Area", text: $location)
                        }

                        Section(header: Text("Genre")) {
                            Picker("Gender", selection: $selectedGender) {
                                Text("Homme").tag("Homme")
                                Text("Femme").tag("Femme")
                            }
                        }

                        Section(header: Text("Check In")) {
                            DatePicker("Check In", selection: $checkInDate)
                        }

                        Section(header: Text("Check Out")) {
                            DatePicker("Check Out", selection: $checkOutDate)
                        }

                        Section(header: Text("Phone")) {
                            TextField("Your phone", text: $phone)
                                .cornerRadius(46)
                                .padding(.top, 10)
                        }

                        Section(header: Text("Number of Roommates")) {
                            Stepper(value: $numberOfRoommates, in: 1...10) {
                                Text("Number of Roommates: \(numberOfRoommates)")
                            }
                        }

                        Section(header: Text("Price")) {
                            HStack {
                                TextField("Min", text: $minPrice)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                Text("to")
                                TextField("Max", text: $maxPrice)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                        }

                        Button("Add Reservation") {
                            let reservation = Reservation(
                                id: UUID(),
                                name: name,
                                location: location,
                                selectedgender: selectedGender,
                                checkInDate: checkInDate,
                                checkOutDate: checkOutDate,
                                phone: phone,
                                numberOfRoommates: numberOfRoommates,
                                minPrice: minPrice,
                                maxPrice: maxPrice
                            )
                            addAction(reservation)
                        }
                    }
                }
                .navigationTitle("Add Reservation")
            }
        }
    }

  

