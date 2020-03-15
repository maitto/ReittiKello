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

typealias StoptimesByRadius = StopsByRadiusQuery.Data.StopsByRadiu.Edge.Node.Stop.StoptimesWithoutPattern
typealias StoptimesById = StopQuery.Data.Stop.StoptimesWithoutPattern

class StopData: ObservableObject {
    static let shared = StopData()
    
    @Published var stops: [Stop] = []
    
    func fetchNearbyStops(_ lat: Double, _ lon: Double, _ radius: Int = 900) {
        apollo.fetch(query: StopsByRadiusQuery(lat: lat, lon: lon, radius: radius)) { result in
            guard let data = try? result.get().data else { return }
            if let edges = data.stopsByRadius?.edges {
                var stops: [Stop] = []
                
                for edge in edges {
                    if let stop = edge?.node?.stop {
                        print("asd \(stop.gtfsId)")
                        if let stoptimes = stop.stoptimesWithoutPatterns {
                            let departures = self.getDeparturesFromStoptimes(stoptimes)
                            if departures.count > 0 {
                                let stop = Stop(hslStopId: stop.gtfsId, departures: departures, stopName: stop.name)
                                stops.append(stop)
                            }
                        }
                    }
                }
                self.stops = stops
            }
        }
    }
    
    func fetchStopById(_ id: String) {
        apollo.fetch(query: StopQuery(id: id)) { result in
            guard let data = try? result.get().data else { return }
            if let hslStopId = data.stop?.gtfsId,
                let stoptimes = data.stop?.stoptimesWithoutPatterns,
                let stopname = data.stop?.name {
                let departures = self.getDeparturesFromStoptimes(stoptimes)
                if departures.count > 0 {
                    let stop = Stop(hslStopId: hslStopId, departures: departures, stopName: stopname)
                    self.stops.append(stop)
                }
            }
        }
    }
    
    func getDeparturesFromStoptimes(_ stoptimes: [StoptimesByRadius?]) -> [Departure] {
        var departures: [Departure] = []
        
        for stoptime in stoptimes {
            if let departureTimestamp = stoptime?.realtimeDeparture,
                let destination = stoptime?.headsign,
                let routeName = stoptime?.trip?.route.shortName,
                let isRealTime = stoptime?.realtime,
                let departureDelay = stoptime?.departureDelay {
                
                let departure = Departure(departureTimestamp: departureTimestamp,
                                          routeName: routeName,
                                          destination: destination,
                                          isRealTime: isRealTime,
                                          departureDelay: departureDelay)
                
                departures.append(departure)
                
                print("Departure entry: \(departureTimestamp) \(routeName) \(destination)")
            }
        }
        
        return departures
    }
    
    func getDeparturesFromStoptimes(_ stoptimes: [StoptimesById?]) -> [Departure] {
        var departures: [Departure] = []
        
        for stoptime in stoptimes {
            if let departureTimestamp = stoptime?.realtimeDeparture,
                let destination = stoptime?.headsign,
                let routeName = stoptime?.trip?.route.shortName,
                let isRealTime = stoptime?.realtime,
                let departureDelay = stoptime?.departureDelay {
                
                let departure = Departure(departureTimestamp: departureTimestamp,
                                          routeName: routeName,
                                          destination: destination,
                                          isRealTime: isRealTime,
                                          departureDelay: departureDelay)
                
                departures.append(departure)
                
                print("Departure entry: \(departureTimestamp) \(routeName) \(destination)")
            }
        }
        
        return departures
    }
    
    func clearStopCache() {
        stops = []
    }
    
    func removeStopFromCache(_ id: String) {
        if let index = stops.firstIndex(where: { stop -> Bool in
            stop.hslStopId == id
        }) {
            stops.remove(at: index)
        }
    }
    
}
