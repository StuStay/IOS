import SwiftUI

struct AnnouncedDetailView: View {
    @Binding var annonces: [Annonce]
    let index: Int

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Existing code for displaying announcement details

                // Button for deleting the announcement
                Button(action: {
                    annonces.remove(at: index)
                }) {
                    Text("Delete Announcement")
                        .font(.custom("Montserrat", size: 16))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(8)
                }
            }
            .padding()
        }
        .navigationBarTitle("Announcement Detail")
    }
}

