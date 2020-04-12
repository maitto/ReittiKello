//
//  Utils+Extensions.swift
//  PysakkiKello WatchKit Extension
//
//  Created by Mortti Aittokoski on 22.3.2020.
//  Copyright © 2020 Mortti Aittokoski. All rights reserved.
//

import Foundation

extension String {
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        let value = NSLocalizedString(self, comment: "")
        if value != self || NSLocale.preferredLanguages.first == "en" {
            return value
        }

        // Fall back to en
        guard
            let path = Bundle.main.path(forResource: "en", ofType: "lproj"),
            let bundle = Bundle(path: path) else {
                return value
        }
        return NSLocalizedString(self, bundle: bundle, comment: "")
    }
}

func getFormattedTime(seconds: Int) -> String? {
    let dayInSeconds = 60 * 60 * 24
    var sec = seconds
    if sec >= dayInSeconds {
        sec -= dayInSeconds
    }
    let duration = TimeInterval(sec)

    let formatter = DateComponentsFormatter()
    formatter.unitsStyle = .positional
    formatter.allowedUnits = [ .hour, .minute ]
    formatter.zeroFormattingBehavior = [ .pad ]

    let formattedDuration = formatter.string(from: duration)

    return formattedDuration
}
