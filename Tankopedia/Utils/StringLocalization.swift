//
//  StringLocalization.swift
//  Tankopedia
//
//  Created by Rostislav Ermachenkov on 11.03.2022.
//

import Foundation

func tr(_ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, bundle: Bundle.current, comment: "")
    if args.isEmpty {
        return format
    }
    return String(format: format, locale: Locale.current, arguments: args)
}
