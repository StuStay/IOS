

import Foundation
import SwiftUI
struct Logement: Identifiable, Codable{
    var id: String
    var images: [String]
    var titre: String
    var description: String
    var nom: String
    var nombreChambre: Int
    var prix: Int
    var contact: String
    var lieu: String
}
