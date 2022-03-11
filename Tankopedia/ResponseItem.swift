//
//  ResponseItem.swift
//  Tankopedia
//
//  Created by Rostislav Ermachenkov on 11.03.2022.
//

import Foundation

public struct ResponseItem: Codable {
    public let description: String
}

public struct Response: Decodable {
    var result: [ResponseItem]
}
