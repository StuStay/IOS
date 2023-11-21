import SwiftUI
import Social


struct LogementDetailView: View {
    @State private var isEditMode: Bool = false
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

    var body: some View {
        ScrollView {
            VStack {
                ForEach(images, id: \.self) { image in
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                }
                Text("Titre: \(titre)")
                Text("Description: \(description)")
                Text("Nom: \(nom)")
                Text("Nombre de chambres: \(nombreChambre)")
                Text("Prix: \(prix)")
                Text("Contact: \(contact)")
                Text("Lieu: \(lieu)")

                HStack {
                                    Button("Editer l'annonce") {
                                        onEditerAnnonce()
                                    }
                                    .foregroundColor(.blue)
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 2))

                                    Spacer()

                                    Button("Supprimer l'annonce") {
                                        onSupprimerAnnonce()
                                    }
                                    .foregroundColor(.red)
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.red, lineWidth: 2))

                                    Spacer()

                                    // Add a button for sharing
                                    Button("Partager") {
                                        shareAnnouncement()
                                    }
                                    .foregroundColor(.green)
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.green, lineWidth: 2))
                                }
                            }
                            .padding()
                        }
                        .navigationTitle("Détails de l'annonce")
                    }

    private func shareAnnouncement() {
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
    }
                }
