//
//  File.swift
//  
//
//  Created by Artemiy Zuzin on 13.05.2024.
//

import Foundation

enum AuthMode {
    case base(email: String, password: String), bearrer(token: String)
}
