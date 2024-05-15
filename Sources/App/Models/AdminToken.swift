//
//  File 2.swift
//  
//
//  Created by Artemiy Zuzin on 15.05.2024.
//

import Vapor
import Fluent

final class AdminToken: Model, Content {
    
//    MARK: - Properties
    static let schema = "admin_tokens"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "value")
    var value: String
    
    @Parent(key: "admin_id")
    var admin: Admin
    
    @Timestamp(key: "create_at", on: .create, format: .unix)
    var createdAt: Date?
    
//    MARK: - Init
    init() { }
    init(id: UUID? = nil, value: String, adminID: Admin.IDValue, createdAt: Double? = nil) {
        self.id = id
        self.value = value
        self.$admin.id = adminID
        self.$createdAt.timestamp = createdAt
    }
    
//    MARK: - Coding Keys
    enum CodingKeys: String, CodingKey {
        case id, value, admin
        case createdAt = "created_at"
    }
    
}

//MARK: - Extensions
extension AdminToken: ModelTokenAuthenticatable {
    static let valueKey = \AdminToken.$value
    static let userKey = \AdminToken.$admin
    var isValid: Bool { true }
}
