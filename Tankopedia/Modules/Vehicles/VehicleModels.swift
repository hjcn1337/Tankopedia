//
//  VehicleDetails.swift
//  Tankopedia
//
//  Created by Rostislav Ermachenkov on 13.03.2022.
//

import Foundation

struct VehicleModel {
    let tankID: Int
    let vehicleDescription: String
    let name: String
    let imageUrlString: String
    let priceGold: Int?
    let priceCredit: Int?
    let nation: String
    let tier: Int
    let isWheeled: Bool
    let isGift: Bool
    let isPremium: Bool
    var isFavourite: Bool
}

struct VehicleDetails {
    let tankID: Int
    let name: String
    let imageURLString: String
}
