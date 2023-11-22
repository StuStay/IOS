//
//  Payment.swift
//  StuStay
//
//  Created by yassine on 22/11/2023.
//

import Foundation

struct Payment: Decodable {
    var id: String
    var amount: Int
    var date: Date
    var method: String
    var numberOfRoommates: Int?
    var isRecurringPayment: Bool
    var recurringPaymentFrequency: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id" // Map _id to id
        case amount
        case date
        case method
        case numberOfRoommates
        case isRecurringPayment
        case recurringPaymentFrequency
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        amount = try container.decode(Int.self, forKey: .amount)

        // Custom date decoding strategy for date
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Ensure a fixed locale
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // Adjust the format according to your server's response

        if let dateValue = try? container.decode(String.self, forKey: .date),
           let date = dateFormatter.date(from: dateValue) {
            self.date = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .date, in: container, debugDescription: "Cannot decode date")
        }

        method = try container.decode(String.self, forKey: .method)
        numberOfRoommates = try container.decode(Int.self, forKey: .numberOfRoommates)
        isRecurringPayment = try container.decode(Bool.self, forKey: .isRecurringPayment)
        recurringPaymentFrequency = try container.decode(String.self, forKey: .recurringPaymentFrequency)
    }
}
