import SwiftUI

struct LogementView: View {
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
    @State private var isAnnonceSupprimee: Bool = false
    @State private var isNombreChambreValid: Bool = true
    @State private var isPrixValid: Bool = true
    @State private var isLieuValid: Bool = true
    @State private var isNomValid: Bool = true
    @State private var isContactValid: Bool = true
    @StateObject private var viewModel = LogementViewModel()

    
    func supprimerAnnonce() {
        
        print("Annonce supprimée depuis LogementView!")
        isAnnonceSupprimee = true
    }
    
    func validateTitre(_ value: String) {
        
        isTitreValid = !value.isEmpty
        
    }
    func validateFields() -> Bool {
        var isValid = true
        
        
        isTitreValid = !titre.isEmpty
        isValid = isValid && isTitreValid
        
        
        isDescriptionValid = !description.isEmpty
        isValid = isValid && isDescriptionValid
        
       
        isNomValid = !nom.isEmpty
        isValid = isValid && isNomValid
        
       
        isNombreChambreValid = nombreChambre > 0
        isValid = isValid && isNombreChambreValid
        
       
        isPrixValid = prix > 0
        isValid = isValid && isPrixValid
        
    
        isContactValid = !contact.isEmpty
        isValid = isValid && isContactValid
        
      
        isLieuValid = !lieu.isEmpty
        isValid = isValid && isLieuValid
        
        return isValid
    }
    func validateLettersOnly(_ value: String) -> Bool {
           let lettersOnly = value.rangeOfCharacter(from: CharacterSet.letters.inverted) == nil
           return !value.isEmpty && lettersOnly
       }

       
       func validateNumbersOnly(_ value: String) -> Bool {
           let numbersOnly = value.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
           return !value.isEmpty && numbersOnly
       }
    

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
                        .background(validateLettersOnly(titre) ? Color.clear : Color.red.opacity(0.3))
                        .cornerRadius(6)
                        .onChange(of: titre) { newValue in
                            validateTitre(newValue)
                             
                        }
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
                        .background(validateLettersOnly(nom) ? Color.clear : Color.red.opacity(0.3))
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
                        .background(validateNumbersOnly(String(prix)) ? Color.clear : Color.red.opacity(0.3))
                            .cornerRadius(6)
                    TextField("Contact", text: $contact)
                        .font(.custom("Montserrat", size: 16))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.vertical, 5)
                        .overlay(
                            Image(systemName: "phone.fill")
                                .foregroundColor(.cyan)
                                .padding(.horizontal, 8),
                            alignment: .trailing
                        )
                        .background(validateNumbersOnly(String(prix)) ? Color.clear : Color.red.opacity(0.3))
                        .cornerRadius(6)
                        .onChange(of: contact) { newValue in
                            // Assurez-vous que le nouveau texte commence par "+216" et que le reste est composé de chiffres
                            isContactValid = newValue.hasPrefix("+216") && newValue.dropFirst(4).rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
                        }
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
                        if validateFields() {
                            viewModel.addLogement()
                            isAnnoncePublished = true
                            print("Annonce publiée !")
                            self.isAnnoncePubliee.toggle()
                        } else {
                            print("Veuillez remplir tous les champs correctement.")
                        }
                    }


                }

                if isAnnoncePubliee && !isAnnonceSupprimee {
                                   Section(header: Text("Annonce publiée")) {
                                       Text("Titre: \(titre)")
                                       Text("Description: \(description)")
                                       Text("Nom: \(nom)")
                                       Text("Nombre de chambres: \(nombreChambre)")
                                       Text("Prix: \(prix)")
                                       Text("Contact: \(contact)")
                                       Text("Lieu: \(lieu)")
                                       Button("Supprimer l'annonce") {
                                           supprimerAnnonce()
                                       }
                                   }
                    
                               }
                           }
                           .navigationTitle("Ajouter une annonce")
                           .sheet(isPresented: $isAnnoncePublished) {
                               LogementDetailView   (
                                onSupprimerAnnonce: {
                                    // Put your logic for deleting the post here
                                    print("Annonce supprimée !")
                                    isAnnonceSupprimee = true
                                },
                                onEditerAnnonce: {
                                    // Put your logic for editing the post here
                                    print("Annonce éditée !")
                                    // You may want to present an edit view or toggle an edit mode here
                                },
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
                           .toolbar {
                               ToolbarItem(placement: .navigationBarTrailing) {
                                   HStack {
                                       NavigationLink(destination: ProfileView()) {
                                           Image(systemName: "person.circle")
                                       }
                                       .foregroundColor(.cyan)

                                       Spacer()

                                       NavigationLink(destination: ReclameView()) {
                                           Image(systemName: "megaphone")
                                       }
                                       .foregroundColor(.green)
                                   }
                               }
                           }

                       }
        
                   }
    
  
    func loadImage() {
        
    }
}

struct LogementView_Previews: PreviewProvider {
    static var previews: some View {
        LogementView()
    }
    
}
    
