// LogementService.swift
import Foundation

enum LogementError: Error {
    case invalidURL
    case requestFailed
    case invalidResponse
    case decodingError
}

class LogementService {
    static let shared = LogementService()

    private let baseURL = "http://localhost:3000/api/logements/logement"
    
    func addLogement(logement: Logement, completion: @escaping (Result<Logement, Error>) -> Void) {
        let urlString = baseURL
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(logement)
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
                completion(.failure(LogementError.invalidResponse))
                return
            }
            
            do {
                let newLogement = try JSONDecoder().decode(Logement.self, from: data)
                completion(.success(newLogement))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func getLogements(completion: @escaping (Result<[Logement], Error>) -> Void) {
        let urlString = baseURL
        guard let url = URL(string: urlString) else {
            completion(.failure(LogementError.invalidURL))
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
                completion(.failure(LogementError.invalidResponse))
                return
            }
            
            do {
                let logements = try JSONDecoder().decode([Logement].self, from: data)
                completion(.success(logements))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func deleteLogement(logementID: String, completion: @escaping (Result<String, Error>) -> Void) {
        let urlString = "\(baseURL)/\(logementID)"
        guard let url = URL(string: urlString) else {
            completion(.failure(LogementError.invalidURL))
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
                completion(.failure(LogementError.invalidResponse))
                return
            }

            do {
                // Check if the response contains a message
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let message = json?["message"] as? String {
                    completion(.success(message))
                } else {
                    // If there's no message, consider it as a failure
                    completion(.failure(LogementError.invalidResponse))
                }
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
/*import Foundation

enum LogementError: Error {
    case invalidURL
    case requestFailed
    case invalidResponse
    case decodingError
}

class LogementService {
    static let shared = LogementService()

    private let baseURL = "http://localhost:3000/api/logements"

    func addLogement(logement: Logement, completion: @escaping (Result<Logement, Error>) -> Void) {
        let urlString = baseURL
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(logement)
        } catch {
            completion(.failure(error))
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(LogementError.invalidResponse))
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(LogementError.invalidResponse))
                return
            }

            do {
                let newLogement = try JSONDecoder().decode(Logement.self, from: data!)
                completion(.success(newLogement))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }

    func getLogements(completion: @escaping (Result<[Logement], Error>) -> Void) {
        let urlString = baseURL
        guard let url = URL(string: urlString) else {
            completion(.failure(LogementError.invalidURL))
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

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(LogementError.invalidResponse))
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(LogementError.invalidResponse))
                return
            }

            do {
                let logements = try JSONDecoder().decode([Logement].self, from: data!)
                completion(.success(logements))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }

    func deleteLogement(logementID: String, completion: @escaping (Result<String, Error>) -> Void) {
        let urlString = "\(baseURL)/\(logementID)"
        guard let url = URL(string: urlString) else {
            completion(.failure(LogementError.invalidURL))
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

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(LogementError.invalidResponse))
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(LogementError.invalidResponse))
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                if let message = json?["message"] as? String {
                    completion(.success(message))
                } else {
                    completion(.failure(LogementError.invalidResponse))
                }
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
