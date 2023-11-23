import SwiftUI
struct EditLogementView: View {
    @State private var editedTitre: String
     @State private var editedDescription: String
     @State private var editedNombreChambre: Int
     @State private var editedPrix: Int
     @State private var editedContact: String
     @State private var editedLieu: String

     var logement: Logement

     init(logement: Logement) {
         self.logement = logement

         // Initialize the edited values with the current logement details
         _editedTitre = State(initialValue: logement.titre ?? "")
         _editedDescription = State(initialValue: logement.description ?? "")
         _editedNombreChambre = State(initialValue: logement.nombreChambre)
         _editedPrix = State(initialValue: logement.prix)
         _editedContact = State(initialValue: logement.contact ?? "")
         _editedLieu = State(initialValue: logement.lieu ?? "")
     }

     var body: some View {
         NavigationView {
             Form {
                 Section(header: Text("Logement Details").font(.headline)) {
                     TextField("Titre", text: $editedTitre)
                         .textFieldStyle(RoundedBorderTextFieldStyle())
                     TextField("Description", text: $editedDescription)
                         .textFieldStyle(RoundedBorderTextFieldStyle())
                     Stepper(value: $editedNombreChambre, in: 1...10) {
                         Text("Nombre de Chambres: \(editedNombreChambre)")
                     }
                     TextField("Prix", value: $editedPrix, formatter: NumberFormatter())
                         .keyboardType(.numberPad)
                         .textFieldStyle(RoundedBorderTextFieldStyle())
                     TextField("Contact", text: $editedContact)
                         .keyboardType(.phonePad)
                         .textFieldStyle(RoundedBorderTextFieldStyle())
                     TextField("Lieu", text: $editedLieu)
                         .textFieldStyle(RoundedBorderTextFieldStyle())
                 }

                 Section {
                     Button(action: {
                         saveChanges()
                     }) {
                         Text("Save Changes")
                             .font(.headline)
                             .foregroundColor(.white)
                             .padding()
                             .frame(maxWidth: .infinity)
                             .background(Color.blue)
                             .cornerRadius(10)
                     }
                 }
             }
             .navigationBarTitle("Edit Logement", displayMode: .inline)
             .padding(16)
         }
     }

     func saveChanges() {
         // Perform the logic to save the edited values
         // For example, you can use LogementViewModel or LogementService to update the logement details
         // ...

         // After saving changes, you might want to navigate back to the LogementDetailView
     }
 }
