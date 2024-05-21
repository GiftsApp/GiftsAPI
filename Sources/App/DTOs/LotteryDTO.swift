//
//  File.swift
//  
//
//  Created by Artemiy Zuzin on 15.05.2024.
//

import Foundation
import Vapor

struct LotteryDTO {
    struct Create: Content {
        var title: String
        var maxTicketsCount: Int
        var data: Data
    }
    
    struct Output: Content {
        var id: UUID?
        var ticketsCount: Int
        var title: String
        var maxTicketsCount: Int
        var fileID: UUID
        var userID: User.IDValue
    }
}
