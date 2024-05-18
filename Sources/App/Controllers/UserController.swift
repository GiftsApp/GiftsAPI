//
//  File.swift
//  
//
//  Created by Artemiy Zuzin on 16.05.2024.
//

import Foundation
import Fluent
import Vapor
import NIOFoundationCompat

final class UserController: RouteCollection {
    
//    MARK: - Boot
    func boot(routes: Vapor.RoutesBuilder) throws {
        let users = routes.grouped("users")
        let user = users.grouped(UserToken.authenticator())
        let admin = users.grouped(AdminToken.authenticator())
        
        users.post("log", "in", use: self.logIn(req:))
        user.get("me", "mini", use: self.getMiniUser(req:))
        user.get("me", use: self.getUser(req:))
        user.get("me", "friends", use: self.getFriends(req:))
        user.put("buy", "energy", use: self.buyEnergy(req:))
        user.put("buy", "tap", use: self.buyTap(req:))
        user.put("buy", "auto", "clicker", use: self.buyAutoClicker(req:))
        user.put("buy", "gold", "ticket", use: self.buyGoldTicket(req:))
        user.get("is", "buy", "auto", "clicker", use: self.getIsBuyAlowAutoClicker(req:))
        user.put("wheel", "spin", use: self.wheelSpin(req:))
        admin.put("change", "balance", "admin", use: self.changeBalance(req:))
        admin.get("admin", ":userID", use: self.get(req:))
        user.webSocket("ws", maxFrameSize: .init(integerLiteral: 1 <<  24), onUpgrade: self.webSocket(req:ws:))
    }
    
//    MARK: - Log In
    @Sendable private func logIn(req: Request) async throws -> UserTokenDTO.Output {
        let create = try req.content.decode(UserDTO.Create.self)
        
        if let user = try await User.query(on: req.db).filter(\.$id ==  create.id).first(), let id = user.id {
            let token = try user.generateToken()
            
            user.name = create.name
            user.photoURL = create.photoURL
            user.languageCode = create.languageCode
            try await user.save(on: req.db)
            try await UserToken.query(on: req.db).filter(\.$user.$id == id).first()?.delete(on: req.db)
            try await token.save(on: req.db)
            
            return .init(id: token.id, value: token.value)
        }
        
        let user = User(
            id: create.id,
            queryID: create.queryID,
            name: create.name,
            silverBalance: create.friendID == nil ? .zero : 100_000,
            languageCode: create.languageCode,
            photoURL: create.photoURL,
            friendID: create.friendID
        )
        let token = try user.generateToken()
        
        try await user.save(on: req.db)
        try await token.save(on: req.db)
        
        if let user = try? await User.find(create.friendID, on: req.db) {
            user.silverBalance += 200_000
            try? await user.save(on: req.db)
        }
        
        return .init(id: token.id, value: token.value)
    }
    
//    MARK: - Get Mini User
    @Sendable private func getMiniUser(req: Request) async throws -> UserDTO.MiniOutput {
        let user = try req.auth.require(User.self)
        
        if let lastOnlineDate = user.$lastOnlineDate.timestamp {
            let energy = Int((Date.now.timeIntervalSince1970 - lastOnlineDate) / 3)
            var maxEnergy = Int.zero
            
            switch user.energyLVL {
            case 1:
                maxEnergy = 100
            default:
                maxEnergy = 500 * (user.energyLVL - .one)
            }
            
            if energy <= (maxEnergy - user.energy) {
                user.energy += energy
            } else {
                user.energy = maxEnergy
            }
            
            user.$lastOnlineDate.timestamp = nil
            try await user.save(on: req.db)
        }
        
        return .init(
            id: user.id ?? .empty,
            queryID: user.queryID,
            name: user.name,
            photoURL: user.photoURL,
            silverBalance: user.silverBalance,
            goldBalance: user.goldBalance,
            energyLVL: user.energyLVL,
            tapLVL: user.tapLVL,
            energy: user.energy,
            completedQuestsID: user.completedQuestsID,
            isAllowWheelSpin: (user.$nextWheelSpinDate.timestamp ?? .zero) <= Date.now.timeIntervalSince1970
        )
    }
    
//    MARK: - Get User
    @Sendable private func getUser(req: Request) async throws -> UserDTO.Output {
        let user = try req.auth.require(User.self)
        
        return .init(
            id: user.id ?? .empty,
            name: user.name,
            photoURL: user.photoURL,
            silverBalance: user.silverBalance,
            goldBalance: user.goldBalance,
            energyLVL: user.energyLVL,
            tapLVL: user.tapLVL,
            ticketsID: user.ticketsID
        )
    }
    
//    MARK: - Get Friends
    @Sendable private func getFriends(req: Request) async throws -> [UserDTO.MiniOutput] {
        let user = try req.auth.require(User.self)
        
        return try await user.$firends.get(on: req.db).map {
            .init(
                id: $0.id ?? .empty,
                queryID: $0.queryID,
                name: $0.name,
                photoURL: $0.photoURL,
                silverBalance: $0.silverBalance,
                goldBalance: $0.goldBalance,
                energyLVL: $0.energyLVL,
                tapLVL: $0.tapLVL,
                energy: $0.energy,
                completedQuestsID: $0.completedQuestsID,
                isAllowWheelSpin: ($0.$nextWheelSpinDate.timestamp ?? .zero) <= Date.now.timeIntervalSince1970
            )
        }
    }
    
//    MARK: - Buy Energy
    @Sendable private func buyEnergy(req: Request) async throws -> HTTPStatus {
        let user = try req.auth.require(User.self)
        var price = Int.zero
        
        switch user.energyLVL {
        case .one:
            price = 10_000
        case 2:
            price = 50_000
        case 3:
            price = 100_000
        case 4:
            price = 200_000
        default:
            price = 200_000 + ((user.energyLVL - 4) * 100_000)
        }
        
        guard price <= user.silverBalance else { return .badRequest }
        
        user.silverBalance -= price
        user.energyLVL += .one
        try await user.save(on: req.db)
        
        return .ok
    }
    
//    MARK: - Buy Tap
    @Sendable private func buyTap(req: Request) async throws -> HTTPStatus {
        let user = try req.auth.require(User.self)
        var price = Int.zero
        
        switch user.tapLVL {
        case .one:
            price = 10_000
        case 2:
            price = 20_000
        case 3:
            price = 30_000
        case 4:
            price = 40_000
        case 5:
            price = 50_000
        default:
            price = 50_000 + ((user.energyLVL - 5) * 50_000)
        }
        
        guard price <= user.silverBalance else { return .badRequest }
        
        user.silverBalance -= price
        user.tapLVL += .one
        try await user.save(on: req.db)
        
        return .ok
    }
    
//    MARK: - Buy Gold Ticket
    @Sendable private func buyGoldTicket(req: Request) async throws -> HTTPStatus {
        let user = try req.auth.require(User.self)
        let count = try req.content.decode(UserDTO.BuyGoldTicket.self).count
        
        guard 1_500_000 * count <= user.silverBalance else { return .badRequest }
        
        user.silverBalance -= 1_500_000 * count
        user.goldBalance += count
        try await user.save(on: req.db)
        
        return .ok
    }
    
//    MARK: - Buy Auto Clicker
    @Sendable private func buyAutoClicker(req: Request) async throws -> HTTPStatus {
        let user = try req.auth.require(User.self)
        
        guard user.autoClickerExpirationDate == nil else { return .badRequest }
        
        user.$autoClickerExpirationDate.timestamp = Calendar.current.date(byAdding: .day, value: .one, to: .now)?.timeIntervalSince1970
        try await user.save(on: req.db)
        
        return .ok
    }
    
//    MARK: - Get Is Buy Alow Auto Clicker
    @Sendable private func getIsBuyAlowAutoClicker(req: Request) async throws -> Bool {
        try req.auth.require(User.self).$autoClickerExpirationDate.timestamp == nil
    }
    
//    MARK: - Wheel Spin
    @Sendable private func wheelSpin(req: Request) async throws -> Gift {
        let user = try req.auth.require(User.self)
        let value = Double.random(in: .zero...100)
        
        guard (user.$nextWheelSpinDate.timestamp ?? .zero) <= Date.now.timeIntervalSince1970 else { throw Abort(.badRequest) }
        
        user.$nextWheelSpinDate.timestamp = Calendar.current.date(bySetting: .day, value: 3, of: .now)?.timeIntervalSince1970
        try await user.save(on: req.db)
        
        switch value {
        case .zero..<0.01:
            return .iphone
        case 0.01...3:
            user.goldBalance += 2
            try await user.save(on: req.db)
            
            return .twoGoldTicket
        case 3..<8:
            user.goldBalance += 1
            try await user.save(on: req.db)
            
            return .goldTicket
        case 8..<18:
            user.silverBalance += 500_000
            try await user.save(on: req.db)
            
            return .fiveSilverTicket
        case 18..<30:
            user.silverBalance += 400_000
            try await user.save(on: req.db)
            
            return .fourSilverTicket
        case 30..<45:
            user.silverBalance += 300_000
            try await user.save(on: req.db)
            
            return .threeSilverTicket
        case 45..<65:
            user.silverBalance += 200_000
            try await user.save(on: req.db)
            
            return .twoSilverTicket
        default:
            user.silverBalance += 100_000
            try await user.save(on: req.db)
            
            return .oneSilverTicket
        }
    }
    
//    MARK: - Web Socket
    @Sendable private func webSocket(req: Request, ws: WebSocket) async {
        guard let user = req.auth.get(User.self) else { return }
        
        ws.onBinary { _, buffer in
            guard let updateScreen = try? JSONDecoder().decode(UserDTO.UpdateScreen.self, from: buffer) else { return }
            
            user.silverBalance = updateScreen.silverBalance
            user.energy = updateScreen.energy
            try? await user.save(on: req.db)
        }
        ws.onClose.whenSuccess { _ in
            user.$lastOnlineDate.timestamp = Date.now.timeIntervalSince1970
            Task {
                try? await user.save(on: req.db)
            }
        }
    }
    
//    MARK: - Change Balance
    @Sendable private func changeBalance(req: Request) async throws ->  HTTPStatus {
        try req.auth.require(Admin.self)
        
        let input = try req.content.decode(UserDTO.ChangeBalance.self)
        
        guard let user = try await User.find(req.parameters.get("userID"), on: req.db) else { throw Abort(.notFound) }
        
        user.silverBalance = input.silverBalance
        user.goldBalance = input.goldBalance
        try await user.save(on: req.db)
        
        return .ok
    }
    
//    MARK: - Get
    @Sendable private func get(req: Request) async throws -> UserDTO.MiniOutput {
        try req.auth.require(Admin.self)
        
        guard let user = try await User.find(req.parameters.get("userID"), on: req.db) else { throw Abort(.notFound) }
        
        return .init(
            id: user.id ?? .init(),
            queryID: user.queryID,
            name: user.name,
            silverBalance: user.silverBalance,
            goldBalance: user.goldBalance,
            energyLVL: user.energy,
            tapLVL: user.tapLVL,
            energy: user.energy,
            completedQuestsID: user.completedQuestsID,
            isAllowWheelSpin: false
        )
    }
    
}
