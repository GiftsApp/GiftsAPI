//
//  File.swift
//  
//
//  Created by Artemiy Zuzin on 15.05.2024.
//

import Foundation
import Vapor

struct FileDTO {
    struct Create: Content {
        var data: Data
    }
    
    struct Output: Content {
        var id: UUID?
        var data: Data
    }
}
