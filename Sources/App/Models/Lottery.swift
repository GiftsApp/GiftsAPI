//
//  File.swift
//  
//
//  Created by Artemiy Zuzin on 15.05.2024.
//

import Vapor
import Fluent

final class Lottery: Content, Model {
    
//    MARK: - Properties
    static let schema = "lotteries"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "max_tickets_count")
    var maxTicketsCount: Int
    
    @Field(key: "tickets_count")
    var ticketsCount: Int
    
    @Parent(key: "file_id")
    var file: File
    
//    MARK: - Init
    init() { }
    init(id: UUID? = nil, title: String, maxTicketsCount: Int, ticketsCount: Int = .zero, fileID: File.IDValue) {
        self.id = id
        self.title = title
        self.maxTicketsCount = maxTicketsCount
        self.ticketsCount = ticketsCount
        self.$file.id = fileID
    }
    
//    MARK: - Coding Keys
    enum CodingKeys: String, CodingKey {
        case id, title, file
        case maxTicketsCount = "max_tickets_count"
        case ticketsCount = "tickets_count"
    }
    
}
