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
        
        if let id = try? req.auth.require(User.self).requireID() {
            return req.eventLoop.future("gatekeeper_" + id)
        } else if req.url.path.contains("log/in"),
                  let id = (try? req.content.decode(UserDTO.Create.self).id) ?? (try? req.content.decode(AdminDTO.Create.self).name) {
            return req.eventLoop.future("gatekeeper_" + id)
        } else if req.url.path.isEmpty || req.url.path.count == 1 {
            #if DEBUG
            return req.eventLoop.future("gatekeeper_" + UUID().uuidString)
            #else
            return req.eventLoop.future("gatekeeper_main_screen")
            #endif
        }
        
        return req.eventLoop.future(error: Abort(.unauthorized))
    }
}

extension Application.Gatekeeper.KeyMakers.Provider {
    public static var userID: Self {
        .init { app in
            app.gatekeeper.keyMakers.use { _ in UserIDKeyMaker() }
        }
    }
}
