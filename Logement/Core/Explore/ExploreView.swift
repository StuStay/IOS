import SwiftUI

struct ExploreView: View {
    @State private var selectedTab: Int? = 0

    var body: some View {
        NavigationView {
            ScrollView {
                SearchAndFilterBar()
                LazyVStack(spacing: 32) {
                    ForEach(0 ... 10, id: \.self) { listing in
                        NavigationLink(destination: ListingDetailView().navigationBarBackButtonHidden()) {
                            ListingItemView()
                                .frame(height: 400)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                }
                .padding()
            }
            .navigationDestination(for: Int.self) { listing in
                ListingDetailView()
                    .navigationBarBackButtonHidden()
            }
            .navigationBarTitle("Explore", displayMode: .inline)
            .navigationBarHidden(true)
            .overlay(bottomNavigationBar, alignment: .bottom)
        }
    }

    private var bottomNavigationBar: some View {
        HStack {
            Spacer()
            HStack(spacing: 32) {
                NavigationLink(destination: ProfileView(), tag: 0, selection: $selectedTab) {
                    Image(systemName: "person.circle")
                        .font(.system(size: 24))
                        .foregroundColor(selectedTab == 0 ? Color.cyan : Color.gray)
                        .scaleEffect(selectedTab == 0 ? 1.2 : 1.0)
                        .animation(.spring())
                }

                NavigationLink(destination: FavoritesView(), tag: 1, selection: $selectedTab) {
                    Image(systemName: "heart")
                        .font(.system(size: 24))
                        .foregroundColor(selectedTab == 1 ? Color.cyan : Color.gray)
                        .scaleEffect(selectedTab == 1 ? 1.2 : 1.0)
                        .animation(.spring())
                }

                NavigationLink(destination: ReservationsView(), tag: 2, selection: $selectedTab) {
                    Image(systemName: "calendar")
                        .font(.system(size: 24))
                        .foregroundColor(selectedTab == 2 ? Color.cyan : Color.gray)
                        .scaleEffect(selectedTab == 2 ? 1.2 : 1.0)
                        .animation(.spring())
                }

                NavigationLink(destination: ReclameView(), tag: 3, selection: $selectedTab) {
                    Image(systemName: "megaphone")
                        .font(.system(size: 24))
                        .foregroundColor(selectedTab == 3 ? Color.cyan : Color.gray)
                        .scaleEffect(selectedTab == 3 ? 1.2 : 1.0)
                        .animation(.spring())
                }
            }
            .padding()
            Spacer()
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
