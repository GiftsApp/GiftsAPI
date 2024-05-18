//
//  File.swift
//  
//
//  Created by Artemiy Zuzin on 17.05.2024.
//

import Foundation
import Vapor

enum Gift: String, Content {
    case iphone
    case twoGoldTicket = "two_gold_ticket"
    case goldTicket = "gold_ticket"
    case oneSilverTicket = "one_silver_ticket"
    case twoSilverTicket = "two_silver_ticket"
    case threeSilverTicket = "three_silver_ticket"
    case fourSilverTicket = "four_silver_ticket"
    case fiveSilverTicket = "five_silver_ticket"
}
