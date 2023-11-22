import SwiftUI

struct LogementeditView: View {
    @Binding var isEditMode: Bool
    @State private var editedTitre: String
    @State private var editedDescription: String
    @State private var editedNom: String
    @State private var editedNombreChambre: Int
    @State private var editedPrix: Double
    @State private var editedContact: String
    @State private var editedLieu: String
    
    var saveChangesAction: (
           String, String, String, Int, Double, String, String
       ) -> Void

       init(
           isEditMode: Binding<Bool>,
           titre: Binding<String>,
           description: Binding<String>,
           nom: Binding<String>,
           nombreChambre: Binding<Int>,
           prix: Binding<Double>,
           contact: Binding<String>,
           lieu: Binding<String>,
           saveChangesAction: @escaping (
               String, String, String, Int, Double, String, String
           ) -> Void
       ) {
           _isEditMode = isEditMode
           _editedTitre = State(initialValue: titre.wrappedValue)
           _editedDescription = State(initialValue: description.wrappedValue)
           _editedNom = State(initialValue: nom.wrappedValue)
           _editedNombreChambre = State(initialValue: nombreChambre.wrappedValue)
           _editedPrix = State(initialValue: prix.wrappedValue)
           _editedContact = State(initialValue: contact.wrappedValue)
           _editedLieu = State(initialValue: lieu.wrappedValue)
           self.saveChangesAction = saveChangesAction
       }
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Détails de l'annonce")) {
                    TextField("Titre", text: $editedTitre)
                    TextField("Description", text: $editedDescription)
                    TextField("Nom", text: $editedNom)
                    Stepper(value: $editedNombreChambre, in: 0...10, label: {
                        Text("Nombre de chambres: \(editedNombreChambre)")
                    })
                    TextField("Prix", value: $editedPrix, formatter: NumberFormatter())
                    TextField("Contact", text: $editedContact)
                    TextField("Lieu", text: $editedLieu)
                }
                
                Section {
                    Button("Enregistrer les modifications") {
                        // Appel de la fonction de sauvegarde avec les valeurs modifiées
                        saveChangesAction(
                            editedTitre,
                            editedDescription,
                            editedNom,
                            editedNombreChambre,
                            editedPrix,
                            editedContact,
                            editedLieu
                        )

                        // Fermez la vue d'édition
                        isEditMode = false
                    }
                }

                .navigationTitle("Modifier l'annonce")
            }
        }
        
    }
}

