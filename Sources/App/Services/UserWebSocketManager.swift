//
//  File.swift
//  
//
//  Created by Artemiy Zuzin on 11.07.2024.
//

import Vapor
import Fluent

final class UserWebSocketManager {
    
//    MARK: - Properties
    static let shared = UserWebSocketManager()
    
    
//    MARK: - Init
    private init() { }
    
    
//    MARK: - Properties
    private(set) var webSockets = [UserWebSocket]()
    
    
//    MARK: - Editing Actions
    func add(_ model: UserWebSocket) async {
        guard model.id != nil else { return }
        if let index = self.webSockets.firstIndex(where: { $0.id == model.id }) {
            try? await self.webSockets[index].ws.close()
            self.remove(with: model.id)
        }
        
        self.webSockets.append(model)
    }
    
    func remove(with id: String?) {
        guard id != nil else { return }
        
        self.webSockets.removeAll { $0.id == id }
    }
    
}
