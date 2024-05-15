//
//  File.swift
//  
//
//  Created by Artemiy Zuzin on 15.05.2024.
//

import Foundation

struct AdminTokenDTO {
    struct Output: Decodable {
        var id: UUID?
        var value: String
    }
}
