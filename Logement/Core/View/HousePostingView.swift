import SwiftUI
import MapKit

struct HousePostingView: View {
    @State private var houseTitle = ""
    @State private var houseDescription = ""
    @State private var hasWiFi = false
    @State private var hasSecure = false
    @State private var hasTV = false
    @State private var hasParking = false
    @State private var price = ""
    @State private var selectedImage: Image?
    @State private var isImagePickerPresented = false
    @State private var isShowingMessage = false
    @State private var selectedLocation: CLLocationCoordinate2D?
    @State private var selectedRegion: MKCoordinateRegion?

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Section(header: Text("House Details")) {
                        TextField("House Title", text: $houseTitle)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        TextField("Description", text: $houseDescription)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Toggle("Wi-Fi", isOn: $hasWiFi)
                            .toggleStyle(CustomToggleStyle())
                        Toggle("Security", isOn: $hasSecure)
                            .toggleStyle(CustomToggleStyle())
                        Toggle("TV", isOn: $hasTV)
                            .toggleStyle(CustomToggleStyle())
                        Toggle("Parking", isOn: $hasParking)
                            .toggleStyle(CustomToggleStyle())
                        TextField("Price per Night", text: $price)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                    }

                    Section(header: Text("Location")) {
                        if let selectedLocation = selectedLocation,
                           let selectedRegion = selectedRegion {
                            Text("Selected Location")
                                .font(.headline)
                                .foregroundColor(.blue)
                            Text("Latitude: \(selectedLocation.latitude)")
                            Text("Longitude: \(selectedLocation.longitude)")
                            Text("Region")
                                .font(.headline)
                                .foregroundColor(.blue)
                            Text("Latitude Delta: \(selectedRegion.span.latitudeDelta)")
                            Text("Longitude Delta: \(selectedRegion.span.longitudeDelta)")
                        }

                        Button(action: {
                            isImagePickerPresented.toggle()
                        }) {
                            Text("Select Location")
                                .foregroundColor(.blue)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.blue, lineWidth: 1)
                                )
                        }
                    }

                    Section(header: Text("Upload Images")) {
                        if let selectedImage = selectedImage {
                            selectedImage
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .cornerRadius(12)
                        } else {
                            Button(action: {
                                isImagePickerPresented.toggle()
                            }) {
                                Text("Upload Image")
                                    .foregroundColor(.blue)
                                    .padding()
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.blue, lineWidth: 1)
                                    )
                            }
                            .fileImporter(
                                isPresented: $isImagePickerPresented,
                                allowedContentTypes: [.image],
                                onCompletion: handleImageSelection
                            )
                        }
                    }

                    Section {
                        Button(action: {
                            isShowingMessage = true
                        }) {
                            Text("Post House")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Post Your House")
            .alert(isPresented: $isShowingMessage) {
                Alert(
                    title: Text("House Posted"),
                    message: Text("Thank you for posting your house!"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }

    private func handleImageSelection(result: Result<URL, Error>) {
        if case .success(let url) = result {
            if let data = try? Data(contentsOf: url),
               let uiImage = UIImage(data: data) {
                selectedImage = Image(uiImage: uiImage)
            }
        }
    }
}

struct HousePostingView_Previews: PreviewProvider {
    static var previews: some View {
        HousePostingView()
    }
}

struct CustomToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            Toggle("", isOn: configuration.$isOn)
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: .cyan))
        }
    }
}
