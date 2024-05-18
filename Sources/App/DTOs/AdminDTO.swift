//
//  File.swift
//  
//
//  Created by Artemiy Zuzin on 15.05.2024.
//

import Foundation
import Vapor

struct AdminDTO {
    struct Create: Content {
        var name: String
        var password: String
    }
}
