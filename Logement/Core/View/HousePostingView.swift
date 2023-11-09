import SwiftUI

struct HousePostingView: View {
    @State private var houseTitle = ""
    @State private var houseDescription = ""
    @State private var numberOfRooms = 1
    @State private var price = ""
    @State private var selectedImage: Image?
    @State private var isImagePickerPresented = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Section(header: Text("House Details")) {
                        TextField("House Title", text: $houseTitle)
                        TextField("Description", text: $houseDescription)
                        Stepper("Number of Rooms: \(numberOfRooms)", value: $numberOfRooms, in: 1...10)
                        TextField("Price per Night", text: $price)
                    }

                    Section(header: Text("Upload Images")) {
                        if let selectedImage = selectedImage {
                            selectedImage
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .cornerRadius(12)
                        } else {
                            Button("Upload Image") {
                                isImagePickerPresented.toggle()
                            }
                            .fileImporter(
                                isPresented: $isImagePickerPresented,
                                allowedContentTypes: [.image],
                                onCompletion: handleImageSelection
                            )
                        }
                    }

                    Section {
                        Button("Post House") {
                            // Implement the logic to post the house
                            // You can use the gathered data like houseTitle, houseDescription, numberOfRooms, price, etc.
                        }
                        .buttonStyle(PrimaryButtonStyle())
                    }
                }
                .padding()
            }
            .navigationTitle("Post Your House")
        }
    }

    private func handleImageSelection(result: Result<URL, Error>) {
        if case .success(let url) = result {
            if let data = try? Data(contentsOf: url),
               let uiImage = UIImage(data: data) {
                selectedImage = Image(uiImage: uiImage)
            }
        }
    }
}

struct HousePostingView_Previews: PreviewProvider {
    static var previews: some View {
        HousePostingView()
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundColor(.white)
            .background(configuration.isPressed ? Color.blue.opacity(0.8) : Color.blue)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.blue, lineWidth: 2)
                    .opacity(configuration.isPressed ? 0 : 1)
            )
    }
}
