//
//  File.swift
//  
//
//  Created by Artemiy Zuzin on 14.05.2024.
//

import Fluent
import Vapor

final class User: Model, Content {
    
//    MARK: - Properties
    static let schema = "users"
    
    @ID(custom: .id, generatedBy: .user)
    var id: String?
    
    @Field(key: "query_id")
    var queryID: String
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "silver_balance")
    var silverBalance: Int
    
    @Field(key: "gold_balance")
    var goldBalance: Int
    
    @Field(key: "tickets_id")
    var ticketsID: [UUID]
    
    @Field(key: "energy_lvl")
    var energyLVL: Int
    
    @Field(key: "tap_lvl")
    var tapLVL: Int
    
    @Field(key: "energy")
    var energy: Int
    
    @Field(key: "completed_quests_id")
    var completedQuestsID: [Quest.IDValue]
    
    @Timestamp(key: "next_wheel_spin_date", on: .none, format: .unix)
    var nextWheelSpinDate: Date?
    
    @Timestamp(key: "auto_clicker_expiration_date", on: .none, format: .unix)
    var autoClickerExpirationDate: Date?
    
    @Timestamp(key: "last_online_date", on: .none, format: .unix)
    var lastOnlineDate: Date?
        
    @OptionalField(key: "language_code")
    var languageCode: String?
    
    @OptionalField(key: "photo_url")
    var photoURL: String?
    
    @Timestamp(key: "created_at", on: .create, format: .unix)
    var createdAt: Date?
    
    @OptionalParent(key: "friend_id")
    var friend: User?
    
    @Children(for: \.$friend)
    var firends: [User]
    
//    MARK: - Init
    init() { }
    init(
        id: String? = nil,
        queryID: String,
        name: String,
        silverBalance: Int = .zero,
        goldBalance: Int = .zero,
        languageCode: String? = nil,
        photoURL: String? = nil,
        createdAt: Double? = nil,
        friendID: User.IDValue? = nil,
        ticketsID: [UUID] = .init(),
        energyLVL: Int = .one,
        tapLVL: Int = .one,
        energy: Int = 1_000,
        autoClickerExpirationDate: Double? = nil,
        completedQuestsID: [UUID] = .init(),
        nextWheelSpinDate: Double? = nil,
        lastOnlineDate: Double? = nil
    ) {
        self.id = id
        self.queryID = queryID
        self.name = name
        self.silverBalance = silverBalance
        self.goldBalance = goldBalance
        self.languageCode = languageCode
        self.photoURL = photoURL
        self.$createdAt.timestamp = createdAt
        self.$friend.id = friendID
        self.ticketsID = ticketsID
        self.energyLVL = energyLVL
        self.tapLVL = tapLVL
        self.energy = energy
        self.$autoClickerExpirationDate.timestamp = autoClickerExpirationDate
        self.completedQuestsID = completedQuestsID
        self.$nextWheelSpinDate.timestamp = nextWheelSpinDate
        self.$lastOnlineDate.timestamp = lastOnlineDate
    }
    
//    MARK: - Coding Keys
    enum CodingKeys: String, CodingKey {
        case id, name, friend, friends, energy
        case queryID = "query_id"
        case silverBalance = "silver_balance"
        case goldBalance = "gold_balance"
        case languageCode = "language_code"
        case photoURL = "photo_url"
        case createdAt = "created_at"
        case ticketsID = "tickets_id"
        case energyLVL = "energy_lvl"
        case tapLVL = "tap_lvl"
        case autoClickerExpirationDate = "auto_clicker_expiration_date"
        case completedQuestsID = "completed_quests_id"
        case nextWheelSpinDate = "next_wheel_spin_date"
    }
    
}

//MARK: - Extensions
extension User: SessionAuthenticatable {
    var sessionID: String { self.id ?? .empty }
}

extension User: AsyncSessionAuthenticator {
    typealias User = App.User
    
    func authenticate(sessionID: String, for request: Vapor.Request) async throws {
        request.auth.login(self)
    }
}

extension User {
    func generateToken() throws -> UserToken {
        guard let id else { throw Abort(.unauthorized) }
        
        return .init(value: [UInt8].random(count: 16).base64, userID: id)
    }
}
