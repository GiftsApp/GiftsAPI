//
//  File 2.swift
//  
//
//  Created by Artemiy Zuzin on 15.05.2024.
//

import Vapor
import Fluent

final class UserToken: Model, Content {
    
//    MARK: - Properties
    static let schema = "user_tokens"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "value")
    var value: String
    
    @Parent(key: "user_id")
    var user: User
    
    @Timestamp(key: "created_at", on: .create, format: .unix)
    var createdAt: Date?
    
//    MARK: - Init
    init() { }
    init(id: UUID? = nil, value: String, userID: User.IDValue, createdAt: Double? = nil) {
        self.id = id
        self.value = value
        self.$user.id = userID
        self.$createdAt.timestamp = createdAt
    }
    
}

//MARK: - Extenions
extension UserToken: ModelTokenAuthenticatable {
    static let valueKey = \UserToken.$value
    static let userKey = \UserToken.$user
    var isValid: Bool { true }
}
