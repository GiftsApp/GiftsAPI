//
//  File.swift
//  
//
//  Created by Artemiy Zuzin on 13.05.2024.
//

import Foundation

enum RequestErrors: Error {
    case decodingFailed, encodingFailed, dataIsEqualToNil, statusCodeIsEqualTo(code: Int)
}
