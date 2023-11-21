import SwiftUI

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
                }
            }
            .padding()
        }
        .navigationTitle("Détails de l'annonce")
    }
}
