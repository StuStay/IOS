//
//  testnavbarview.swift
//  Logement
//
//  Created by Yassine ezzar on 18/11/2023.
//

/*import SwiftUI


struct Annonce: Identifiable {
    let id = UUID()
    let titre: String
    let description: String
    let nombreChambre: String
    let prix: String
    let lieu: String
    let images: [UIImage]
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var isPresented: Bool

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        @Binding var image: UIImage?
        @Binding var isPresented: Bool

        init(image: Binding<UIImage?>, isPresented: Binding<Bool>) {
            _image = image
            _isPresented = isPresented
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                image = uiImage
            }

            isPresented = false
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            isPresented = false
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(image: $image, isPresented: $isPresented)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // No update needed
    }
}

struct AddLogementView: View {
    
    @State private var annonces: [Annonce] = []
    @State private var titre: String = ""
    @State private var description: String = ""
    @State private var nombreChambre: String = ""
    @State private var prix: String = ""
    @State private var lieu: String = ""
    @State private var showImagePicker: Bool = false
    @State private var selectedImage: UIImage? = nil
    @State private var selectedTab: Int? = 0

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Détails du Logement").font(.custom("Montserrat", size: 24))) {
                        TextField("Titre", text: $titre).font(.custom("Montserrat", size: 16))
                        TextField("Description", text: $description).font(.custom("Montserrat", size: 16))
                        TextField("Nombre de Chambres", text: $nombreChambre).font(.custom("Montserrat", size: 16)).keyboardType(.numberPad)
                        TextField("Prix", text: $prix).font(.custom("Montserrat", size: 16)).keyboardType(.numberPad)
                        TextField("Lieu", text: $lieu).font(.custom("Montserrat", size: 16))
                    }.padding(.vertical, 10)

                    Section(header: Text("Images").font(.custom("Montserrat", size: 24))) {
                        if selectedImage != nil {
                            Image(uiImage: selectedImage!).resizable().scaledToFit().frame(height: 100)
                        }

                        Button(action: {
                            showImagePicker = true
                        }) {
                            Text("Uploader des Images").font(.custom("Montserrat", size: 16)).foregroundColor(.blue)
                        }
                    }

                    Section {
                        Button(action: {
                            // Create a new Annonce instance
                            let annonce = Annonce(titre: titre, description: description, nombreChambre: nombreChambre, prix: prix, lieu: lieu, images: [selectedImage].compactMap { $0 })

                            // Append the new annonce to the list
                            annonces.append(annonce)

                            // Clear the form
                            titre = ""
                            description = ""
                            nombreChambre = ""
                            prix = ""
                            lieu = ""
                            selectedImage = nil
                        }) {
                            Text("Poster l'Annonce").font(.custom("Montserrat", size: 16)).foregroundColor(.white).padding().background(Color.cyan).cornerRadius(8)
                        }
                    }.frame(maxWidth: .infinity, alignment: .center)

                    Section(header: Text("Annonces").font(.custom("Montserrat", size: 24))) {
                        ForEach(annonces) { annonce in
                            NavigationLink(destination: AnnouncedDetailView(annonce: annonce)) {
                                Text(annonce.titre).font(.custom("Montserrat", size: 16))
                            }
                        }
                        .onDelete { indexSet in
                                                    annonces.remove(atOffsets: indexSet)
                                                }
                    }
                }
                
                .navigationBarTitle("Poster une Annonce")
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(image: $selectedImage, isPresented: $showImagePicker)
                }
            }
            .tabItem {
                            Label("Add Annonce", systemImage: "plus.circle.fill")
                        }
          
        }
          TabView{
        ProfileVieww()
            .tabItem{
                Label("profile",systemImage: "person.circle")
            }
                ReclameView()
                    .tabItem{
                        Label("Reclamation",systemImage: "megaphone")
                    }
        PaymentView()
            .tabItem{
                Label("Payement",systemImage: "calendar")
            }
            
    }
    }
    private var bottomNavigationBar: some View {
        HStack {
            Spacer()
            HStack(spacing: 32) {
                TabView{
                    ProfileVieww()
                        .tabItem{
                            Label("profile",systemImage: "person.circle")
                        }
                            ReclameView()
                                .tabItem{
                                    Label("Reclamation",systemImage: "megaphone")
                                }
                    PaymentView()
                        .tabItem{
                            Label("Payement",systemImage: "calendar")
                        }
                        
                }
            }
            .padding()
            Spacer()
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.bottom)
    }
    
    }

  

    


struct AnnouncedDetailView: View {
    let annonce: Annonce

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(annonce.images, id: \.self) { image in
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                }

                Text("Titre: \(annonce.titre)")
                    .font(.title)
                    .foregroundColor(.cyan)

                Text("Description: \(annonce.description)")
                    .foregroundColor(.gray)

                Text("Nombre de Chambres: \(annonce.nombreChambre)")
                    .foregroundColor(.gray)

                Text("Prix: \(annonce.prix)")
                    .foregroundColor(.gray)

                Text("Lieu: \(annonce.lieu)")
                    .foregroundColor(.gray)

                Spacer()
            }
            .padding()
        }
        .navigationBarTitle("Announcement Detail")
    }
}

struct AddLogementView_Previews: PreviewProvider {
    static var previews: some View {
        AddLogementView()
    }
}

struct testnavbarview: View {
    var body: some View {
        TabView{
            ProfileVieww()
                .tabItem{
                    Label("profile",systemImage: "person.circle")
                }
                    ReclameView()
                        .tabItem{
                            Label("Reclamation",systemImage: "megaphone")
                        }
            PaymentView()
                .tabItem{
                    Label("Payement",systemImage: "calendar")
                }
                
        }
    }
    
    struct testnavbarview_Previews: PreviewProvider {
        static var previews: some View {
            testnavbarview()
        }
    }
 }/**/*/
