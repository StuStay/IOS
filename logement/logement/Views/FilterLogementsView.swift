import SwiftUI

class FilterLogementsViewModel: ObservableObject {
    @Published var locationFilter = ""
    @Published var budgetFilter = ""
    @Published var logementTypeFilter = ""
    @Published var startDateFilter = Date()
    @Published var endDateFilter = Date()

    func applyFilters() {
        // Ajoutez ici la logique de filtrage avec les valeurs des filtres
        print("Filtrage appliqué!")
    }
}

struct FilterLogementsView: View {
    @StateObject private var viewModel = FilterLogementsViewModel()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Filtrer par localisation")) {
                    HStack {
                        Image(systemName: "mappin.and.ellipse") // Ajout d'une icône
                            .foregroundColor(.blue)
                        TextField("Localisation", text: $viewModel.locationFilter)
                    }
                }

                Section(header: Text("Filtrer par budget")) {
                    HStack {
                        Image(systemName: "dollarsign.circle") // Ajout d'une autre icône
                            .foregroundColor(.green)
                        TextField("Budget", text: $viewModel.budgetFilter)
                            .keyboardType(.numberPad)
                    }
                }

                Section(header: Text("Filtrer par type de logement")) {
                    HStack {
                        Image(systemName: "house") // Une autre icône pour le type de logement
                            .foregroundColor(.orange)
                        TextField("Type de logement", text: $viewModel.logementTypeFilter)
                    }
                }

                Section(header: Text("Filtrer par dates de séjour")) {
                    HStack {
                        Image(systemName: "calendar") // Icône pour les dates de séjour
                            .foregroundColor(.purple)
                        DatePicker("Date de début", selection: $viewModel.startDateFilter, displayedComponents: .date)
                    }

                    HStack {
                        Image(systemName: "calendar") // Icône pour les dates de fin
                            .foregroundColor(.purple)
                        DatePicker("Date de fin", selection: $viewModel.endDateFilter, displayedComponents: .date)
                    }
                }

                Button(action: {
                    viewModel.applyFilters()
                }) {
                    HStack {
                        Image(systemName: "line.horizontal.3.decrease.circle")
                            .foregroundColor(.white)
                        Text("Appliquer les filtres")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding()
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.cyan)
                    .cornerRadius(10)
                }
            }
            .navigationTitle("Filtrer les logements")
        }
    }
}

struct FilterLogementsView_Previews: PreviewProvider {
    static var previews: some View {
        FilterLogementsView()
    }
}
