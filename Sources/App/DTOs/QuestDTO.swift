//
//  File.swift
//  
//
//  Created by Artemiy Zuzin on 15.05.2024.
//

import Foundation

struct QuestDTO {
    struct Create: Encodable {
        var title: String
        var description: String
        var count: Int
        var data: Data
        var buttons: [ButtonDTO.Create]
    }
    
    struct MiniOutput: Decodable {
        var title: String
        var count: Int
        var fileID: UUID
    }
    
    struct Output: Decodable {
        var title: String
        var description: String
        var count: Int
        var fileID: UUID
        var buttonsID: [UUID]
    }
}
