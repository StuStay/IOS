import SwiftUI
struct LogementCardView: View {
    var logement: Logement
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(logement.titre ?? "")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(logement.description ?? "")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack {
                Image(systemName: "bed.double.fill")
                    .foregroundColor(.blue)
                Text("Chambres: \(logement.nombreChambre)")
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Image(systemName: "creditcard.fill")
                    .foregroundColor(.green)
                Text("Prix: \(logement.prix) TND")
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Image(systemName: "phone.fill")
                    .foregroundColor(.purple)
                Text("Contact: \(logement.contact ?? "")")
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Image(systemName: "location.fill")
                    .foregroundColor(.orange)
                Text("Lieu: \(logement.lieu ?? "")")
                    .foregroundColor(.secondary)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white)
                .shadow(radius: 5)
        )
        .padding(.horizontal, 16)
    }
}
