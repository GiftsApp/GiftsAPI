//
//  File.swift
//  
//
//  Created by Artemiy Zuzin on 17.05.2024.
//

import Fluent
import Vapor

final class AdminTokenController: RouteCollection {
    
//    MARK: - Boot
    func boot(routes: RoutesBuilder) throws {
        let admin = routes.grouped(Admin.authenticator())
        let adminToken = routes.grouped(AdminToken.authenticator())
        
        admin.post("log", "in", use: self.logIn(req:))
        adminToken.delete("log", "out", use: self.logOut(req:))
    }
    
//    MARK: - Log In
    @Sendable private func logIn(req: Request) async throws -> AdminTokenDTO.Output {
        let admin = try req.auth.require(Admin.self)
        let newToken = try admin.generateToken()
        
        try await req.db.transaction { db in
            for token in (try? await AdminToken.query(on: db).filter(AdminToken.self, \.$admin.$id, .equal, admin.id ?? .init()).all()) ?? .init() {
                try await token.delete(on: db)
            }
            
            try await newToken.save(on: db)
        }
        
        return .init(id: newToken.id, value: newToken.value)
    }
    
//    MARK: - Log Out
    @Sendable private func logOut(req: Request) async throws -> HTTPStatus {
        guard let id = try req.auth.require(Admin.self).id else { throw Abort(.unauthorized) }
        
        try await req.db.transaction { db in
            for token in try await UserToken.query(on: db).filter(AdminToken.self, \.$admin.$id, .equal, id).all() {
                try await token.delete(on: db)
            }
        }
        
        return .ok
    }
    
}
