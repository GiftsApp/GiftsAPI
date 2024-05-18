//
//  File.swift
//  
//
//  Created by Artemiy Zuzin on 17.05.2024.
//

import Fluent
import Vapor

final class AdminController: RouteCollection {
    
//    MARK: - Boot
    func boot(routes: Vapor.RoutesBuilder) throws {
        let admin = routes.grouped("admins").grouped(AdminToken.authenticator())
        
        admin.post("new", use: self.create(req:))
    }
    
//    MARK: - Create
    @Sendable private func create(req: Request) async throws -> HTTPStatus {
        let create = try req.content.decode(AdminDTO.Create.self)
        
        try req.auth.require(Admin.self)
        try await Admin(name: create.name, passwordHash: Bcrypt.hash(create.password)).save(on: req.db)
        
        return .ok
    }
    
}
