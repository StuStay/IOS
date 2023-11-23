import Foundation

enum LogementError: Error {
    case invalidURL
    case requestFailed
    case invalidResponse
    case decodingError
}

class LogementService {
    static let shared = LogementService()

    private let baseURL = "http://localhost:3000/api/logements"
    
    func Logementadd(images: String, titre: String, description: String, nom: String, nombreChambre: Int, prix: Int, contact: String , lieu: String , completion: @escaping (Result<String, Error>) -> Void ) {
        let urlString = baseURL
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
   let parameters: [String: Any] = [
            "images": images,
            "titre": titre,
            "description": description,
            "nom": nom,
            "nombreChambre":nombreChambre,
            "prix":prix,
            "contact":contact,
            "lieu":lieu
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
    
    func getLogement(completion: @escaping (Result<[Logement], Error>) -> Void) {
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
                    completion(.failure(LogementError.invalidResponse))
                }
            } catch {
                completion(.failure(LogementError.decodingError))
            }
        }

        task.resume()
    }
}
