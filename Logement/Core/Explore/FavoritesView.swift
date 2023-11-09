//
//  FavoritesView.swift
//  Logement
//
//  Created by Yassine ezzar on 9/11/2023.
//

import SwiftUI

struct FavoritesView: View {
    // Replace this data with your actual data structure
    @State private var favoriteItems = [
        FavoriteItem(name: "Ariana Villa", location: "Ariana, Tunis"),
        // Add more items as needed
    ]

    var body: some View {
        NavigationView {
            List {
                ForEach(favoriteItems) { item in
                    NavigationLink(destination: ListingDetailView()) {
                        FavoriteItemRow(item: item)
                    }
                }
                .onDelete(perform: deleteItem)
            }
            .navigationTitle("Favorites")
        }
    }

    private func deleteItem(at offsets: IndexSet) {
        favoriteItems.remove(atOffsets: offsets)
    }
}

struct FavoriteItem: Identifiable {
    let id = UUID()
    let name: String
    let location: String
    // Add more properties as needed
}

struct FavoriteItemRow: View {
    let item: FavoriteItem

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.headline)
                Text(item.location)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Image(systemName: "heart.fill")
                .foregroundColor(.red)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(radius: 3)
        )
        .padding(.horizontal)
    }
}


struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
