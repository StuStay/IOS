/*import Foundation
import Combine

class LogementViewModel: ObservableObject {
    @Published var images: [String] = []
    @Published var titre: String = ""
    @Published var description: String = ""
    @Published var nom: String = ""
    @Published var nombreChambre: String = ""
    @Published var prix: String = ""
    @Published var contact: String = ""
    @Published var lieu: String = ""

    @Published var logements: [Logement] = []

    private var cancellables: Set<AnyCancellable> = []
    //private let logementService = LogementService.shared

    func createLogement() {
        LogementService.shared.createLogement(images: images, titre: titre, description: description, nom: nom, nombreChambre: Int(nombreChambre) ?? 0, prix: Double(prix) ?? 0.0, contact: contact, lieu: lieu)
{ result in
                switch result {
                case .success(let message):
          
                    print("Success: \(message)")
                case .failure(let error):
           
                    print("Error: \(error)")
                }
            }
     /*logementService.createLogement(logement: logement)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error creating logement: \(error)")
                    // Optionally, you may want to show an alert or handle the error in some way
                }
            }, receiveValue: { createdLogement in
                // Optionally, you may want to perform actions after creating the logement
                print("Logement created successfully: \(createdLogement)")
                // Optionally, you may want to fetch updated logements after creating one
                self.fetchLogements()
            })
            .store(in: &cancellables)*/
    }

    func fetchLogements() {
        LogementService.shared.getAllLogements{ result in
            DispatchQueue.main.async {
                switch result {
                case .success(let logements):
                    self.logements = logements
                    print("Fetched \(logements.count) logements.")
                case .failure(let error):
                    print("Error fetching logements: \(error)")
                }
            }
        }
    }

    func getLogementDetails(logementID: String) {
        LogementService.shared.getLogementDetails(logementID: logementID)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching logement details: \(error)")
                    // Optionally, you may want to show an alert or handle the error in some way
                }
            }, receiveValue: { logement in
                // Optionally, you may want to perform actions after fetching logement details
                print("Logement details fetched successfully: \(logement)")
            })
            .store(in: &cancellables)
    }

    func updateLogement(logement: Logement) {
        LogementService.shared.updateLogement(logement: logement)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error updating logement: \(error)")
                    // Optionally, you may want to show an alert or handle the error in some way
                }
            }, receiveValue: { updatedLogement in
                // Optionally, you may want to perform actions after updating the logement
                print("Logement updated successfully: \(updatedLogement)")
                // Optionally, you may want to fetch updated logements after updating one
                self.fetchLogements()
            })
            .store(in: &cancellables)
    }

    func deleteLogement(logementID: String) {
        LogementService.shared.deleteLogement(logementID: logementID)  { [weak self] result in
            guard let self = self else { return }
DispatchQueue.main.async {
                switch result {
                case .success:
print("Success: Logement deleted successfully")
 self.fetchLogements()
case .failure(let error):
                    print("Error deleting reservation: \(error)")
               }
            }
        }
    }




}

*/
