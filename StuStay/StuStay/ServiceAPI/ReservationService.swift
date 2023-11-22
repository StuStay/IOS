//
//  ReservationService.swift
//  StuStay
//
//  Created by yassine on 22/11/2023.
//

import Foundation

import Combine
enum NetworkError: Error {
    case invalidURL
    case requestFailed
    case invalidResponse
    case decodingError
}
struct ReservationService {
    static let shared = ReservationService()
    
    private let baseURL = "http://localhost:3000/api/reservations"
        private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    func ReservationAdd(name: String, location: String, selectedgender: String,checkInDate : Date, checkOutDate: Date ,phone: String,numberOfRoommates: Int,minPrice: String,maxPrice: String ,  completion: @escaping (Result<String, Error>) -> Void) {
        let urlString = baseURL
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        let parameters: [String: Any] = [
            "name": name,
            "location": location,
            "selectedgender": selectedgender,
            "checkInDate": dateFormatter.string(from: checkInDate),
            "checkOutDate":dateFormatter.string(from: checkOutDate),
            "numberOfRoommates":numberOfRoommates,
            "phone":phone,
            "minPrice":minPrice,
            "maxPrice":maxPrice
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                
                if let message = json?["message"] as? String {
                    completion(.success(message))
                } else if let errorMessage = json?["error"] as? String {
                    completion(.failure(NSError(domain: errorMessage, code: 0, userInfo: nil)))
                } else {
                    completion(.failure(NSError(domain: "Unexpected response", code: 0, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    func getReservation(completion: @escaping (Result<[Reservation], Error>) -> Void) {
    let urlString = baseURL // Replace with the appropriate URL for your GET request
    guard let url = URL(string: urlString) else {
        completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }

        guard let data = data else {
            completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
            return
        }

        do {
            // Assuming your response is an array of reservations
            let reservations = try JSONDecoder().decode([Reservation].self, from: data)
            completion(.success(reservations))
        } catch {
            completion(.failure(error))
        }
    }

    task.resume()
}
    func deleteReservation(reservationID: String, completion: @escaping (Result<String, Error>) -> Void) {
        let urlString = "\(baseURL)/\(reservationID)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "Invalid response", code: 0, userInfo: nil)))
                }
                return
            }

            // The response for a successful DELETE request might not contain valid JSON or any data to decode
            DispatchQueue.main.async {
                completion(.success("Reservation deleted successfully"))
            }
        }

        task.resume()
    }

}
