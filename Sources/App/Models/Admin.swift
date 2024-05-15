//
//  File.swift
//  
//
//  Created by Artemiy Zuzin on 14.05.2024.
//

import Vapor
import Fluent

final class Admin: Model, Content {
    
//    MARK: - Properties
    static let schema = "admins"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "password_hash")
    var passwordHash: String
    
    @Timestamp(key: "created_at", on: .create, format: .unix)
    var createdAt: Date?
    
//    MARK: - Init
    init() { }
    init(id: UUID? = nil, name: String, passwordHash: String, createdAt: Double? = nil) {
        self.id = id
        self.name = name
        self.passwordHash = passwordHash
        self.$createdAt.timestamp = createdAt
    }
    
//    MARK: - Coding Keys
    enum CodingKeys: String, CodingKey {
        case id, name
        case passwordHash = "password_hash"
        case createdAt = "created_at"
    }
    
}

//MARK: - Extensions
extension Admin: ModelAuthenticatable {
    static let usernameKey = \Admin.$name
    static let passwordHashKey = \Admin.$passwordHash
    
    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.passwordHash)
    }
}

extension Admin {
    func generateToken() throws -> AdminToken {
        guard let id else { throw Abort(.unauthorized) }
        
        return .init(value: [UInt8].random(count: 16).base64, adminID: id)
    }
}
