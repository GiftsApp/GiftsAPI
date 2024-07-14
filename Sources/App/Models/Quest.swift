//
//  File 2.swift
//  
//
//  Created by Artemiy Zuzin on 15.05.2024.
//

import Fluent
import Vapor

final class Quest: Model, Content {
    
//    MARK: - Properties
    static let schema = "quests"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "description")
    var description: String
    
    @Field(key: "count")
    var count: Int
    
    @Field(key: "max_taps_count")
    var maxTapsCount: Int
    
    @Field(key: "tap_count")
    var tapsCount: Int
    
    @Parent(key: "file_id")
    var file: File
    
    @Children(for: \.$quest)
    var buttons: [Button]
    
//    MARK: - Init
    init() { }
    init(id: UUID? = nil, title: String, description: String, fileID: File.IDValue, count: Int, maxTapsCount: Int, tapsCount: Int = .zero) {
        self.id = id
        self.title = title
        self.description = description
        self.$file.id = fileID
        self.buttons = buttons
        self.count = count
        self.maxTapsCount = maxTapsCount
        self.tapsCount = tapsCount
    }
    
}
