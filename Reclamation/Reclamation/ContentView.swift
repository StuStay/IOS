import SwiftUI
import CoreData

struct ContentView: View {
    @State var titre: String = ""
    @State var description: String = ""
    @State var type: String = ""
    @State var state: String = ""
    @State var severity: String = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                VStack(alignment: .leading) {
                    Text("titre")
                        .foregroundColor(.cyan)
                        .bold()
                    TextField("Titre", text: $titre)
                        .padding(.horizontal)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .frame(height: 57)
                                .foregroundColor(.white)
                        )
                        .padding(.top)
                }

                VStack(alignment: .leading) {
                    Text("description")
                        .foregroundColor(.cyan)
                        .bold()
                    TextField("Description", text: $description)
                        .padding(.horizontal)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .frame(height: 57)
                                .foregroundColor(.white)
                        )
                        .padding(.top)
                }

                VStack(alignment: .leading) {
                    Text("type")
                        .foregroundColor(.cyan)
                        .bold()
                    TextField("type", text: $type)
                        .padding(.horizontal)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .frame(height: 57)
                                .foregroundColor(.white)
                        )
                        .padding(.top)
                }

                VStack(alignment: .leading) {
                    Text("state")
                        .foregroundColor(.cyan)
                        .bold()
                    TextField("state", text: $state)
                        .padding(.horizontal)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .frame(height: 57)
                                .foregroundColor(.white)
                        )
                        .padding(.top)
                }

                VStack(alignment: .leading) {
                    Text("severity")
                        .foregroundColor(.cyan)
                        .bold()
                    TextField("severity", text: $severity)
                        .padding(.horizontal)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .frame(height: 57)
                                .foregroundColor(.white)
                        )
                        .padding(.top)
                }
            }
        }
    }

    func isEnabled() -> Bool {
        return titre.count >= 1 && description.count >= 1 &&
               type.count >= 1 && state.count >= 1 &&
               severity.count >= 1
    }

    func clearFields() {
        titre = ""
        description = ""
        type = ""
        state = ""
        severity = ""
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
