//
//  File.swift
//  
//
//  Created by Artemiy Zuzin on 16.05.2024.
//

import Fluent

struct CreateLottery: AsyncMigration {
    
    func prepare(on database: Database) async throws {
        try await database.schema(Lottery.schema)
            .id()
            .field("title", .string, .required)
            .field("max_tickets_count", .int32, .required)
            .field("tickets_count", .int32, .required)
            .field("file_id", .uuid, .required)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(Lottery.schema).delete()
    }
    
}
