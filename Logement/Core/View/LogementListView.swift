/*import SwiftUI

struct LogementListView: View {
    @ObservedObject var logementViewModel: LogementViewModel

    var body: some View {
        NavigationView {
            List(logementViewModel.logements) { logement in
                NavigationLink(destination: LogementDetailView(logement: logement)) {
                    VStack(alignment: .leading) {
                        Text(logement.titre)
                            .font(.headline)
                        Text(logement.description)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text("Nom: \(logement.nom)")
                        Text("Nombre de Chambres: \(logement.nombreChambre)")
                        Text("Prix: \(logement.prix)")
                        Text("Contact: \(logement.contact)")
                        Text("Lieu: \(logement.lieu)")
                    }
                }
            }
            .navigationTitle("Liste des Logements")
            .onAppear {
                // Chargement initial des logements lorsque la vue apparaît
                logementViewModel.getLogements()
            }
        }
    }
}

struct LogementListView_Previews: PreviewProvider {
    static var previews: some View {
        LogementListView(logementViewModel: LogementViewModel())
    }
}
*/
