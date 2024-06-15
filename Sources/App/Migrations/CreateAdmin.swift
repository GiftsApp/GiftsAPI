//
//  File.swift
//  
//
//  Created by Artemiy Zuzin on 15.05.2024.
//

import Fluent

struct CreateAdmin: AsyncMigration {
    
    func prepare(on database: Database) async throws {
        try await database.schema(Admin.schema)
            .id()
            .field("name", .string, .required)
            .field("password_hash", .string, .required)
            .field("created_at", .double)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(Admin.schema).delete()
    }
    
}
