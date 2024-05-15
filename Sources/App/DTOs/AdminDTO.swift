//
//  File.swift
//  
//
//  Created by Artemiy Zuzin on 15.05.2024.
//

import Foundation

struct AdminDTO {
    struct Create: Encodable {
        var name: String
        var password: String
    }
}
