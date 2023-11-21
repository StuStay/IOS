//
//  ReclamationsService.swift
//  Reclamation
//
//  Created by Yassine ezzar on 19/11/2023.
//

import Foundation

enum ReclamationError: Error {
    case invalidURL
    case requestFailed
    case invalidResponse
    case decodingError
}

class ReclamationService {
    static let shared = ReclamationService()

    private let baseURL = "http://localhost:3000/Reclamations/ "
    
    func Reclamationsadd(title: String, description: String, type: String, state: String, severity: String, completion: @escaping (Result<Reclamation, Error>) -> Void) {
        let urlString = baseURL
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        let parameters: [String: Any] = [
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
                        let newReclamation = try JSONDecoder().decode(Reclamation.self, from: data)
                        completion(.success(newReclamation))
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
                completion(.failure(ReclamationError.invalidResponse))
                return
            }
            
            do {
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
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

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
                // Check if the response contains a message
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let message = json?["message"] as? String {
                    completion(.success(message))
                } else {
                    // If there's no message, consider it as a failure
                    completion(.failure(ReclamationError.invalidResponse))
                }
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }

    }
