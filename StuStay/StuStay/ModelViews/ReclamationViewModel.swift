//
//  ReclamationViewModel.swift
//  StuStay
//
//  Created by yassine on 22/11/2023.
//

import Foundation



class ReclamationViewModel: ObservableObject {
    @Published var IdUser: String = ""
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var selectedType: String = ""
    @Published var state: String = ""
    @Published var severity: String = ""

    @Published var reclamations: [Reclamation] = []


    func addReclamation() {
           ReclamationsService.shared.Reclamationadd (
            IdUser: IdUser,
               title: title,
               description: description,
               type: selectedType,
               state: state,
               severity: severity
           
            
           ) { [weak self] result in
               guard let self = self else { return }

               switch result {
               case .success(let newReclamation):
                   // Handle the newly created payment object with ID
                   print("Success: New reclamation added - \(newReclamation)")
                   // Optionally, you may want to fetch updated payments after adding a new one
                   self.fetchReclamations()
               case .failure(let error):
                   print("Error: \(error)")
               }
           }
       }

       func fetchReclamations() {
           ReclamationsService.shared.getReclamation { [weak self]  result in
               guard let self = self else { return }
               DispatchQueue.main.async {
                   switch result {
                   case .success(let reclamations):
                       self.reclamations = reclamations
                       print("Fetched \(reclamations.count) reclamations.")
                   case .failure(let error):
                       print("Error fetching reclamations: \(error)")
                             }
                           }
                       }
                   }
       func deleteReclamations(reclamationID: String) {
           ReclamationsService.shared.deleteReclamation(ReclamationID: reclamationID) { [weak self] result in
               guard let self = self else { return }

               DispatchQueue.main.async {
                              switch result {
                              case .success:
                                  print("Success: Reclamation deleted successfully")
                                  // Optionally, you may want to fetch updated reservations after deleting one
                                  self.fetchReclamations()

                              case .failure(let error):
                                  print("Error deleting reclamation: \(error)")
                                  // Optionally, you may want to show an alert or handle the error in some way
                              }
                          }
                      }
                  }
   }
 
    
