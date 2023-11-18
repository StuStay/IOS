// Logement.swift
import Foundation

struct Logement: Decodable, Identifiable {
    var id: String
    var images: [String]
    var titre: String
    var description: String
    var nom: String
    var nombreChambre: Int
    var prix: Int
    var contact: String
    var lieu: String

    enum CodingKeys: String, CodingKey {
        case id = "_id" // Map _id to id
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

        id = try container.decode(String.self, forKey: .id)
        images = try container.decode([String].self, forKey: .images)
        titre = try container.decode(String.self, forKey: .titre)
        description = try container.decode(String.self, forKey: .description)
        nom = try container.decode(String.self, forKey: .nom)
        nombreChambre = try container.decode(Int.self, forKey: .nombreChambre)
        prix = try container.decode(Int.self, forKey: .prix)
        contact = try container.decode(String.self, forKey: .contact)
        lieu = try container.decode(String.self, forKey: .lieu)
    }
}
