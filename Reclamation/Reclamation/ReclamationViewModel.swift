//
//  ReclamationViewModel.swift
//  Reclamation
//
//  Created by Yassine ezzar on 8/11/2023.
//

import Foundation
import SwiftUI

import Combine

class ReclamationViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var selectedType: String = "Sélectionner un type"
    @Published var state: String = ""
    @Published var severity: String = ""

    @Published var reclamations: [Reclamation] = []


    func addReclamation() {
           ReclamationService.shared.Reclamationsadd (
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
           ReclamationService.shared.getReclamation(){ [weak self] result in
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
           ReclamationService.shared.deleteReclamation(ReclamationID: reclamationID) { [weak self] result in
               guard let self = self else { return }

               DispatchQueue.main.async {
                   switch result {
                   case .success(let deletedReclamation):
                       print("Success: Reclamation deleted - \(deletedReclamation)")
                       // Optionally, you may want to fetch updated payments after deleting one
                       self.fetchReclamations()
                   case .failure(let error):
                       print("Error deleting reclamation: \(error)")
                   }
               }
           }
       }
   }
 
    

