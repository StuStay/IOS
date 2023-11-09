import SwiftUI
import MapKit

struct ListingDetailView: View {
    @State private var currentPage = 0
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 36.69912, longitude: 10.35078),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    @State private var isFavorite = false

    var images = [
        "listing-1",
        "listing-2",
        "listing-3",
        "listing-4",
    ]

    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            ScrollView {
                ZStack(alignment: .topLeading) {
                    ListingImageCarouselView()
                        .frame(height: 320)

                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                            .background(
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 32, height: 32)
                            )
                            .padding(32)
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Ariana Villa")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.cyan)

                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                        Text("4.86 - 28 reviews")
                            .underline()    
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                    }

                    Text("Ariana, Tunis")
                        .font(.caption)
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)

                Divider()

                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Entire villa hosted by Ons Bouhjar")
                            .font(.headline)
                            .frame(maxWidth: 250, alignment: .leading)

                        HStack(spacing: 2) {
                            Text("44 guests -")
                            Text("4 bedrooms -")
                            Text("4 beds -")
                            Text("3 baths")
                        }
                        .font(.caption)
                    }
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
                                .font(.title3)
                                .foregroundColor(.yellow)

                            VStack(alignment: .leading) {
                                Text("Superhost")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                Text("Experienced, highly rated hosts committed to providing great stays for guests.")
                                    .font(.callout)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                .padding()

                Divider()

                VStack(alignment: .leading, spacing: 16) {
                    Text("Where you'll sleep")
                        .font(.headline)

                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 16) {
                            ForEach(1 ..< 5) { bedroom in
                                VStack {
                                    Image(systemName: "bed.double")
                                        .font(.title3)
                                        .foregroundColor(.blue)

                                    Text("Bedroom \(bedroom)")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                }
                                .frame(width: 132, height: 100)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray, lineWidth: 1)
                                        .foregroundColor(.gray)
                                )
                            }
                        }
                    }
                    .padding()

                    Divider()

                    VStack(alignment: .leading, spacing: 16) {
                        Text("What this place offers")
                            .font(.headline)

                        HStack {
                            Image(systemName: "wifi")
                                .frame(width: 32)
                                .foregroundColor(.blue)

                            Text("Free Wifi")
                                .font(.subheadline)
                            Spacer()
                        }

                        HStack {
                            Image(systemName: "alarm")
                                .frame(width: 32)
                                .foregroundColor(.blue)
                            Text("Alarm")
                                .font(.subheadline)
                            Spacer()
                        }

                        HStack {
                            Image(systemName: "tv")
                                .frame(width: 32)
                                .foregroundColor(.blue)
                            Text("TV")
                                .font(.subheadline)
                            Spacer()
                        }

                        HStack {
                            Image(systemName: "car.fill")
                                .frame(width: 32)
                                .foregroundColor(.blue)
                            Text("Parking")
                                .font(.subheadline)
                            Spacer()
                        }
                    }
                    .padding()

                    Divider()

                    VStack(alignment: .leading, spacing: 16) {
                        Text("Where you'll be")
                            .font(.headline)
                            .padding(.bottom, 8)

                        Map(coordinateRegion: $region)
                            .frame(height: 200)
                            .cornerRadius(12)
                    }
                    .padding()
                }
            }
            .ignoresSafeArea()

            Spacer()

            HStack {
                Spacer()
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
                        Button {
                            // Add action for "Reserve" button here
                        } label: {
                            Text("Reserve")
                                .foregroundColor(.white)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .frame(width: 140, height: 40)
                                .background(Color.cyan)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                    .padding(.horizontal, 32)

                    Button(action: {
                        // Add action for favorite button here
                        isFavorite.toggle()
                    }) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(isFavorite ? .cyan : .gray)
                            .font(.title)
                            .padding()
                    }
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
