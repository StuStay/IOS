//
//  ListeReclamationVieModel.swift
//  Reclamation
//
//  Created by Yassine ezzar on 19/11/2023.
//

import Foundation
import Combine

class ListeReclamationsViewModel: ObservableObject {
    @Published var reclamations: [Reclamation] = []

    private var cancellables: Set<AnyCancellable> = []

    init() {
        fetchReclamations()
    }

    func fetchReclamations() {
        // Ajoutez ici le code pour récupérer la liste des réclamations depuis votre API
        // Par exemple, vous pouvez utiliser URLSession pour effectuer une requête GET
        guard let url = URL(string: "http://127.0.0.1:3000/reclamations/") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Reclamation].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break // La requête a réussi
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] reclamations in
                self?.reclamations = reclamations
            })
            .store(in: &cancellables)
    }
}
