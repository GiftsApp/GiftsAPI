//
//  File.swift
//  
//
//  Created by Artemiy Zuzin on 15.05.2024.
//

import Foundation
import Vapor

struct QuestDTO {
    struct Create: Content {
        var title: String
        var description: String
        var count: Int
        var data: Data
        var buttons: [ButtonDTO.Create]
    }
    
    struct MiniOutput: Content {
        var id: UUID?
        var title: String
        var count: Int
        var fileID: UUID
    }
    
    struct Output: Content {
        var id: UUID?
        var title: String
        var description: String
        var count: Int
        var fileID: UUID
        var buttons: [ButtonDTO.Output]
    }
}
