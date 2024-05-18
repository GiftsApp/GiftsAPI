//
//  File.swift
//  
//
//  Created by Artemiy Zuzin on 15.05.2024.
//

import Foundation
import Vapor

struct UserDTO {
    struct Create: Content {
        var id: String
        var queryID: String
        var name: String
        var languageCode: String?
        var photoURL: String?
        var friendID: User.IDValue?
    }
    
    struct MiniOutput: Content {
        var id: String
        var queryID: String
        var name: String
        var photoURL: String?
        var silverBalance: Int
        var goldBalance: Int
        var energyLVL: Int
        var tapLVL: Int
        var energy: Int
        var completedQuestsID: [UUID]
        var isAllowWheelSpin: Bool
    }
    
    struct Output: Content {
        var id: String
        var name: String
        var photoURL: String?
        var silverBalance: Int
        var goldBalance: Int
        var energyLVL: Int
        var tapLVL: Int
        var ticketsID: [UUID]
    }
    
    struct UpdateScreen: Content {
        var silverBalance: Int
        var energy: Int
    }
    
    struct ChangeBalance: Content {
        var silverBalance: Int
        var goldBalance: Int
    }
    
    struct BuyGoldTicket: Content {
        var count: Int
    }
}
