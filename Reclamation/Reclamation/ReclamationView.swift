import SwiftUI

struct ReclamationView: View {
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var selectedType: String = "Select a type"
    @State private var state: String = ""
    @State private var severity: String = ""
    @State private var isNextViewActive: Bool = false
    @StateObject private var viewModel = ReclamationViewModel()
    @State private var isLoading = false
    @State public var describe = ""
    @State private var isShowingMessage = false
    @State private var showAlert = false
    @State private var alertMessage = ""
 
    
    let types = ["Security", "Reservation", "Payment", "Theft"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                FormSection(title: "Title", placeholder: "Title", text: $title)
                
                // Form Section for Description
                FormSection(title: "Description", placeholder: "Description", text: $description)
                
                // Form Section for Type
                FormSectionPicker(title: "Type", options: types, selectedOption: $selectedType)
                
                // Form Section for State
                FormSection(title: "State", placeholder: "State", text: $state)
                
                // Form Section for Severity
                FormSection(title: "Severity", placeholder: "Severity", text: $severity)
                
                VStack {
                    NavigationLink(
                        destination: ListeReclamationView(),
                        isActive: $isNextViewActive) {
                                            EmptyView()
                                        }
                                        .hidden()
                    Button(action: {
                        
                    }) {
                        Text("Send")
                    }
                    
                   
                    
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .navigationBarTitle("Reclamation", displayMode: .inline)
                    .navigationBarBackButtonHidden(true)
                    .navigationBarItems(
                        leading:
                            HStack {
                                Button(action: {
                                    // Call your function here if needed
                                }) {
                                    Image(systemName: "arrow.left")
                                        .foregroundColor(.blue)
                                        .font(.title)
                                }
                            },
                        trailing:
                            VStack {
                                NavigationLink(
                                    destination: messagerieView(),
                                    isActive: $isNextViewActive,
                                    label: {
                                        Image(systemName: "bubble.left.fill")
                                            .font(.system(size: 30))
                                            .foregroundColor(.cyan)
                                            .onTapGesture {
                                                // Handle tap gesture
                                            }
                                    }
                                )
                            }
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding()
                    .padding(.horizontal, 90)
                    

                }
            }
                
        }
    }
}

struct ReclamationView_Previews: PreviewProvider {
    static var previews: some View {
        ReclamationView()
    }
}

struct FormSection: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .foregroundColor(.cyan)
                .bold()
            TextField(placeholder, text: $text)
                .padding(.horizontal)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(height: 57)
        }
        .padding(.top)
    }
}

struct FormSectionPicker: View {
    let title: String
    let options: [String]
    @Binding var selectedOption: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.cyan)
                .bold()
            
            Spacer()
            
            Picker(title, selection: $selectedOption) {
                ForEach(options, id: \.self) { option in
                    Text(option)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 57)
                    .foregroundColor(.white)
            )
        }
        .padding(.horizontal)
        .padding(.top)
    }
}



struct MessagerieView: View {
    var body: some View {
        // Placeholder for MessagerieView
        Text("Messagerie View")
    }
}

