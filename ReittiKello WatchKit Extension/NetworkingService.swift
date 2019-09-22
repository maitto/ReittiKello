//
//  NetworkingService.swift
//  ReittiKello
//
//  Created by Mortti Aittokoski on 14.9.2019.
//  Copyright © 2019 Mortti Aittokoski. All rights reserved.
//

import SwiftUI
import Apollo


fileprivate let graphQLEndpoint = "https://api.digitransit.fi/routing/v1/routers/hsl/index/graphql"
fileprivate let apollo = ApolloClient(url: URL(string: graphQLEndpoint)!)

final class DepartureData: ObservableObject {
    @Published var departures: [Departure] = []
    
    func fetch() {
        var departures: [Departure] = []
        apollo.fetch(query: StopQuery()) { result in
            guard let data = try? result.get().data else { return }
            if let stopTimes = data.stop?.stoptimesWithoutPatterns {
                for stopTime in stopTimes {
                    if let departureTimestamp = stopTime?.realtimeDeparture,
                        let destination = stopTime?.headsign,
                        let routeName = stopTime?.trip?.route.shortName,
                        let isRealTime = stopTime?.realtime,
                        let departureDelay = stopTime?.departureDelay {
                        
                        let departure = Departure(departureTimestamp: departureTimestamp,
                                                  routeName: routeName,
                                                  destination: destination,
                                                  isRealTime: isRealTime,
                                                  departureDelay: departureDelay)
                        
                        departures.append(departure)
                        
                        print("Departure entry: \(departureTimestamp) \(routeName) \(destination)")
                    }
                }
                self.departures = departures
            }
        }
    }
}
