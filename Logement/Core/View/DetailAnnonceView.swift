import SwiftUI

struct DetailAnnonceView: View {
    @State private var isEditMode: Bool = false

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

                Button("Modifier l'annonce") {
                    isEditMode = true
                }
                .sheet(isPresented: $isEditMode) {
                    EditAnnonceView(
                        isEditMode: $isEditMode,
                        titre: .constant(titre),
                        description: .constant(description),
                        nom: .constant(nom),
                        nombreChambre: .constant(nombreChambre),
                        prix: .constant(prix),
                        contact: .constant(contact),
                        lieu: .constant(lieu)
                    )
                }
            }
            .padding()
        }
        .navigationTitle("Détails de l'annonce")
    }
}
