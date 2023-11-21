//
//  ListeReclamationView.swift
//  Reclamation
//
//  Created by Yassine ezzar on 19/11/2023.
//

import SwiftUI



struct Reclamation: Identifiable, Codable {
    var id = UUID()
    var title: String
    var description: String
    
}

class ListeReclamationViewModel: ObservableObject {
    @Published var reclamations: [Reclamation] = []

    // Fonction de récupération des réclamations (simulée pour l'exemple)
    func fetchReclamations() {
        reclamations = [
            Reclamation(title: "Réclamation 1", description: "Description de la réclamation 1"),
            Reclamation(title: "Réclamation 2", description: "Description de la réclamation 2"),
            Reclamation(title: "Réclamation 3", description: "Description de la réclamation 3")
            // Ajoutez d'autres réclamations selon vos besoins
        ]
    }
}

struct ListeReclamationView: View {
    @ObservedObject private var reclamationViewModel = ReclamationViewModel()

    var body: some View {
        NavigationView {
            VStack {
                Text("Liste des Réclamations")
                    .font(.title)
                    .padding(.top, 20)

                List(reclamationViewModel.reclamations) { reclamation in
                    VStack(alignment: .leading) {
                        Text(reclamation.title)
                            .font(.headline)
                        Text(reclamation.description)
                            .foregroundColor(.gray)
                    }
                }
                .onAppear {
                   reclamationViewModel.fetchReclamations()
                }
            }
            .navigationBarTitle("Réclamations")
        }
    }
}

struct ListeReclamationView_Previews: PreviewProvider {
    static var previews: some View {
        ListeReclamationView()
    }
}
