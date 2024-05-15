//
//  File.swift
//  
//
//  Created by Artemiy Zuzin on 15.05.2024.
//

import Foundation

struct UserDTO {
    struct Create: Encodable {
        var id: String
        var queryID: String
        var name: String
        var languageCode: String?
        var photoURL: String?
        var friendID: User.IDValue?
    }
    
    struct MiniOutput: Decodable {
        var id: String
        var queryID: String
        var name: String
        var photoURL: String?
        var silverBalance: Int
        var goldBalance: Int
        var energyLVL: Int
        var tapLVL: Int
        var energy: Int
        var completedQuestsID: [UUID]
    }
    
    struct Output: Decodable {
        var id: String
        var name: String
        var photoURL: String?
        var silverBalance: Int
        var goldBalance: Int
        var energyLVL: Int
        var tapLVL: Int
        var energy: Int
        var completedQuestsID: [UUID]
        var ticketsID: [UUID]
    }
}
