//
//  LogementViewModel.swift
//  StuStay
//
//  Created by yassine on 22/11/2023.
//
import Foundation
import Combine

class LogementViewModel: ObservableObject {
    @Published var images: String = ""
    @Published var titre: String = ""
    @Published var description: String = ""
    @Published var nom: String = ""
    @Published var nombreChambre: Int = 0
    @Published var prix: Int = 0
    @Published var contact: String = ""
    @Published var lieu: String = ""
    

    @Published var logements: [Logement] = []


    func addLogement() {
        LogementService.shared.Logementadd(
            images:images,
            titre:titre,
            description: description,
            nom: nom,
            nombreChambre: nombreChambre,
            prix: prix,
            contact : contact,
            lieu: lieu
        
        ) { result in
            switch result {
            case .success(let message):
      
                print("Success: \(message)")
            case .failure(let error):
       
                print("Error: \(error)")
            }
        }
    }
    
    func fetchLogements() {
         LogementService.shared.getLogement{ [weak self] result in
             guard let self = self else { return }

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
    func deleteLogement(logementID: String) {
           LogementService.shared.deleteLogement(logementID: logementID) { [weak self] result in
               guard let self = self else { return }

               DispatchQueue.main.async {
                   switch result {
                   case .success(let deletedlogement):
                       print("Success: Logement deleted - \(deletedlogement)")
                       // Optionally, you may want to fetch updated payments after deleting one
                       self.fetchLogements()
                   case .failure(let error):
                       print("Error deleting logement: \(error)")
                   }
               }
           }
       }
    }



