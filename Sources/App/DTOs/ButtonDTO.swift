//
//  File.swift
//  
//
//  Created by Artemiy Zuzin on 15.05.2024.
//

import Foundation
import Vapor

struct ButtonDTO {
    struct Create: Content {
        var data: Data
        var title: String
    }
    
    struct Output: Content {
        var id: UUID?
        var fileID: UUID
        var title: String
        var questID: UUID
        var isTapped: Bool
    }
}
