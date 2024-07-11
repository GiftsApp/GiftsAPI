//
//  File 2.swift
//  
//
//  Created by Artemiy Zuzin on 11.07.2024.
//

import Vapor
import Fluent
import Gatekeeper

struct UserIDKeyMaker: GatekeeperKeyMaker {
    public func make(for req: Request) -> EventLoopFuture<String> {
        guard let id = try? req.auth.require(User.self).requireID() else { return req.eventLoop.next().future(error: Abort(.badRequest)) }
        
        return req.eventLoop.future("gatekeeper_" + id)
    }
}

extension Application.Gatekeeper.KeyMakers.Provider {
    public static var userID: Self {
        .init { app in
            app.gatekeeper.keyMakers.use { _ in UserIDKeyMaker() }
        }
    }
}
