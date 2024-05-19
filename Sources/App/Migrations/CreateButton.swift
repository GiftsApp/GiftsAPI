//
//  File.swift
//  
//
//  Created by Artemiy Zuzin on 16.05.2024.
//

import Fluent

struct CreateButton: AsyncMigration {
    
    func prepare(on database: Database) async throws {
        try await database.schema(Button.schema)
            .id()
            .field("file_id", .uuid, .required)
            .field("title", .string, .required)
            .field("users_id", .array(of: .string), .required)
            .field("quest_id", .uuid, .required)
            .field("link", .string, .required)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(Button.schema).delete()
    }
    
}
