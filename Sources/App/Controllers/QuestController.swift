//
//  File.swift
//  
//
//  Created by Artemiy Zuzin on 17.05.2024.
//

import Fluent
import Vapor
import Redis

final class QuestController: RouteCollection {
    
//    MARK: - Boot
    func boot(routes: RoutesBuilder) throws {
        let quests = routes.grouped("quests")
        let admin = quests.grouped(AdminToken.authenticator())
        let user = quests.grouped(UserToken.authenticator())
        
        admin.post("new", use: self.create(req:))
        admin.delete("delete", ":questID", use: self.delete(req:))
        user.get("all", use: self.index(req:))
        admin.get("all", "admin", use: self.indexAdmin(req:))
        user.get(":questID", use: self.get(req:))
        user.put("complete", ":questID", use: self.complete(req:))
    }
    
//    MARK: - Create
    @Sendable private func create(req: Request) async throws -> HTTPStatus {
        let create = try req.content.decode(QuestDTO.Create.self)
        let path = req.application.directory.publicDirectory.appending(UUID().uuidString)
        let file = File(path: path)
        
        try req.auth.require(Admin.self)
        try await FileManager.create(req: req, with: path, data: create.data)
        try await req.db.transaction { db in
            try await file.save(on: db)
            
            let quest = Quest(title: create.title, description: create.description, fileID: file.id ?? .init(), count: create.count, maxTapsCount: create.maxTapsCount, languageCode: create.languageCode)
            
            try await quest.save(on: db)
            
            for button in create.buttons {
                let buttonPath = req.application.directory.publicDirectory.appending(UUID().uuidString)
                let buttonFile = File(path: buttonPath)
                
                try await FileManager.create(req: req, with: buttonPath, data: button.data)
                try await buttonFile.save(on: db)
                try await Button(fileID: buttonFile.id ?? .init(), title: button.title, questID: quest.id ?? .init(), link: button.link).save(on: db)
            }
        }
        
        return .ok
    }
    
//    MARK: - Delete
    @Sendable private func delete(req: Request) async throws -> HTTPStatus {
        try req.auth.require(Admin.self)
        
        guard let quest = try await Quest.find(req.parameters.get("questID"), on: req.db) else { throw Abort(.notFound) }
        
        try await req.db.transaction { db in
            for button in try await quest.$buttons.get(on: db) {
                let file = try await button.$file.get(on: db)
                
                try await FileManager.delete(req: req, with: file.path)
                try await file.delete(on: db)
                try await button.delete(on: db)
            }
            
            let file = try await quest.$file.get(on: db)
            
            try await FileManager.delete(req: req, with: file.path)
            try await file.delete(on: db)
            try await quest.delete(on: db)
        }
        
        return .ok
    }
    
//    MARK: - Index
    @Sendable private func index(req: Request) async throws -> [QuestDTO.MiniOutput] {
        guard let user = try? req.auth.require(User.self), let id = user.id else { throw Abort(.unauthorized) }
        
        let completedQuests = user.completedQuestsID
        
        if let quest = try await req.redis.get(.init("quests_all_\(id)"), asJSON: [QuestDTO.MiniOutput].self) {
            return quest
        }
        
        let quests = try await Quest.query(on: req.db)
            .filter(\.$id !~ completedQuests)
            .group(.or) { query in
                query.filter(\.$languageCode == user.languageCode).filter(\.$languageCode == nil)
            }
            .all()
            .filter {
                $0.maxTapsCount > $0.tapsCount
            }
            .asyncMap {
                QuestDTO.MiniOutput(id: $0.id, title: $0.title, count: $0.count, fileID: try await $0.$file.get(on: req.db).id ?? .init())
            }
        
        try await req.redis.set(.init("quests_all_\(id)"), toJSON: quests)
        _ = req.redis.expire(.init("quests_all_\(id)"), after: .seconds(15))
        
        return quests
    }
    
//    MARK: - Index Admin
    @Sendable private func indexAdmin(req: Request) async throws -> [QuestDTO.MiniOutput] {
        try req.auth.require(Admin.self)
        
        return try await Quest.query(on: req.db).all().asyncMap {
            .init(id: $0.id, title: $0.title, count: $0.count, fileID: try await $0.$file.get(on: req.db).id ?? .init())
        }
    }
    
//    MARK: - Get
    @Sendable private func get(req: Request) async throws -> QuestDTO.Output {
        guard let id = try req.auth.require(User.self).id else { throw Abort(.unauthorized) }
        guard let quest = try await Quest.find(req.parameters.get("questID"), on: req.db) else { throw Abort(.notFound) }
        
        return .init(
            id: quest.id,
            title: quest.title,
            description: quest.description,
            count: quest.count,
            fileID: try await quest.$file.get(on: req.db).id ?? .init(),
            buttons: try await quest.$buttons.query(on: req.db).all().asyncMap { .init(id: $0.id ?? .init(), fileID: try await $0.$file.get(on: req.db).id ?? .init(), title: $0.title, questID: quest.id ?? .init(), isTapped: $0.usersID.contains(id), link: $0.link) }
        )
    }
    
//    MARK: - Complete
    @Sendable private func complete(req: Request) async throws -> HTTPStatus {
        let user = try req.auth.require(User.self)
        
        guard let quest = try await Quest.find(req.parameters.get("questID"), on: req.db), let id = quest.id else { throw Abort(.notFound) }
        
        user.completedQuestsID.append(id)
        user.silverBalance += quest.count
        try await user.save(on: req.db)
        
        return .ok
    }
    
}
