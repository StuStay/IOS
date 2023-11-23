//
//  ListeReclamationView.swift
//  StuStay
//
//  Created by yassine on 22/11/2023.
//

import SwiftUI

struct ListeReclamationView: View {
    @ObservedObject var viewModel: ReclamationViewModel
    @State private var isRefreshing = false
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.reclamations.indices, id: \.self) { index in
                        let reclamation = viewModel.reclamations[index]
                        VStack(alignment: .leading) {
                            Text("Title: \(reclamation.title)")
                            Text("Description:\(reclamation.description)")
                            Text("Type: \(reclamation.type)")
                            Text("State: \(reclamation.state)")
                            Text("Severity: \(reclamation.severity)")
                        }
                    }
                    .onDelete { indexSet in
                      
                        guard let index = indexSet.first else { return }
                        let reclamationToDelete = viewModel.reclamations[index]
                        viewModel.deleteReclamations(reclamationID: reclamationToDelete.IdUser)
                    }
                }
                .navigationTitle("Reclamations")
                .refreshable {
                    
                    viewModel.fetchReclamations()
                }
                .disabled(isRefreshing)
            }
            .navigationBarItems(trailing:
                NavigationLink(destination: AddReclamationView(rv:viewModel)) {
                Image(systemName: "plus.circle")
                    .imageScale(.large) // Set the image scale to large
                    .foregroundColor(.blue) // Set the icon color to blue
                    .padding(.horizontal, 20)
                }
            )
        }
    }
}

struct ListeReclamationView_Previews: PreviewProvider {
    static var previews: some View {
        ListeReclamationView(viewModel:ReclamationViewModel())
    }
}

struct AddReclamationView: View {
    @ObservedObject var rv: ReclamationViewModel

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Title")) {
                    HStack {
                        Image(systemName: "pencil.circle.fill")
                            .foregroundColor(.blue)
                        TextField("Enter title", text: $rv.title)
                    }
                }

                Section(header: Text("Description")) {
                    HStack {
                        Image(systemName: "text.bubble.fill")
                            .foregroundColor(.blue)
                        TextField("Enter description", text: $rv.description)
                    }
                }

                Section(header: Text("Type")) {
                    Picker("Select type", selection: $rv.selectedType) {
                        Text("Maintenance").tag("Maintenance")
                        Text("Noise").tag("Noise")
                        Text("Other").tag("Other")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                }

                Section(header: Text("State")) {
                    Picker("Select state", selection: $rv.state) {
                        Text("Pending").tag("Pending")
                        Text("In Progress").tag("In Progress")
                        Text("Resolved").tag("Resolved")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                }

                Section(header: Text("Severity")) {
                    Picker("Select severity", selection: $rv.severity) {
                        Text("Low").tag("Low")
                        Text("Medium").tag("Medium")
                        Text("High").tag("High")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                }

                Button(action: {
                    rv.addReclamation()
                }) {
                    Text("ADD")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .navigationTitle("Add Reclamation")
        }
    }
}
