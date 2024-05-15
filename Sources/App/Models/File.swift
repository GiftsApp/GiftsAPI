//
//  File.swift
//  
//
//  Created by Artemiy Zuzin on 15.05.2024.
//

import Fluent
import Vapor

final class File: Model, Content {
    
//    MARK: - Properties
    static let schema = "files"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "path")
    var path: String
    
//    MARK: - Init
    init() { }
    init(id: UUID? = nil, path: String) {
        self.id = id
        self.path = path
    }
    
}
