//
//  File.swift
//  
//
//  Created by Artemiy Zuzin on 16.05.2024.
//

import Fluent

struct CreateQuest: AsyncMigration {
    
    func prepare(on database: Database) async throws {
        try await database.schema(Quest.schema)
            .id()
            .field("title", .string, .required)
            .field("description", .string, .required)
            .field("count", .int32, .required)
            .field("file_id", .uuid, .required)
            .field("max_taps_count", .int32, .required)
            .field("tap_count", .int32, .required)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(Quest.schema).delete()
    }
    
}
