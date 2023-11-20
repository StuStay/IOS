import SwiftUI

struct AnnonceView: View {
    @State private var images: [UIImage] = []
    @State private var titre: String = ""
    @State private var description: String = ""
    @State private var nom: String = ""
    @State private var nombreChambre: Int = 0
    @State private var prix: Double = 0.0
    @State private var contact: String = ""
    @State private var lieu: String = ""
    @State private var isImagePickerPresented: Bool = false
    @State private var isAnnoncePubliee: Bool = false
    @State private var isAnnoncePublished: Bool = false
    @State private var isDescriptionValid: Bool = true
    @State private var isTitreValid: Bool = true
  
    @State private var isNombreChambreValid: Bool = true
    @State private var isPrixValid: Bool = true
    @State private var isLieuValid: Bool = true
    @State private var isNomValid: Bool = true
    @State private var isContactValid: Bool = true
    var body: some View {
        NavigationView {
            Form {
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

                Section(header: Text("Détails de l'annonce")) {
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
                    Stepper(value: $nombreChambre, in: 0...10, label: {
                        Text("Nombre de chambres: \(nombreChambre)")
                    })
                    TextField("Prix", value: $prix, formatter: NumberFormatter())
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
                }

                Section {
                    Button("Publier l'annonce") {
                                        
                    isAnnoncePublished = true
                        print("Annonce publiée !")
                        self.isAnnoncePubliee.toggle()
                    }
                }

                if isAnnoncePubliee {
                    Section(header: Text("Annonce publiée")) {
                        Text("Titre: \(titre)")
                        Text("Description: \(description)")
                        Text("Nom: \(nom)")
                        Text("Nombre de chambres: \(nombreChambre)")
                        Text("Prix: \(prix)")
                        Text("Contact: \(contact)")
                        Text("Lieu: \(lieu)")
                    }
                }
            }
            .navigationTitle("Ajouter une annonce")
                   .sheet(isPresented: $isAnnoncePublished) {
                       DetailAnnonceView(
                           titre: titre,
                           description: description,
                           nom: nom,
                           nombreChambre: nombreChambre,
                           prix: prix,
                           contact: contact,
                           lieu: lieu,
                           images: images
                       )
                   }
               
        }
    }

    func loadImage() {
        // Ajoutez le code pour traiter les images sélectionnées
        // Vous pouvez redimensionner les images si nécessaire
    }
}

struct AnnonceView_Previews: PreviewProvider {
    static var previews: some View {
        AnnonceView()
    }
}
