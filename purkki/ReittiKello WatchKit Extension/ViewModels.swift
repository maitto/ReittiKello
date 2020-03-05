//
//  ViewModels.swift
//  ReittiKello WatchKit Extension
//
//  Created by Mortti Aittokoski on 22.9.2019.
//  Copyright © 2019 Mortti Aittokoski. All rights reserved.
//

import Foundation


struct Stop: Identifiable {
    public let id = UUID()
    let departures: [Departure]
    let stopName: String
}

struct Departure: Identifiable {
    public let id = UUID()
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
