//
//  Botresponse.swift
//  Reclamation
//
//  Created by Yassine ezzar on 14/11/2023.
//

import Foundation

func getBotResponse(message: String) -> String {
    
    let tempMessage = message.lowercased()
    if tempMessage.contains("hello") {
        return "hey there ! "
        
    } else if tempMessage.contains("goodbye") {
        return "talk to you later"
    } else if tempMessage.contains("how are you ? ") {
        return " I'm fine , you ? "
    } else {
        return "that's cool "
    }
}
