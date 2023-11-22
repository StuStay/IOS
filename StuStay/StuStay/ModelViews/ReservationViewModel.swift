//
//  ReservationViewModel.swift
//  StuStay
//
//  Created by yassine on 22/11/2023.
//


import Foundation
class ReservationViewModel: ObservableObject {
    @Published  var name: String = ""
    @Published  var location: String = ""
    @Published  var selectedgender: String=""
    @Published  var checkInDate: Date = Date()
    @Published  var checkOutDate: Date = Date()
    @Published  var phone: String = "" // New attribute
    @Published  var numberOfRoommates: Int = 0 // New attribute
    @Published  var minPrice: String = ""// New attribute
    @Published  var maxPrice: String = ""

    @Published var reservations: [Reservation] = [] // Declare the reservations property

    func addReservation() {
         
            ReservationService.shared.ReservationAdd(
                name:name,
                location:location,
                selectedgender:selectedgender,
                checkInDate:checkInDate,
                checkOutDate:checkOutDate,
                phone:phone,
                numberOfRoommates:numberOfRoommates,
                minPrice:minPrice,
                maxPrice:maxPrice
            ) { result in
                switch result {
                case .success(let message):
          
                    print("Success: \(message)")
                case .failure(let error):
           
                    print("Error: \(error)")
                }
            }
        }
        
    func fetchReservations() {
        ReservationService.shared.getReservation { result in
            DispatchQueue.main.async { // Ensure updates on the main thread
                switch result {
                case .success(let reservations):
                    self.reservations = reservations
                    print("Fetched \(reservations.count) reservations.")
                case .failure(let error):
                    print("Error fetching reservations: \(error)")
                }
            }
        }
    }
    func deleteReservation(reservationID: String) {
        ReservationService.shared.deleteReservation(reservationID: reservationID) { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("Success: Reservation deleted successfully")
                    // Optionally, you may want to fetch updated reservations after deleting one
                    self.fetchReservations()

                case .failure(let error):
                    print("Error deleting reservation: \(error)")
                    // Optionally, you may want to show an alert or handle the error in some way
                }
            }
        }
    }




}
