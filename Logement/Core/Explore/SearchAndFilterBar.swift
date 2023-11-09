import SwiftUI

struct SearchAndFilterBar: View {
    @State private var showAdvancedSearch = false

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")

            VStack(alignment: .leading, spacing: 2) {
                Text("Where to?")
                    .font(.footnote)
                    .fontWeight(.semibold)
                Text("Anywhere - Any Week - Add guests")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }

            Spacer()

            Button(action: {
                showAdvancedSearch.toggle()
            }) {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .foregroundStyle(.cyan)
            }
            .sheet(isPresented: $showAdvancedSearch) {
                // Incomplete
                Text("Advanced Search View")
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .overlay {
            Capsule()
                .stroke(lineWidth: 0.5)
                .foregroundStyle(Color(.systemGray4))
                .shadow(color: .black.opacity(0.4), radius: 2)
        }
    }
}

struct SearchAndFilterBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchAndFilterBar()
    }
}




