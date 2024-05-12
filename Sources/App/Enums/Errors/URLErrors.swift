//
//  File.swift
//  
//
//  Created by Artemiy Zuzin on 13.05.2024.
//

import Foundation

enum URLErrors: Error {
    case notValidURL, error(description: String)
}
