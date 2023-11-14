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
                            isShowingMessage = true
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
}

struct HousePostingView_Previews: PreviewProvider {
    static var previews: some View {
        HousePostingView()
    }
}
