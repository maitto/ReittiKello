//
//  NetworkingService.swift
//  PysakkiKello WatchKit Extension
//
//  Created by Mortti Aittokoski on 23.2.2020.
//  Copyright © 2020 Mortti Aittokoski. All rights reserved.
//

import SwiftUI
import Apollo

fileprivate let graphQLEndpoint = "https://api.digitransit.fi/routing/v1/routers/hsl/index/graphql"
fileprivate let apollo = ApolloClient(url: URL(string: graphQLEndpoint)!)

class StopData: ObservableObject {
    static let shared = StopData()
    
    @Published var stops: [Stop] = []
    
    func fetchStops(_ lat: Double, _ lon: Double, _ radius: Int = 900) {
        apollo.fetch(query: StopsByRadiusQuery(lat: lat, lon: lon, radius: radius)) { result in
            guard let data = try? result.get().data else { return }
            if let edges = data.stopsByRadius?.edges {
                var stops: [Stop] = []
                
                for edge in edges {
                    
                    // a stop
                    if let stop = edge?.node?.stop {
                        if let stopTimes = stop.stoptimesWithoutPatterns {
                            
                            var departures: [Departure] = []
                            
                            // a departure
                            for departure in stopTimes {
                                if let departureTimestamp = departure?.realtimeDeparture,
                                    let destination = departure?.headsign,
                                    let routeName = departure?.trip?.route.shortName,
                                    let isRealTime = departure?.realtime,
                                    let departureDelay = departure?.departureDelay {
                                    
                                    let departure = Departure(departureTimestamp: departureTimestamp,
                                                              routeName: routeName,
                                                              destination: destination,
                                                              isRealTime: isRealTime,
                                                              departureDelay: departureDelay)
                                    
                                    departures.append(departure)
                                    
                                    print("Departure entry: \(departureTimestamp) \(routeName) \(destination)")
                                }
                            }
                            if departures.count > 0 {
                                let stop = Stop(departures: departures, stopName: stop.name)
                                stops.append(stop)
                            }
                            
                        }
                    }
                }
                self.stops = stops
                
            }
        }
    }
}