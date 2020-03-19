//
//  ViewModels.swift
//  PysakkiKello WatchKit Extension
//
//  Created by Mortti Aittokoski on 23.2.2020.
//  Copyright © 2020 Mortti Aittokoski. All rights reserved.
//

import Foundation

struct Stop: Identifiable {
    public let id: String
    let stopName: String
    let platformCode: String?
}

struct Departure: Identifiable {
    public let id = UUID()
    let hslStopId: String
    let departureTimestamp: Int
    let routeName: String
    let destination: String
    let isRealTime: Bool
    let departureDelay: Int
    
    var formattedDepartureTime: String {
        return getFormattedTime(seconds: departureTimestamp) ?? "\(departureTimestamp)"
    }
}

fileprivate func getFormattedTime(seconds: Int) -> String? {
    let duration: TimeInterval = TimeInterval(seconds)

    let formatter = DateComponentsFormatter()
    formatter.unitsStyle = .positional
    formatter.allowedUnits = [ .hour ,.minute ]
    formatter.zeroFormattingBehavior = [ .pad ]

    let formattedDuration = formatter.string(from: duration)
    
    return formattedDuration
}
