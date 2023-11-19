//
//  ReservationListView.swift
//  Reservation
//
//  Created by Mac-Mini_2021 on 17/11/2023.
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
                    Text("Add")
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

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Name")) {
                    TextField("Enter your name", text: $rv.name)
                }

                Section(header: Text("Location")) {
                    TextField("City/Area", text: $rv.location)
                }

                Section(header: Text("Gender")) {
                    Picker("Gender", selection: $rv.selectedgender) {
                        Text("Homme").tag("Homme")
                        Text("Femme").tag("Femme")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                Section(header: Text("Check In")) {
                    DatePicker("Check In", selection: $rv.checkInDate, displayedComponents: .date)
                }

                Section(header: Text("Check Out")) {
                    DatePicker("Check Out", selection: $rv.checkOutDate, displayedComponents: .date)
                }

                Section(header: Text("Phone")) {
                    TextField("Your phone", text: $rv.phone)
                        .keyboardType(.phonePad)
                }

                Section(header: Text("Number of Roommates")) {
                    Stepper(value: $rv.numberOfRoommates, in: 1...10) {
                        Text("Number of Roommates: \(rv.numberOfRoommates)")
                    }
                }

                Section(header: Text("Price")) {
                    HStack {
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
                    rv.addReservation()
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
        }
    }
}
