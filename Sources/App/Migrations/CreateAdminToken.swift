//
//  File.swift
//  
//
//  Created by Artemiy Zuzin on 15.05.2024.
//

import Fluent

struct CreateAdminToken: AsyncMigration {
    
    func prepare(on database: Database) async throws {
        try await database.schema(AdminToken.schema)
            .id()
            .field("value", .string, .required)
            .field("admin_id", .uuid, .required)
            .field("create_at", .string)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(AdminToken.schema).delete()
    }
    
}
