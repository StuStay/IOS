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



    // Ajoutez d'autres propriétés ou méthodes nécessaires pour le traitement des données

    let types = ["Security", "Reservation", "Payment", "Theft"]

     func isFormValid() -> Bool {
         return !title.isEmpty && !description.isEmpty && selectedType != "Select a type" && !state.isEmpty && !severity.isEmpty

     }

     func isTitleValid() -> Bool {
         return !title.isEmpty
     }

     func isDescriptionValid() -> Bool {
         return !description.isEmpty
     }

     func isSelectedTypeValid() -> Bool {
         return selectedType != "Select a type"
     }

     func isStateValid() -> Bool {
         return !state.isEmpty
     }

     func isSeverityValid() -> Bool {
         return !severity.isEmpty
     }
        
 }
    

