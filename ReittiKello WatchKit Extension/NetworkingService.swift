//
//  NetworkingService.swift
//  ReittiKello
//
//  Created by Mortti Aittokoski on 14.9.2019.
//  Copyright © 2019 Mortti Aittokoski. All rights reserved.
//

import SwiftUI
import Apollo

//let stopData: [Stop] = []
//let departureData: [Departure] = getDepartures()

public struct Stop: Identifiable {
    public let id: String
    let departures: [Departure]
    let stopName: String
}

public struct Departure: Identifiable {
    public let id: String
    let departureTimestamp: String
    let lineNumber: String
    let destination: String
    let realTime: Bool
    let departureDelay: Int
}

final class DepartureData: ObservableObject {
    @Published var departures: [Departure] = []
    
    func fetch() {
        var departures: [Departure] = []
        apollo.fetch(query: StopQuery()) { result in
            guard let data = try? result.get().data else { return }
            if let stopTimes = data.stop?.stoptimesWithoutPatterns {
                for stopTime in stopTimes {
                    if let formattedTime = secondsToTime(seconds: stopTime?.realtimeDeparture),
                        let headsign = stopTime?.headsign,
                        let shortName = stopTime?.trip?.route.shortName,
                        let realTime = stopTime?.realtime,
                        let departureDelay = stopTime?.departureDelay {
                        
                        let departure = Departure(id: formattedTime, departureTimestamp: formattedTime, lineNumber: shortName, destination: headsign, realTime: realTime, departureDelay: departureDelay)
                        
                        departures.append(departure)
                        
                        print("\(formattedTime) \(shortName) \(headsign)")
                    }
                }
                self.departures = departures
            }
        }
    }
}

/*
let url = ""

func getStops() -> [Stop]? {
    let departure = Departure(id: "1", departureTimestamp: "123", lineNumber: "U", destination: "Helsinki")
    let stop = Stop(id: "1", departures: [departure], stopName: "koivuhovi")
    
    return [stop]
}

func getDepartures() -> [Departure] {
    let item1 = Departure(id: "1", departureTimestamp: "123", lineNumber: "U", destination: "Helsinki")
    let item2 = Departure(id: "2", departureTimestamp: "123", lineNumber: "U", destination: "Helsinki")
    let item3 = Departure(id: "3", departureTimestamp: "123", lineNumber: "U", destination: "Helsinki")
    let item4 = Departure(id: "4", departureTimestamp: "123", lineNumber: "U", destination: "Helsinki")
    
    testi()
    
    return [item1, item2, item3, item4]
}*/

let graphQLEndpoint = "https://api.digitransit.fi/routing/v1/routers/hsl/index/graphql"
let apollo = ApolloClient(url: URL(string: graphQLEndpoint)!)



func secondsToTime(seconds: Int?) -> String? {
    guard let seconds = seconds else { return nil }
    let duration: TimeInterval = TimeInterval(seconds)

    let formatter = DateComponentsFormatter()
    formatter.unitsStyle = .positional
    formatter.allowedUnits = [ .hour ,.minute ]
    formatter.zeroFormattingBehavior = [ .pad ]

    let formattedDuration = formatter.string(from: duration)
    
    return formattedDuration
}
