import SwiftUI
import MapKit

struct Annonce: Identifiable {
    let images: [UIImage]
    let id = UUID()
    let titre: String
    let description: String
    let nom: String
    let nombreChambre: String
    let prix: String
    let contact: String
    let lieu: String
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var isPresented: Bool

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        @Binding var image: UIImage?
        @Binding var isPresented: Bool

        init(image: Binding<UIImage?>, isPresented: Binding<Bool>) {
            _image = image
            _isPresented = isPresented
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                image = uiImage
            }

            isPresented = false
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            isPresented = false
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(image: $image, isPresented: $isPresented)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {

    }
}

struct AddLogementView: View {
    @State private var annonces: [Annonce] = []
    @State private var selectedImage: UIImage? = nil
    @State private var titre: String = ""
    @State private var description: String = ""
    @State private var nom: String = ""
    @State private var nombreChambre: String = ""
    @State private var prix: String = ""
    @State private var contact: String = ""
    @State private var lieu: String = ""

    @State private var selectedLieu: CLLocationCoordinate2D? = nil
    @State private var showImagePicker: Bool = false
    @State private var selectedTab: Int? = 0
    @State private var navigateToPostedAnnouncements: Bool = false
    @State private var isTitreValid: Bool = true
    @State private var isDescriptionValid: Bool = true
    @State private var isNombreChambreValid: Bool = true
    @State private var isPrixValid: Bool = true
    @State private var isLieuValid: Bool = true
    @State private var isNomValid: Bool = true
    @State private var isContactValid: Bool = true
    @State private var isNavigationActive: Bool = false
    @State private var isImageValid: Bool = true // Nouvelle variable pour la validation des images

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Détails du Logement").font(.custom("Montserrat", size: 24))) {
                        TextField("Titre", text: $titre)
                            .font(.custom("Montserrat", size: 16))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.vertical, 5)
                            .overlay(
                                Image(systemName: "pencil.circle.fill")
                                    .foregroundColor(.cyan)
                                    .padding(.horizontal, 8),
                                alignment: .trailing
                            )
                            .background(isTitreValid ? Color.clear : Color.red.opacity(0.3))
                            .cornerRadius(6)

                        TextField("Description", text: $description)
                            .font(.custom("Montserrat", size: 16))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.vertical, 5)
                            .overlay(
                                Image(systemName: "text.bubble.fill")
                                    .foregroundColor(.cyan)
                                    .padding(.horizontal, 8),
                                alignment: .trailing
                            )
                            .background(isDescriptionValid ? Color.clear : Color.red.opacity(0.3))
                            .cornerRadius(6)

                        TextField("Nombre de Chambres", text: $nombreChambre)
                            .font(.custom("Montserrat", size: 16))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .padding(.vertical, 5)
                            .overlay(
                                Image(systemName: "bed.double.fill")
                                    .foregroundColor(.cyan)
                                    .padding(.horizontal, 8),
                                alignment: .trailing
                            )
                            .background(isNombreChambreValid ? Color.clear : Color.red.opacity(0.3))
                            .cornerRadius(6)

                        TextField("Prix", text: $prix)
                            .font(.custom("Montserrat", size: 16))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .padding(.vertical, 5)
                            .overlay(
                                Image(systemName: "creditcard.fill")
                                    .foregroundColor(.cyan)
                                    .padding(.horizontal, 8),
                                alignment: .trailing
                            )
                        TextField("Lieu", text: $lieu)
                            .font(.custom("Montserrat", size: 16))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.vertical, 5)
                            .overlay(
                                Image(systemName: "location.fill")
                                    .foregroundColor(.cyan)
                                    .padding(.horizontal, 8),
                                alignment: .trailing
                            )
                            .background(isPrixValid ? Color.clear : Color.red.opacity(0.3))
                            .cornerRadius(6)

                        TextField("Nom", text: $nom)
                            .font(.custom("Montserrat", size: 16))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.vertical, 5)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .foregroundColor(.cyan)
                                    .padding(.horizontal, 8),
                                alignment: .trailing
                            )
                            .background(isNomValid ? Color.clear : Color.red.opacity(0.3))
                            .cornerRadius(6)

                        TextField("Contact", text: $contact)
                            .font(.custom("Montserrat", size: 16))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.phonePad)
                            .padding(.vertical, 5)
                            .overlay(
                                Image(systemName: "phone.fill")
                                    .foregroundColor(.cyan)
                                    .padding(.horizontal, 8),
                                alignment: .trailing
                            )
                            .background(isContactValid ? Color.clear : Color.red.opacity(0.3))
                            .cornerRadius(6)
                    }

                    Section(header: Text("Images").font(.custom("Montserrat", size: 24))) {
                        if selectedImage != nil {
                            Image(uiImage: selectedImage!)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 100)
                                .cornerRadius(8)
                                .shadow(radius: 3)
                        }

                        Button(action: {
                            showImagePicker = true
                        }) {
                            Text("Uploader des Images").font(.custom("Montserrat", size: 16)).foregroundColor(.blue)
                        }
                        .background(isImageValid ? Color.clear : Color.red.opacity(0.3))
                        .cornerRadius(6)
                    }

                    Section {
                        Button(action: {
                            // Validate input fields
                            isTitreValid = !titre.isEmpty
                            isDescriptionValid = !description.isEmpty
                            isNombreChambreValid = !nombreChambre.isEmpty
                            isPrixValid = !prix.isEmpty
                            isLieuValid = !lieu.isEmpty
                            isNomValid = !nom.isEmpty
                            isContactValid = !contact.isEmpty

                            
                            isImageValid = selectedImage != nil

                            
                            if isTitreValid && isDescriptionValid && isNombreChambreValid && isPrixValid && isLieuValid && isNomValid && isContactValid && isImageValid {
        let annonce = Annonce(images: [selectedImage].compactMap { $0 },
        titre: titre,
            description: description,
            nom: nom,
    nombreChambre: nombreChambre,
                                                                               prix: prix,
                                                                               contact: contact,
                                                                               lieu: lieu)

                                                        annonces.append(annonce)
                                                        selectedImage = nil
                                                        titre = ""
                                                        description = ""
                                                        nom = ""
                                                        nombreChambre = ""
                                                        prix = ""
                                                        contact = ""
                                                        lieu = ""

                                                        navigateToPostedAnnouncements = true
                                                    }
                                                }) {
                                                    Text("Poster l'Annonce").font(.custom("Montserrat", size: 16)).foregroundColor(.white).padding().background(Color.cyan).cornerRadius(8)
                                                }
                                            }
                                            .frame(maxWidth: .infinity, alignment: .center)
                                        }
                                        .navigationBarTitle("Poster une Annonce")
                                        .sheet(isPresented: $showImagePicker) {
                                            ImagePicker(image: $selectedImage, isPresented: $showImagePicker)
                                        }
                                        .background(
                                            NavigationLink(destination: PostedAnnouncementsView(annonces: $annonces), isActive: $navigateToPostedAnnouncements) {
                                                EmptyView()
                                            }
                                            .hidden()
                )
            }
            .overlay(bottomNavigationBar, alignment: .bottom)
        }
    }

    private var bottomNavigationBar: some View {
        HStack {
            Spacer()
            HStack(spacing: 32) {
                NavigationLink(destination: ProfileView(), tag: 0, selection: $selectedTab) {
                    Image(systemName: "person.circle")
                        .font(.system(size: 24))
                        .foregroundColor(selectedTab == 0 ? Color.cyan : Color.gray)
                        .scaleEffect(selectedTab == 0 ? 1.2 : 1.0)
                        .animation(.spring())
                }

                NavigationLink(destination: PaymentView(), tag: 1, selection: $selectedTab) {
                    Image(systemName: "creditcard")
                        .font(.system(size: 24))
                        .foregroundColor(selectedTab == 1 ? Color.cyan : Color.gray)
                        .scaleEffect(selectedTab == 1 ? 1.2 : 1.0)
                        .animation(.spring())
                }

                NavigationLink(destination: ReclameView(), tag: 2, selection: $selectedTab) {
                    Image(systemName: "megaphone")
                        .font(.system(size: 24))
                        .foregroundColor(selectedTab == 2 ? Color.cyan : Color.gray)
                        .scaleEffect(selectedTab == 2 ? 1.2 : 1.0)
                        .animation(.spring())
                }
            }
            .padding()
            Spacer()
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct PostedAnnouncementsView: View {
    @Binding var annonces: [Annonce]

    var body: some View {
        NavigationView {
            List {
                ForEach(annonces.indices, id: \.self) { index in
                    NavigationLink(destination: AnnouncedDetailView(annonces: $annonces, index: index)) {
                        Text(annonces[index].titre)
                            .font(.custom("Montserrat", size: 16))
                    }
                }
                .onDelete { indices in
                    indices.forEach { index in
                        annonces.remove(at: index)
                    }
                }
            }
            .navigationBarTitle("Posted Announcements")
        }
    }
}

struct MapView: UIViewRepresentable {
    @Binding var selectedLocation: CLLocationCoordinate2D?

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        if let location = selectedLocation {
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            uiView.removeAnnotations(uiView.annotations)
            uiView.addAnnotation(annotation)

            // Zoom to the selected location
            let region = MKCoordinateRegion(center: location, latitudinalMeters: 500, longitudinalMeters: 500)
            uiView.setRegion(region, animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(parent: MapView) {
            self.parent = parent
        }
    }
}

struct AddLogementView_Previews: PreviewProvider {
    static var previews: some View {
        AddLogementView()
    }
}
