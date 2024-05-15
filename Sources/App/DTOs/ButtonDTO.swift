//
//  File.swift
//  
//
//  Created by Artemiy Zuzin on 15.05.2024.
//

import Foundation

struct ButtonDTO {
    struct Create: Encodable {
        var data: Data
        var title: String
    }
    
    struct Output: Decodable {
        var id: UUID?
        var fileID: UUID
        var title: String
        var questID: UUID
    }
}
