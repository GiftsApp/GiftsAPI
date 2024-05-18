//
//  File.swift
//  
//
//  Created by Artemiy Zuzin on 17.05.2024.
//

import Fluent
import Vapor

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
        try await file.save(on: req.db)
        
        let quest = Quest(title: create.title, description: create.description, fileID: file.id ?? .init(), count: create.count)
        
        try await quest.save(on: req.db)
        
        for button in create.buttons {
            let buttonPath = req.application.directory.publicDirectory.appending(UUID().uuidString)
            let buttonFile = File(path: path)
            
            try await FileManager.create(req: req, with: buttonPath, data: button.data)
            try await buttonFile.save(on: req.db)
            try await Button(fileID: buttonFile.id ?? .init(), title: button.title, questID: quest.id ?? .init()).save(on: req.db)
        }
        
        return .ok
    }
    
//    MARK: - Delete
    @Sendable private func delete(req: Request) async throws -> HTTPStatus {
        try req.auth.require(Admin.self)
        
        guard let quest = try await Quest.find(req.parameters.get("questID"), on: req.db) else { throw Abort(.notFound) }
        
        for button in try await quest.$buttons.get(on: req.db) {
            let file = try await button.$file.get(on: req.db)
            
            try await FileManager.delete(req: req, with: file.path)
            try await file.delete(on: req.db)
            try await button.delete(on: req.db)
        }
        
        let file = try await quest.$file.get(on: req.db)
        
        try await FileManager.delete(req: req, with: file.path)
        try await file.delete(on: req.db)
        try await quest.delete(on: req.db)
        
        return .ok
    }
    
//    MARK: - Index
    @Sendable private func index(req: Request) async throws -> [QuestDTO.MiniOutput] {
        let completedQuests = try req.auth.require(User.self).completedQuestsID
        
        return try await Quest.query(on: req.db).filter(\.$id !~ completedQuests).all().asyncMap {
            .init(id: $0.id, title: $0.title, count: $0.count, fileID: try await $0.$file.get(on: req.db).id ?? .init())
        }
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
        try req.auth.require(User.self)
        
        guard let quest = try await Quest.find(req.parameters.get("questID"), on: req.db) else { throw Abort(.notFound) }
        
        return .init(
            id: quest.id,
            title: quest.title,
            description: quest.description,
            count: quest.count,
            fileID: try await quest.$file.get(on: req.db).id ?? .init(),
            buttonsID: try await quest.$buttons.query(on: req.db).field(\.$id).all().map { $0.id ?? .init() }
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
