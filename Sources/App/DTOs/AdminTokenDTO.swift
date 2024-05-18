//
//  File.swift
//  
//
//  Created by Artemiy Zuzin on 15.05.2024.
//

import Foundation
import Vapor

struct AdminTokenDTO {
    struct Output: Content {
        var id: UUID?
        var value: String
    }
}
