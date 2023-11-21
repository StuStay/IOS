//
//  ReclamationModel.swift
//  Reclamation
//
//  Created by Yassine ezzar on 8/11/2023.
//

import Foundation

struct Report: Decodable {
    var title: String
    var description: String
    var type: String
    var state: String
    var severity: String
}
