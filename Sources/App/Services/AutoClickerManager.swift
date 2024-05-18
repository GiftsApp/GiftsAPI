//
//  File.swift
//  
//
//  Created by Artemiy Zuzin on 18.05.2024.
//

import Fluent
import Vapor

final class AutoClickerManager: Sendable {
    
//    MARK: - Init
    private init() { }
    
    
//    MARK: - Shared
    static let shared = AutoClickerManager()
    
    
//    MARK: - Start
    func start(_ app: Application) {
        self.addTimer(self.createManagerTimer(app))
    }
    
//    MARK: - Get Users
    func getUsers(_ app: Application) async throws -> [User] {
        try await User.query(on: app.db)
            .filter(\.$autoClickerExpirationDate.$timestamp < Date().timeIntervalSince1970)
            .all()
    }
    
//    MARK: - Set User
    func setUser(_ app: Application, user: User) async throws {
        user.$autoClickerExpirationDate.timestamp = nil
        user.silverBalance += 200_000
        try await user.save(on: app.db)
    }
    
//    MARK: - Manage
    func manage(_ app: Application, isThrowEnable: Bool = false) async throws {
        for user in try await self.getUsers(app) {
            if isThrowEnable {
                try await self.setUser(app, user: user)
            } else {
                try? await self.setUser(app, user: user)
            }
        }
    }
    
//    MARK: - Create Manage Timer
    func createManagerTimer(_ app: Application) -> Timer {
        .scheduledTimer(withTimeInterval: .init(3_600), repeats: true) { _ in
            Task {
                try? await self.manage(app)
            }
        }
    }
    
//    MARK: - Add Timer
    func addTimer(_ timer: Timer) {
        RunLoop.current.add(timer, forMode: .common)
    }
    
}
