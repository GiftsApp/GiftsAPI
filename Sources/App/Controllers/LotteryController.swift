//
//  File.swift
//  
//
//  Created by Artemiy Zuzin on 17.05.2024.
//

import Fluent
import Vapor

final class LotteryController: RouteCollection {
    
//    MARK: Boot
    func boot(routes: RoutesBuilder) throws {
        let lotteryies = routes.grouped("lotteries")
        let user = lotteryies.grouped(UserToken.authenticator())
        let admin = lotteryies.grouped(AdminToken.authenticator())
        
        lotteryies.get("all", use: self.index(req:))
        admin.get("all", "admin", use: self.adminIndex(req:))
        lotteryies.get("my", ":userID", use: self.getMy(req:))
        admin.post("new", use: self.create(req:))
        lotteryies.put("tap", ":userID", use: self.tap(req:))
        admin.post("delete", ":lotteryID", use: self.delete(req:))
    }
    
//    MARK: - Index
    @Sendable private func index(req: Request) async throws -> [LotteryDTO.Output] {
        try await Lottery.query(on: req.db).all()
            .filter {
                $0.maxTicketsCount > $0.ticketsCount
            }
            .asyncMap {
                .init(
                    id: $0.id,
                    ticketsCount: $0.ticketsCount,
                    title: $0.title,
                    maxTicketsCount: $0.maxTicketsCount,
                    fileID: try await $0.$file.get(on: req.db).id ?? .init(),
                    userID: $0.usersID.randomElement() ?? .empty
                )
            }
    }
    
//    MARK: - Admin Index
    @Sendable private func adminIndex(req: Request) async throws -> [LotteryDTO.Output] {
        try req.auth.require(Admin.self)
        
        return try await Lottery.query(on: req.db).all()
            .asyncMap {
                .init(
                    id: $0.id,
                    ticketsCount: $0.ticketsCount,
                    title: $0.title,
                    maxTicketsCount: $0.maxTicketsCount,
                    fileID: try await $0.$file.get(on: req.db).id ?? .init(),
                    userID: $0.usersID.randomElement() ?? .empty
                )
            }
    }
    
//    MARK: - Get My
    @Sendable private func getMy(req: Request) async throws -> [LotteryDTO.Output] {
        guard let ticketsIDs = try await User.find(req.parameters.get("userID"), on: req.db)?.ticketsID else { throw Abort(.notFound) }
        
        return try await Lottery.query(on: req.db).filter(\.$id ~~ ticketsIDs).all()
            .asyncMap { lottery in
                .init(
                    id: lottery.id,
                    ticketsCount: ticketsIDs.filter { id in id == (lottery.id ?? .init()) }.count,
                    title: lottery.title,
                    maxTicketsCount: lottery.maxTicketsCount,
                    fileID: try await lottery.$file.get(on: req.db).id ?? .init(),
                    userID: lottery.usersID.randomElement() ?? .empty
                )
            }
    }
    
//    MARK: - Create
    @Sendable private func create(req: Request) async throws -> HTTPStatus {
        try req.auth.require(Admin.self)
        
        let model = try req.content.decode(LotteryDTO.Create.self)
        let path = req.application.directory.publicDirectory.appending(UUID().uuidString)
        let file = File(path: path)
        
        try await FileManager.create(req: req, with: path, data: model.data)
        try await req.db.transaction { db in
            try await file.save(on: db)
            try await Lottery(title: model.title, maxTicketsCount: model.maxTicketsCount, fileID: file.id ?? .init()).save(on: db)
        }
        
        return .ok
    }
    
//    MARK: - Delete
    @Sendable private func delete(req: Request) async throws -> HTTPStatus {
        try req.auth.require(Admin.self)
        
        guard let lottery = try await Lottery.find(req.parameters.get("lotteryID"), on: req.db) else { throw Abort(.notFound) }
        
        let file = try await lottery.$file.get(on: req.db)
        
        try await FileManager.delete(req: req, with: file.path)
        try await req.db.transaction { db in
            try await file.delete(on: db)
            try await lottery.delete(on: db)
        }
        
        return .ok
    }
    
//    MARK: - Tap
    @Sendable private func tap(req: Request) async throws -> HTTPStatus {
        guard let user = try await User.find(req.parameters.get("userID"), on: req.db),
              let ticket = try await Lottery.find(req.parameters.get("ticketID"), on: req.db) else { throw Abort(.notFound) }
        guard ticket.maxTicketsCount > ticket.ticketsCount else { throw Abort(.badRequest) }
        
        ticket.ticketsCount += .one
        user.ticketsID.append(ticket.id ?? .init())
        try await req.db.transaction { db in
            try await ticket.save(on: req.db)
            try await user.save(on: req.db)
        }
        
        return .ok
    }
    
}
