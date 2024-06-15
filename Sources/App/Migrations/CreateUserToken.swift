//
//  File.swift
//  
//
//  Created by Artemiy Zuzin on 16.05.2024.
//

import Fluent

struct CreateUserToken: AsyncMigration {
    
    func prepare(on database: Database) async throws {
        try await database.schema(UserToken.schema)
            .id()
            .field("value", .string, .required)
            .field("user_id", .string, .required)
            .field("created_at", .double)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(UserToken.schema).delete()
    }
    
}
