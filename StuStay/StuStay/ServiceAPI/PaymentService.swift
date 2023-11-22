//
//  PaymentService.swift
//  StuStay
//
//  Created by yassine on 22/11/2023.
//

import Foundation

enum PaymentError: Error {
    case invalidURL
    case requestFailed
    case invalidResponse
    case decodingError
}

class PaymentService {
    static let shared = PaymentService()

    private let baseURL = "http://localhost:3000/api/payments"
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    func Paymentadd(amount: Int, date: Date, method: String, numberOfRoommates: Int, isRecurringPayment: Bool, recurringPaymentFrequency: String, completion: @escaping (Result<Payment, Error>) -> Void) {
        let urlString = baseURL
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        let parameters: [String: Any] = [
            "amount":amount,
            "date":dateFormatter.string(from: date),
            "method":method,
            "numberOfRoommates":numberOfRoommates,
            "isRecurringPayment":isRecurringPayment,
            "recurringPaymentFrequency":recurringPaymentFrequency
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
                completion(.failure(PaymentError.invalidResponse))
                return
            }
            
            do {
                        let newPayment = try JSONDecoder().decode(Payment.self, from: data)
                        completion(.success(newPayment))
                    } catch {
                        completion(.failure(error))
                    }
                }

                task.resume()
            }
    
    func getPayment(completion: @escaping (Result<[Payment], Error>) -> Void) {
        let urlString = baseURL
        guard let url = URL(string: urlString) else {
            completion(.failure(PaymentError.invalidURL))
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
                completion(.failure(PaymentError.invalidResponse))
                return
            }
            
            do {
                let payments = try JSONDecoder().decode([Payment].self, from: data)
                completion(.success(payments))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func deletePayment(paymentID: String, completion: @escaping (Result<String, Error>) -> Void) {
        let urlString = "\(baseURL)/\(paymentID)"
        guard let url = URL(string: urlString) else {
            completion(.failure(PaymentError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(PaymentError.invalidResponse))
                return
            }

            do {
                // Check if the response contains a message
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let message = json?["message"] as? String {
                    completion(.success(message))
                } else {
                    // If there's no message, consider it as a failure
                    completion(.failure(PaymentError.invalidResponse))
                }
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }

    }
