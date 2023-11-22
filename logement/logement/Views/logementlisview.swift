/*import SwiftUI

struct LogementListView: View {
    var logements: [Logement]

    var body: some View {
        NavigationView {
            List(logements) { logement in
                NavigationLink(destination: LogementDetailView(logement: logement)) {
                    LogementListItemView(logement: logement)
                }
            }
            .navigationTitle("Liste des Logements")
        }
    }
}

struct LogementListItemView: View {
    var logement: Logement

    var body: some View {
        VStack(alignment: .leading) {
            // Afficher la première image du logement (si disponible)
            if let firstImage = logement.images.first {
                AsyncImage(url: URL(string: firstImage)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .cornerRadius(10)
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .cornerRadius(10)
                            .foregroundColor(.gray)
                    @unknown default:
                        fatalError()
                    }
                }
            }

            // Afficher les détails du logement (titre, lieu, etc.)
            Text(logement.titre)
                .font(.headline)

            Text("Lieu: \(logement.lieu)")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
    }
}

struct LogementListView_Previews: PreviewProvider {
    static var previews: some View {
        let logements: [Logement] = [
            Logement(id: "1", images: ["https://example.com/image1.jpg"], titre: "Bel appartement", description: "Spacieux et lumineux", nom: "John Doe", nombreChambre: 2, prix: 1000, contact: "+21612345678", lieu: "Tunis"),
            Logement(id: "2", images: ["https://example.com/image2.jpg"], titre: "Maison moderne", description: "Avec jardin et piscine", nom: "Jane Doe", nombreChambre: 3, prix: 1500, contact: "+21698765432", lieu: "Sousse"),
        ]

        LogementListView(logements: logements)
    }
}
*/
