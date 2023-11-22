//
//  ReclamationsService.swift
//  StuStay
//
//  Created by yassine on 22/11/2023.
//

import Foundation

enum ReclamationError: Error {
    case invalidURL
    case requestFailed
    case invalidResponse
    case decodingError
}

class ReclamationsService {
    static let shared = ReclamationsService()

    private let baseURL = "http://localhost:3000/reclamations/"

    func Reclamationadd(IdUser: String, title: String, description: String, type: String, state: String, severity: String, completion: @escaping (Result<String, Error>) -> Void) {
        let urlString = baseURL
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        let parameters: [String: Any] = [
            "IdUser":IdUser,
            "title":title,
            "description":description,
            "type":type,
            "state":state,
            "severity":severity,
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
                completion(.failure(ReclamationError.invalidResponse))
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
    
    func getReclamation(completion: @escaping (Result<[Reclamation], Error>) -> Void) {
        let urlString = baseURL
        guard let url = URL(string: urlString) else {
            completion(.failure(ReclamationError.invalidURL))
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
                     let reclamations = try JSONDecoder().decode([Reclamation].self, from: data)
                     completion(.success(reclamations))
                 } catch {
                     completion(.failure(error))
                 }
             }

             task.resume()
         }
    
    func deleteReclamation(ReclamationID: String, completion: @escaping (Result<String, Error>) -> Void) {
        let urlString = "\(baseURL)/\(ReclamationID)"
        guard let url = URL(string: urlString) else {
            completion(.failure(ReclamationError.invalidURL))
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
