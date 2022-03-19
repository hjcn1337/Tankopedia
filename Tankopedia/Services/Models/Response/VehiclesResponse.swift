//
//  ResponseItem.swift
//  Tankopedia
//
//  Created by Rostislav Ermachenkov on 11.03.2022.
//

import Foundation

public struct VehiclesResponse: Decodable {
    let status: String
    let error: Error?
    let data: [String: VehiclesItem]?
}

struct Error: Codable {
    let message: String
    let code: Int
}

public struct VehiclesItem: Codable {
    public let tankID: Int
    public let vehicleDescription: String
    public let name: String
    public let images: Images
    public let priceGold: Int?
    public let priceCredit: Int?
    public let nation: String
    public let tier: Int
    public let isWheeled: Bool
    public let isGift: Bool
    public let isPremium: Bool
    
    enum CodingKeys: String, CodingKey {
        case tankID = "tank_id"
        case vehicleDescription = "description"
        case nation
        case tier
        case name
        case images
        case priceGold = "price_gold"
        case priceCredit = "price_credit"
        case isWheeled = "is_wheeled"
        case isGift = "is_gift"
        case isPremium = "is_premium"
    }
}

public struct Images: Codable {
    public let smallIcon, contourIcon, bigIcon: String

    enum CodingKeys: String, CodingKey {
        case smallIcon = "small_icon"
        case contourIcon = "contour_icon"
        case bigIcon = "big_icon"
    }
}
