import SwiftUI
import Social

struct LogementDetailView: View {
    @State private var isEditMode: Bool = false
    @State private var editedTitre: String
    @State private var editedDescription: String
    @State private var editedNom: String
    @State private var editedNombreChambre: Int
    @State private var editedPrix: Double
    @State private var editedContact: String
    @State private var editedLieu: String
    var onSupprimerAnnonce: () -> Void
    var onEditerAnnonce: () -> Void
    var titre: String
    var description: String
    var nom: String
    var nombreChambre: Int
    var prix: Double
    var contact: String
    var lieu: String
    var images: [UIImage]
    
    init(
        onSupprimerAnnonce: @escaping () -> Void,
        onEditerAnnonce: @escaping () -> Void,
        titre: String,
        description: String,
        nom: String,
        nombreChambre: Int,
        prix: Double,
        contact: String,
        lieu: String,
        images: [UIImage]
    ) {
        self.onSupprimerAnnonce = onSupprimerAnnonce
        self.onEditerAnnonce = onEditerAnnonce
        self.titre = titre
        self.description = description
        self.nom = nom
        self.nombreChambre = nombreChambre
        self.prix = prix
        self.contact = contact
        self.lieu = lieu
        self.images = images
        
        // Set initial values for edited fields
        self._editedTitre = State(initialValue: titre)
        self._editedDescription = State(initialValue: description)
        self._editedNom = State(initialValue: nom)
        self._editedNombreChambre = State(initialValue: nombreChambre)
        self._editedPrix = State(initialValue: prix)
        self._editedContact = State(initialValue: contact)
        self._editedLieu = State(initialValue: lieu)
    }
    
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Image Carousel
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        ForEach(images, id: \.self) { image in
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: UIScreen.main.bounds.width, height: 200)
                                .clipped()
                        }
                    }
                }
                .frame(height: 200)
                
                // Details Section
                VStack(alignment: .leading, spacing: 10) {
                    // Display editable fields when in edit mode, otherwise display labels
                    if isEditMode {
                        TextField("Titre", text: $editedTitre)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        TextField("Description", text: $editedDescription)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        TextField("Nom", text: $editedNom)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Stepper(value: $editedNombreChambre, in: 0...10, label: {
                            Text("Nombre de chambres: \(editedNombreChambre)")
                        })
                        TextField("Prix", value: $editedPrix, formatter: NumberFormatter())
                        TextField("Contact", text: $editedContact)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        TextField("Lieu", text: $editedLieu)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    } else {
                        // Display labels when not in edit mode
                        Text(titre)
                            .font(.title)
                            .fontWeight(.bold)
                        Text(description)
                            .font(.body)
                        Text("Propriétaire: \(nom)")
                            .font(.body)
                        Text("Chambres: \(nombreChambre)")
                            .font(.body)
                        Text("Prix: \(prix, specifier: "%.2f") DT")
                            .font(.body)
                        Text("Contact: \(contact)")
                            .font(.body)
                        Text("Lieu: \(lieu)")
                            .font(.body)
                    }
                }
                .padding(.horizontal, 16)
                
                // Buttons Section
                HStack(spacing: 16) {
                    HStack(spacing: 16) {
                        // Utilisez la navigation pour passer à la vue d'édition
                        NavigationLink(
                            destination: LogementeditView(
                                isEditMode: $isEditMode,
                                titre: $editedTitre,
                                description: $editedDescription,
                                nom: $editedNom,
                                nombreChambre: $editedNombreChambre,
                                prix: $editedPrix,
                                contact: $editedContact,
                                lieu: $editedLieu,
                                saveChangesAction: { titre, description, nom, nombreChambre, prix, contact, lieu in
                                    // Mettez à jour vos données ou effectuez d'autres opérations nécessaires
                                    // Cela peut inclure une mise à jour du modèle de données ou l'appel d'une fonction de mise à jour
                                    // isEditMode n'est pas mis à jour ici, assurez-vous de gérer cela selon vos besoins
                                    editedTitre = titre
                                    editedDescription = description
                                    editedNom = nom
                                    editedNombreChambre = nombreChambre
                                    editedPrix = prix
                                    editedContact = contact
                                    editedLieu = lieu
                                }
                            ),
                            isActive: $isEditMode,
                            label: {
                                ActionButton(title: "Editer", color: .blue) {
                                    // Définissez ici les actions supplémentaires à effectuer avant de passer à la vue d'édition
                                    // Par exemple, vous pourriez effectuer une validation avant de passer à l'édition
                                    isEditMode.toggle()
                                }
                            }
                            
                        )
                        
                        ActionButton(title: "Supprimer", color: .red) {
                            onSupprimerAnnonce()
                        }
                        
                        /*ActionButton(title: "Partager", color: .green) {
                            shareAnnouncement()
                        }*/
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 20)
                }
                .background(Color.white)
                .cornerRadius(20)
                .padding()
                .shadow(radius: 5)
            }
            .navigationTitle("Détails de l'annonce")
        }
    }
}
        struct ActionButton: View {
            var title: String
            var color: Color
            var action: () -> Void
            
            var body: some View {
                Group {
                    Button(action: action) {
                        Text(title)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(color)
                            .cornerRadius(10)
                    }
                }
            }
        }

        /*private func shareAnnouncement() {
            // Prepare content to share (you can customize this)
            let shareContent = "Découvrez cette annonce: \(titre)"
            
            // Check if the Facebook app is installed
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
                let facebookShareSheet = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                facebookShareSheet?.setInitialText(shareContent)
                UIApplication.shared.windows.first?.rootViewController?.present(facebookShareSheet!, animated: true, completion: nil)
            } else {
                // Facebook app is not installed
                // Handle accordingly or prompt the user to install the app
            }
            
            // Check if the Twitter app is installed
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
                let twitterShareSheet = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                twitterShareSheet?.setInitialText(shareContent)
                UIApplication.shared.windows.first?.rootViewController?.present(twitterShareSheet!, animated: true, completion: nil)
            } else {
                // Twitter app is not installed
                // Handle accordingly or prompt the user to install the app
            }
            
            // For Instagram, you can open the app with a pre-filled caption
            let instagramURL = URL(string: "instagram://app")!
            if UIApplication.shared.canOpenURL(instagramURL) {
                let caption = "Découvrez cette annonce: \(titre)"
                let escapedCaption = caption.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
                let instagramShareURL = URL(string: "instagram://library?LocalIdentifier=\(escapedCaption)")!
                UIApplication.shared.open(instagramShareURL, options: [:], completionHandler: nil)
            } else {
                // Instagram app is not installed
                // Handle accordingly or prompt the user to install the app
            }
        }*/

    

