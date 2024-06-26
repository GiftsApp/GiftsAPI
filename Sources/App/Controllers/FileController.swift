//
//  File.swift
//  
//
//  Created by Artemiy Zuzin on 17.05.2024.
//

import Fluent
import Vapor

final class FileController: RouteCollection {
    
//    MARK: - Boot
    func boot(routes: RoutesBuilder) throws {
        let files = routes.grouped("files")
        let user = files.grouped(UserToken.authenticator())
        let admin = files.grouped(AdminToken.authenticator())
        
        files.get(":fileID", use: self.get(req:))
        admin.get("admin", ":fileID", use: self.getAdmin(req:))
    }
    
//    MARK: - Get
    @Sendable private func get(req: Request) async throws -> FileDTO.Output {
        guard let file = try await File.find(req.parameters.get("fileID"), on: req.db) else { throw Abort(.notFound) }
        
        return .init(id: file.id, data: try await FileManager.get(req: req, with: file.path))
    }
    
//    MARK: - Get Admin
    @Sendable private func getAdmin(req: Request) async throws -> FileDTO.Output {
        try req.auth.require(Admin.self)
        
        guard let file = try await File.find(req.parameters.get("fileID"), on: req.db) else { throw Abort(.notFound) }
        
        return .init(id: file.id, data: try await FileManager.get(req: req, with: file.path))
    }
    
}
