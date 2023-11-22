import Foundation
import SwiftUI
struct Logement: Decodable, Identifiable {
    var id: String
    var images: String
    var titre: String
    var description: String
    var nom: String
    var nombreChambre: Int
    var prix: Int
    var contact: String
    var lieu: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case images
        case titre
        case description
        case nom
        case nombreChambre
        case prix
        case contact
        case lieu
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.images = try container.decode(String.self, forKey: .images)
        self.titre = try container.decode(String.self, forKey: .titre)
        self.description = try container.decode(String.self, forKey: .description)
        self.nom = try container.decode(String.self, forKey: .nom)
        
        if let nombreChambreString = try? container.decode(String.self, forKey: .nombreChambre),
            let nombreChambreInt = Int(nombreChambreString) {
            self.nombreChambre = nombreChambreInt
        } else if let nombreChambreInt = try? container.decode(Int.self, forKey: .nombreChambre) {
            self.nombreChambre = nombreChambreInt
        } else {
            throw DecodingError.dataCorruptedError(forKey: .nombreChambre, in: container, debugDescription: "Cannot decode nombreChambre")
        }
        
        self.prix = try container.decode(Int.self, forKey: .prix)
        self.contact = try container.decode(String.self, forKey: .contact)
        self.lieu = try container.decode(String.self, forKey: .lieu)
    }

}
