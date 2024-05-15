//
//  File.swift
//  
//
//  Created by Artemiy Zuzin on 16.05.2024.
//

import Fluent

struct CreateFile: AsyncMigration {
    
    func prepare(on database: Database) async throws {
        try await database.schema(File.schema)
            .id()
            .field("path", .string, .required)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(File.schema).delete()
    }
    
}
