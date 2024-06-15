//
//  File.swift
//  
//
//  Created by Artemiy Zuzin on 16.05.2024.
//

import Fluent

struct CreateUser: AsyncMigration {
    
    func prepare(on database: Database) async throws {
        try await database.schema(User.schema)
            .field(.id, .string)
            .field("query_id", .string, .required)
            .field("name", .string, .required)
            .field("silver_balance", .int64, .required)
            .field("gold_balance", .int64, .required)
            .field("tickets_id", .array(of: .uuid), .required)
            .field("tap_lvl", .int64, .required)
            .field("energy_lvl", .int64, .required)
            .field("energy", .int64, .required)
            .field("completed_quests_id", .array(of: .uuid), .required)
            .field("auto_clicker_expiration_date", .double)
            .field("next_wheel_spin_date", .double)
            .field("photo_url", .string)
            .field("created_at", .double)
            .field("last_online_date", .double)
            .field("friend_id", .string)
            .field("language_code", .string)
            .unique(on: .id)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(User.schema).delete()
    }
    
}
