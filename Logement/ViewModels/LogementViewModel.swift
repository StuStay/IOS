/*import Foundation
import SwiftUI
import Combine

class LogementViewModel: ObservableObject {
    @Published var logements: [Logement] = []
    @Published var newLogement: Logement = Logement(id: "", images: [], titre: "", description: "", nom: "", nombreChambre: 0, prix: 0, contact: "", lieu: "")
    
    func fetchLogements() {
        // Utilisez LogementService.shared.getLogements pour obtenir la liste des logements depuis votre backend
        LogementService.shared.getLogements { result in
            switch result {
            case .success(let logements):
                DispatchQueue.main.async {
                    self.logements = logements
                }
            case .failure(let error):
                print("Erreur lors de la récupération des logements : \(error.localizedDescription)")
            }
        }
    }
    
    func addLogement() {
        // Utilisez LogementService.shared.addLogement pour ajouter un nouveau logement à votre backend
        LogementService.shared.addLogement(logement: newLogement) { result in
            switch result {
            case .success(let logement):
                DispatchQueue.main.async {
                    self.logements.append(logement)
                }
            case .failure(let error):
                print("Erreur lors de l'ajout du logement : \(error.localizedDescription)")
            }
        }
    }
    
    func deleteLogement(at index: Int) {
        let logementToDelete = logements[index]
        // Utilisez LogementService.shared.deleteLogement pour supprimer un logement de votre backend
        LogementService.shared.deleteLogement(logementID: logementToDelete.id) { result in
            switch result {
            case .success(let message):
                DispatchQueue.main.async {
                    print(message)
                    self.logements.remove(at: index)
                }
            case .failure(let error):
                print("Erreur lors de la suppression du logement : \(error.localizedDescription)")
            }
        }
    }
}
*/
