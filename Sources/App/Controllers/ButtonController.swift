//
//  File.swift
//  
//
//  Created by Artemiy Zuzin on 17.05.2024.
//

import Fluent
import Vapor

final class ButtonController: RouteCollection {
    
//    MARK: - Boot
    func boot(routes: RoutesBuilder) throws {
        let buttons = routes.grouped("buttons")
        let user = routes.grouped(UserToken.authenticator())
        
        user.put("tap", ":buttonID", use: self.tap(req:))
        user.get("all", ":questID", use: self.buttons(req:))
    }
    
//    MARK: - Tap
    @Sendable private func tap(req: Request) async throws -> HTTPStatus {
        guard let id = try req.auth.require(User.self).id else { throw Abort(.unauthorized) }
        guard let button = try await Button.find(req.parameters.get("buttonID"), on: req.db), button.usersID.contains(id) else { return .ok }
        
        button.usersID.append(id)
        try await button.save(on: req.db)
        
        return .ok
    }
    
//    MARK: - Buttons
    @Sendable private func buttons(req: Request) async throws -> [ButtonDTO.Output] {
        guard let id = try req.auth.require(User.self).id else { throw Abort(.unauthorized) }
        guard let quest = try await Quest.find(req.parameters.get("questID"), on: req.db) else { throw Abort(.notFound) }
        
        return try await quest.$buttons.get(on: req.db).asyncMap {
            .init(
                id: $0.id,
                fileID: try await $0.$file.get(on: req.db).id ?? .init(),
                title: $0.title,
                questID: quest.id ?? .init(),
                isTapped: $0.usersID.contains(id)
            )
        }
    }
    
}
