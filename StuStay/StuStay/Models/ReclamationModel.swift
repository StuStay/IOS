//
//  ReclamationModel.swift
//  StuStay
//
//  Created by yassine on 22/11/2023.
//

import Foundation
import SwiftUI

struct Reclamation: Decodable {
    let IdUser: String
    var title: String
    var description: String
    var type: String
    var state: String
    var severity: String

    enum CodingKeys: String, CodingKey {
        case IdUser = "_id"
        case title
        case description
        case type
        case state
        case severity
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        IdUser = try container.decode(String.self, forKey: .IdUser)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        type = try container.decode(String.self, forKey: .type)
        state = try container.decode(String.self, forKey: .state)
        severity = try container.decode(String.self, forKey: .severity)
    }
}
