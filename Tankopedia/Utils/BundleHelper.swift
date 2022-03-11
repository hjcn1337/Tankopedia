//
//  BundleHelper.swift
//  Tankopedia
//
//  Created by Rostislav Ermachenkov on 11.03.2022.
//

import Foundation

extension Bundle {
    static var current: Bundle {
        class __ {}
        return Bundle(for: __.self)
    }
}
