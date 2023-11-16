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

    let types = ["Security", "Reservation", "Payment", "Theft"]

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Form Section for Title
                FormSection(title: "Title", placeholder: "Title", text: $title)
                
                // Form Section for Description
                FormSection(title: "Description", placeholder: "Description", text: $description)
                
                // Form Section for Type
                FormSectionPicker(title: "Type", options: types, selectedOption: $selectedType)
                
                // Form Section for State
                FormSection(title: "State", placeholder: "State", text: $state)
                
                // Form Section for Severity
                FormSection(title: "Severity", placeholder: "Severity", text: $severity)
                
                // Form Section for Send Button
                VStack {
                    Button(action: {
                    }) {
                        Text("Send")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                
            }
            .navigationBarTitle("Reclamation", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(
                leading:
                    HStack {
                        Button(action: {
                            reclamation(
                                title: title,
                                description: description,
                                selectedType: selectedType,
                                state: state,
                                severity: severity
                                
                            )
                        }){
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
                                        // Handle message icon tap action
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
    private func reclamation(title: String, description: String, selectedType: String, state: String, severity: String) {
        // Replace this URL with your actual backend API URL
        let apiUrl = URL(string: "http://127.0.0.1:3000/reclamations/")!
        
        // Sample user data
        let userData: [String: Any] = [
            "title": title,
            "description": description,
            "selectedType": selectedType,
            "state": state,
            "severity": severity
          
        ]
        
        // Convert user data to JSON
        let jsonData = try? JSONSerialization.data(withJSONObject: userData)
        
        // Create a POST request with
        var request = URLRequest(url: apiUrl)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        // Send the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    // House posted successfully
                    DispatchQueue.main.async {
                        isShowingMessage = true
                    }
                } else {
                    print("Error: Invalid response code \(response.statusCode)")
                }
            }
        }
        task.resume()
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


}
    
