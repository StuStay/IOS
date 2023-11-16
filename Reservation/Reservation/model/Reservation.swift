//
//  File.swift
//  Reservation
//
//  Created by Mac-Mini_2021 on 16/11/2023.
//

import Foundation
import SwiftUI
struct Reservation: Identifiable, Codable {
    var id: UUID
    var name: String
    var location: String
    var selectedgender: String
    var checkInDate: Date
    var checkOutDate: Date
    var phone: String // New attribute
    var numberOfRoommates: Int // New attribute
    var minPrice: String // New attribute
    var maxPrice: String // New attribute
}
