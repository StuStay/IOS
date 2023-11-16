import SwiftUI

struct HousePostingView: View {
    @State private var images: [String] = []
    @State private var title = ""
    @State private var description = ""
    @State private var ownerName = ""
    @State private var numberOfRooms = 1
    @State private var price = ""
    @State private var contact = ""
    @State private var location = ""
    @State private var isImagePickerPresented = false
    @State private var isShowingMessage = false
    @State private var iAgree: Bool = false
    @State private var isLoading = false
    @State public var describe = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Section(header: Text("House Details")) {
                        TextField("Title", text: $title)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        TextField("Description", text: $description)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        TextField("Owner Name", text: $ownerName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Stepper(value: $numberOfRooms, in: 1...10, label: {
                            Text("Number of Rooms: \(numberOfRooms)")
                        })
                        .padding(.horizontal)
                        .foregroundColor(.blue)
                        
                        HStack {
                            TextField("Price (DT)", text: $price)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                                .foregroundColor(.blue)
                            Spacer()
                        }
                        
                        HStack {
                            TextField("Contact", text: $contact)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.phonePad)
                                .foregroundColor(.blue)
                            Spacer()
                        }
                        
                        TextEditor(text: $location)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(height: 100)
                            .foregroundColor(.blue)
                            .cornerRadius(8)
                    }
                    
                    Section(header: Text("Upload Images")) {
                        Button(action: {
                            isImagePickerPresented.toggle()
                        }) {
                            Text("Upload Image")
                                .foregroundColor(.blue)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.blue, lineWidth: 1)
                                )
                        }
                        .fileImporter(
                            isPresented: $isImagePickerPresented,
                            allowedContentTypes: [.image],
                            onCompletion: handleImageSelection
                        )
                        
                        // Display selected images
                        ForEach(images, id: \.self) { imageName in
                            Image(systemName: "photo.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .cornerRadius(12)
                                .padding(.top, 8)
                            Text(imageName)
                                .foregroundColor(.blue)
                                .padding(.bottom, 8)
                        }
                    }
                    
                    Section {
                        Button(action: {
                            posthouse(
                                title: title,
                                description: description,
                                ownerName: ownerName,
                                price: price,
                                contact: contact,
                                numberOfRooms: numberOfRooms,
                                location: location,
                                images: images
                            )
                        }) {
                            Text("Post House")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                    }
                }
                .padding()
                
                Toggle(isOn: $iAgree) {
                    Text("I agree to the medidoc Terms of Service and Privacy Policy")
                }
                .toggleStyle(CheckboxToggleStyle())
                .padding()
            }
            .navigationTitle("Post Your House")
            .alert(isPresented: $isShowingMessage) {
                Alert(
                    title: Text("House Posted"),
                    message: Text("Thank you for posting your house!"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    private func handleImageSelection(result: Result<URL, Error>) {
        if case .success(let url) = result {
            // Assume imageName is derived from URL for simplicity
            let imageName = url.lastPathComponent
            images.append(imageName)
        }
    }
    
    private func posthouse(title: String, description: String, ownerName: String, price: String, contact: String, numberOfRooms: Int, location: String, images: [String]) {
        // Replace this URL with your actual backend API URL
        let apiUrl = URL(string: "http://localhost:3000/logements/logements/")!
        
        // Sample user data
        let userData: [String: Any] = [
            "title": title,
            "description": description,
            "ownerName": ownerName,
            "price": price,
            "contact": contact,
            "numberOfRooms": numberOfRooms,
            "location": location,
            "images": images
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
    
    struct CheckboxToggleStyle: ToggleStyle {
        func makeBody(configuration: Configuration) -> some View {
            return HStack {
                Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(configuration.isOn ? .blue : .gray)
                    .onTapGesture {
                        configuration.isOn.toggle()
                    }
                configuration.label
            }
        }
    }
    
    struct HousePostingView_Previews: PreviewProvider {
        static var previews: some View {
            HousePostingView()
        }
    }
}
