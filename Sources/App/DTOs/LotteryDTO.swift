//
//  File.swift
//  
//
//  Created by Artemiy Zuzin on 15.05.2024.
//

import Foundation

struct LotteryDTO {
    struct Create: Encodable {
        var title: String
        var maxTicketsCount: Int
        var data: String
    }
    
    struct Output {
        var id: UUID?
        var ticketsCount: Int
        var title: String
        var maxTicketsCount: Int
        var fileID: UUID
    }
}
