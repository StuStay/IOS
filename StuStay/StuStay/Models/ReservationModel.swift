//
//  ReservationModel.swift
//  StuStay
//
//  Created by yassine on 22/11/2023.
//

import Foundation

struct Reservation: Decodable {
    var id: String
    var name: String
    var location: String
    var selectedgender: String
    var checkInDate: Date
    var checkOutDate: Date
    var phone: String
    var numberOfRoommates: Int   // Changed to String type
    var minPrice: String
    var maxPrice: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case location
        case selectedgender
        case checkInDate
        case checkOutDate
        case phone
        case numberOfRoommates
        case minPrice
        case maxPrice
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        location = try container.decode(String.self, forKey: .location)
        selectedgender = try container.decode(String.self, forKey: .selectedgender)
        phone = try container.decode(String.self, forKey: .phone)
        minPrice = try container.decode(String.self, forKey: .minPrice)
        maxPrice = try container.decode(String.self, forKey: .maxPrice)

        // Decode numberOfRoommates as String and convert it to Int
        if let numberOfRoommatesString = try? container.decode(String.self, forKey: .numberOfRoommates),
           let numberOfRoommatesInt = Int(numberOfRoommatesString) {
            numberOfRoommates = numberOfRoommatesInt
        } else {
            throw DecodingError.dataCorruptedError(forKey: .numberOfRoommates, in: container, debugDescription: "Cannot decode numberOfRoommates")
        }

        // Custom date decoding strategy for checkInDate
        let iso8601DateFormatter = ISO8601DateFormatter()
        iso8601DateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        if let checkInDateISO = try? container.decode(String.self, forKey: .checkInDate),
           let checkInDateValue = iso8601DateFormatter.date(from: checkInDateISO) {
            checkInDate = checkInDateValue
        } else {
            throw DecodingError.dataCorruptedError(forKey: .checkInDate, in: container, debugDescription: "Cannot decode checkInDate")
        }

        // Custom date decoding strategy for checkOutDate
        if let checkOutDateISO = try? container.decode(String.self, forKey: .checkOutDate),
           let checkOutDateValue = iso8601DateFormatter.date(from: checkOutDateISO) {
            checkOutDate = checkOutDateValue
        } else {
            throw DecodingError.dataCorruptedError(forKey: .checkOutDate, in: container, debugDescription: "Cannot decode checkOutDate")
        }
    }
}


