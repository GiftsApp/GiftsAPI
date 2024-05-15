//
//  File 2.swift
//  
//
//  Created by Artemiy Zuzin on 15.05.2024.
//

import Vapor
import Fluent

final class Button: Model, Content {
    
//    MARK: - Properties
    static let schema = "buttons"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "file_id")
    var file: File
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "users_id")
    var usersID: [UUID]
    
    @Parent(key: "quest_id")
    var quest: Quest
    
//    MARK: - Init
    init() { }
    init(id: UUID? = nil, fileID: File.IDValue, title: String, usersID: [UUID] = .init(), questID: Quest.IDValue) {
        self.id = id
        self.$file.id = fileID
        self.title = title
        self.usersID = usersID
        self.$quest.id = questID
    }
    
//    MARK: - Coding Keys
    enum CodingKeys: String, CodingKey {
        case id, file, title, quest
        case usersID = "users_id"
    }
    
}
