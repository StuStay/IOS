import SwiftUI

struct ReclamationView: View {
    @ObservedObject var rc: ReclamationViewModel
    @State private var isNextViewActive: Bool = false
    
    let types = ["Security", "Reservation", "Payment", "Theft"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                FormSection(title: "Title", placeholder: "Title", text: $rc.title)
                
                // Form Section for Description
                FormSection(title: "Description", placeholder: "Description", text: $rc.description)
                
                // Form Section for Type
                FormSectionPicker(title: "Type", options: types, selectedOption: $rc.selectedType)
                
                // Form Section for State
                FormSection(title: "State", placeholder: "State", text: $rc.state)
                
                // Form Section for Severity
                FormSection(title: "Severity", placeholder: "Severity", text: $rc.severity)
                
                VStack {
                   
                    Button(action: {
                        rc.addReclamation()
                        
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
        ListeReclamationView(viewModel: ReclamationViewModel())
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

