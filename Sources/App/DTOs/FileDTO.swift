//
//  File.swift
//  
//
//  Created by Artemiy Zuzin on 15.05.2024.
//

import Foundation

struct FileDTO {
    struct Create: Encodable {
        var data: Data
    }
    
    struct Output: Decodable {
        var id: UUID?
        var data: Data
    }
}
