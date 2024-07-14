//
//  File.swift
//  
//
//  Created by Artemiy Zuzin on 17.05.2024.
//

import Fluent
import Vapor
import Redis

final class FileController: RouteCollection {
    
//    MARK: - Boot
    func boot(routes: RoutesBuilder) throws {
        let files = routes.grouped("files")
        let user = files.grouped(UserToken.authenticator())
        let admin = files.grouped(AdminToken.authenticator())
        
        user.get(":fileID", use: self.get(req:))
        admin.get("admin", ":fileID", use: self.getAdmin(req:))
    }
    
//    MARK: - Get
    @Sendable private func get(req: Request) async throws -> FileDTO.Output {
        try req.auth.require(User.self)
        
        guard let fileID = req.parameters.get("fileID") else { throw Abort(.notFound) }
        
        let key = "file_\(fileID)"
        
        if let file = try await req.redis.get(.init(key), asJSON: FileDTO.Output.self) {
            return file
        }
        
        guard let file = try await File.find(req.parameters.get("fileID"), on: req.db) else { throw Abort(.notFound) }
        
        let model = FileDTO.Output(id: file.id, data: try await FileManager.get(req: req, with: file.path))
        
        try await req.redis.set(.init(key), toJSON: model)
        _ = req.redis.expire(.init(key), after: .minutes(1))
        
        return model
    }
    
//    MARK: - Get Admin
    @Sendable private func getAdmin(req: Request) async throws -> FileDTO.Output {
        try req.auth.require(Admin.self)
        
        guard let fileID = req.parameters.get("fileID") else { throw Abort(.notFound) }
        
        let key = "file_\(fileID)"
        
        guard let file = try await File.find(req.parameters.get("fileID"), on: req.db) else { throw Abort(.notFound) }
        
        let model = FileDTO.Output(id: file.id, data: try await FileManager.get(req: req, with: file.path))
        
        try await req.redis.set(.init(key), toJSON: model)
        _ = req.redis.expire(.init(key), after: .minutes(1))
        
        return model
    }
    
}
