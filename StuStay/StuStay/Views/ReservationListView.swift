//
//  ReservationListView.swift
//  StuStay
//
//  Created by yassine on 22/11/2023.
//
import SwiftUI
import MapKit

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

struct ReservationListView: View {
    @ObservedObject var viewModel: ReservationViewModel
    @State private var isRefreshing = false

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.reservations.indices, id: \.self) { index in
                        let reservation = viewModel.reservations[index]
                        VStack(alignment: .leading) {
                            Text("Name: \(reservation.name)")
                            Text("Location: \(reservation.location)")
                            Text("Check In: \(ReservationListView.dateFormatter.string(from: reservation.checkInDate))")
                            Text("Check Out: \(ReservationListView.dateFormatter.string(from: reservation.checkOutDate))")
                            // Add more details based on your Reservation model
                            // Display the MapView for each reservation
                            MapView(location: reservation.location)
                                .frame(height: 150)
                        }
                    }
                    .onDelete { indexSet in
                        // Handle delete action
                        guard let firstIndex = indexSet.first else { return }
                        let reservationIDToDelete = viewModel.reservations[firstIndex].id // Assuming you have an 'id' property in your Reservation model
                        viewModel.deleteReservation(reservationID: reservationIDToDelete)
                    }
                }
                .navigationTitle("Reservations")
                .refreshable {
                    // Fetch reservations when pull-to-refresh occurs
                    viewModel.fetchReservations()
                }
                .disabled(isRefreshing) // Disable the list while refreshing
            }
            .navigationBarItems(trailing:
                NavigationLink(destination: AddReservationView(rv: viewModel)) {
                Image(systemName: "plus.circle")
                    .imageScale(.large) // Set the image scale to large
                    .foregroundColor(.blue) // Set the icon color to blue
                    .padding(.horizontal, 20)
                }
            )
        }
    }
}


struct ReservationListView_Previews: PreviewProvider {
    static var previews: some View {
        ReservationListView(viewModel: ReservationViewModel())
    }
}


struct AddReservationView: View {
    @ObservedObject var rv: ReservationViewModel
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""

    // Valid locations
    let validLocations = ["Tunis", "Ariana", "Ben Arous", "Manouba", "Bizerte", "Nabeul", "Beja", "Jendouba", "Zaghouan", "Siliana", "Kef", "Sousse", "Monastir", "Mahdia", "Kasserine", "Sidi Bouzid", "Kairouan", "Gafsa", "Sfax", "Gabes", "Medenine", "Tozeur", "Kebili", "Tataouine"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Name")) {
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(.blue)
                        TextField("Enter your name", text: $rv.name)
                    }
                }

                Section(header: Text("Location")) {
                    HStack {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.blue)
                        TextField("City/Area", text: $rv.location)
                    }
                }

                Section(header: Text("Gender")) {
                    HStack {
                        Image(systemName: "person.3.fill")
                            .foregroundColor(.blue)
                        Picker("Gender", selection: $rv.selectedgender) {
                            Text("Homme").tag("Homme")
                            Text("Femme").tag("Femme")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }

                Section(header: Text("Check In")) {
                    HStack {
                        Image(systemName: "calendar.circle.fill")
                            .foregroundColor(.blue)
                        DatePicker("Check In", selection: $rv.checkInDate, displayedComponents: .date)
                    }
                }

                Section(header: Text("Check Out")) {
                    HStack {
                        Image(systemName: "calendar.circle.fill")
                            .foregroundColor(.blue)
                        DatePicker("Check Out", selection: $rv.checkOutDate, displayedComponents: .date)
                    }
                }

                Section(header: Text("Phone")) {
                    HStack {
                        Image(systemName: "phone.circle.fill")
                            .foregroundColor(.blue)
                        TextField("Your phone", text: $rv.phone)
                            .keyboardType(.phonePad)
                    }
                }

                Section(header: Text("Number of Roommates")) {
                    HStack {
                        Image(systemName: "person.2.fill")
                            .foregroundColor(.blue)
                        Stepper(value: $rv.numberOfRoommates, in: 1...10) {
                            Text("Number of Roommates: \(rv.numberOfRoommates)")
                        }
                    }
                }

                Section(header: Text("Price")) {
                    HStack {
                        Image(systemName: "dollarsign.circle")
                            .foregroundColor(.blue)
                        TextField("Min", text: $rv.minPrice)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                        Text("to")
                        TextField("Max", text: $rv.maxPrice)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                    }
                }

                Button(action: {
                    if isValidInput() {
                        rv.addReservation()
                    } else {
                        // Show alert for invalid inputs
                        showingAlert = true
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
            }
            .navigationTitle("Add Reservation")
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    // Function to check if inputs are valid
    private func isValidInput() -> Bool {
        if rv.name.isEmpty || rv.location.isEmpty || rv.phone.isEmpty || rv.minPrice.isEmpty || rv.maxPrice.isEmpty {
            alertTitle = "Error"
            alertMessage = "Please fill in all the required fields."
            return false
        }

        if !validLocations.contains(rv.location) {
            alertTitle = "Error"
            alertMessage = "Please enter a valid location from the provided list."
            return false
        }

        if rv.phone.count != 8 || !rv.phone.allSatisfy({ $0.isNumber }) {
            alertTitle = "Error"
            alertMessage = "Please enter a valid 8-digit phone number."
            return false
        }

        if let minPrice = Double(rv.minPrice), let maxPrice = Double(rv.maxPrice), minPrice > maxPrice {
            alertTitle = "Error"
            alertMessage = "Min price cannot be greater than Max price."
            return false
        }

        return true
    }
}
