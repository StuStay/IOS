import SwiftUI
import MapKit

struct ListingDetailView: View {
    @State private var currentPage = 0
    @State private var region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), // Set your initial coordinates
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05) // Set your initial span
        )

    var images = [
        "listing-1",
        "listing-2",
        "listing-3",
        "listing-4",
    ]

    @Environment(\.dismiss) var dismiss

    var body: some View {
        ScrollView {
            ZStack(alignment: .topLeading) {
                ListingImageCarouselView()
                    .frame(height: 320)

                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.black)
                        .background(
                            Circle()
                                .fill(Color.white)
                                .frame(width: 32, height: 32)
                        )
                        .padding(32)
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Miami Villa")
                    .font(.title)
                    .fontWeight(.semibold)

                VStack(alignment: .leading) {
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                        Text("4.86 - 28 reviews")
                            .underline()
                            .fontWeight(.semibold)
                    }
                    .foregroundStyle(.black)
                    Text("Ariana, Tunis")
                }
                .font(.caption)
            }
            .padding(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)

            Divider()

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Entire villa hosted by John Smith")
                        .font(.headline)
                        .frame(width: 250, alignment: .leading)
                    HStack(spacing: 2) {
                        Text("44 guests -")
                        Text("4 bedrooms -")
                        Text("4 beds -")
                        Text("3 baths")
                    }
                    .font(.caption)
                }
                .frame(width: 300, alignment: .leading)
                Spacer()
                Image("male-profile-photo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 64, height: 64)
                    .clipShape(Circle())
            }
            .padding()

            Divider()

            VStack(alignment: .leading, spacing: 16) {
                ForEach(0 ..< 2) { feature in
                    HStack(spacing: 12) {
                        Image(systemName: "medal")
                        VStack(alignment: .leading) {
                            Text("Superhost")
                                .font(.footnote)
                                .fontWeight(.semibold)
                            Text("Superhosts are experienced, highly rated hosts who are committed to providing great stays for guests")
                                .font(.caption)
                                .foregroundStyle(.gray)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()

            Divider()

            VStack(alignment: .leading, spacing: 16) {
                Text("Where you'll sleep")
                    .font(.headline)
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 16) {
                        ForEach(1 ..< 5, id: \.self) { bedroom in
                            VStack {
                                Image(systemName: "bed.double")
                                Text("Bedroom \(bedroom)")
                            }
                            .frame(width: 132, height: 100)
                            .overlay {
                                RoundedRectangle(cornerSize: CGSize(width: 12, height: 12))
                                    .stroke(Color.gray, lineWidth: 1)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                .padding()

                Divider()

                VStack(alignment: .leading, spacing: 16) {
                    Text("What this place offers")
                        .font(.headline)
                    ForEach(0 ..< 5) { feature in
                        HStack {
                            Image(systemName: "wifi")
                                .frame(width: 32)
                            Text("Wifi")
                                .font(.footnote)
                            Spacer()
                        }
                    }
                }
                .padding()

                Divider()

                VStack(alignment: .leading, spacing: 16) {
                         Text("Where you'll be")
                             .font(.headline)
                             .frame(height: 200)
                             .clipShape(RoundedRectangle(cornerRadius: 12))
                         
                         Map(coordinateRegion: $region)
                             .frame(height: 200)
                             .cornerRadius(12)
                     }
                     .padding()
                 }

            Spacer().ignoresSafeArea()
                .padding(.bottom, 63)

            .overlay(alignment: .bottom) {
                VStack {
                    Divider()
                        .padding(.bottom)
                    HStack {
                        VStack(alignment: .leading) {
                            Text("DT500")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Text("Total before taxes")
                                .font(.footnote)
                            Text("Oct 15 - 20")
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .underline()
                        }
                        Spacer()
                        Button(action: {
                            // Add action for "Reserve" button here
                        }) {
                            Text("Reserve")
                                .foregroundStyle(.white)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .frame(width: 140, height: 40)
                                .background(Color.pink)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                    .padding(.horizontal, 32)
                }
                .background(Color.white)
            }
        }
    }
}

struct ListingDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ListingDetailView()
    }
}
