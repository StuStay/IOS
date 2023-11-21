

/*import SwiftUI
import MapKit

/*struct LogementMapView: UIViewRepresentable {
    var location: String

    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
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
}*/

struct LogementListView: View {
    @ObservedObject var viewModel: LogementViewModel
    @State private var isRefreshing = false

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.logements.indices, id: \.self) { index in
                        let logement = viewModel.logements[index]
                        VStack(alignment: .leading) {
                            Text("Titre: \(logement.titre)")
                            Text("Description: \(logement.description)")
                            Text("Nom: \(logement.nom)")
                            Text("Nombre de Chambres: \(logement.nombreChambre)")
                            Text("Prix: \(logement.prix)")
                            Text("Contact: \(logement.contact)")
                            Text("Lieu: \(logement.lieu)")
                            
                            //LogementMapView(location: logement.lieu)
                              //  .frame(height: 150)
                        }
                    }
                    .onDelete { indexSet in
                        guard let firstIndex = indexSet.first else { return }
                        let logementIDToDelete = viewModel.logements[firstIndex].id
                        viewModel.deleteLogement(logementID: logementIDToDelete)
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

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Titre")) {
                    TextField("Enter le titre", text: $lv.titre)
                }

                Section(header: Text("Description")) {
                    TextField("Description du logement", text: $lv.description)
                }

                Section(header: Text("Nom")) {
                    TextField("Nom du logement", text: $lv.nom)
                }

                Section(header: Text("Nombre de Chambres")) {
                    Stepper(value: $lv.nombreChambre, in: 1...10) {
                        Text("Nombre de Chambres: \(lv.nombreChambre)")
                    }
                }

                Section(header: Text("Prix")) {
                    TextField("Prix du logement", text: $lv.prix)
                        .keyboardType(.numberPad)
                }

                Section(header: Text("Contact")) {
                    TextField("Contact du logement", text: $lv.contact)
                        .keyboardType(.phonePad)
                }

                Section(header: Text("Lieu")) {
                    TextField("Lieu du logement", text: $lv.lieu)
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

*/