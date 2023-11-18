import SwiftUI

struct AnnouncedListView: View {
    @Binding var annonces: [Annonce]

    var body: some View {
        NavigationView {
            List {
                ForEach(annonces.indices, id: \.self) { index in
                    NavigationLink(destination: AnnouncedDetailView(annonces: $annonces, index: index)) {
                        Text(annonces[index].titre).font(.custom("Montserrat", size: 16))
                    }
                }
                .onDelete { indexSet in
                    annonces.remove(atOffsets: indexSet)
                }
            }
            .navigationBarTitle("Annonces")
        }
    }
}
