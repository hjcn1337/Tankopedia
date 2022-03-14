//
//  VehicleResponse.swift
//  Tankopedia
//
//  Created by Rostislav Ermachenkov on 12.03.2022.
//

import Foundation

public struct VehicleResponse: Decodable {
    let status: String
    let error: Error?
    let data: [String: VehicleItem]?
}

public struct VehicleItem: Codable {
    let hp: Int
    let weight: Int
    let profileID: String
    
    enum CodingKeys: String, CodingKey {
        case hp
        case weight
        case profileID = "profile_id"
        
    }
}

