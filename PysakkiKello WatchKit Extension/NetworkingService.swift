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
    private var operation: Cancellable?
    
    @Published var stops: [Stop] = []
    @Published var departures: [Departure] = []
    @Published var isLoading: Bool = false
    
    func fetchNearbyStops(_ lat: Double, _ lon: Double, _ radius: Int = 900) {
        operation?.cancel()
        operation = apollo.fetch(query: StopsByRadiusQuery(lat: lat, lon: lon, radius: radius)) { result in
            guard let data = try? result.get().data else { return }
            if let edges = data.stopsByRadius?.edges {
                var stops: [Stop] = []
                
                for edge in edges {
                    if let stop = edge?.node?.stop,
                        !(stop.stoptimesWithoutPatterns?.isEmpty ?? true) {
                        let stop = Stop(id: stop.gtfsId, stopName: stop.name, platformCode: stop.platformCode)
                        stops.append(stop)
                    }
                }
                self.stops = stops
                self.isLoading = false
            }
        }
    }
    
    func fetchStop(_ hslStopId: String) {
        operation?.cancel()
        operation = apollo.fetch(query: StopQuery(id: hslStopId)) { result in
            guard let data = try? result.get().data else { return }
            if let stoptimes = data.stop?.stoptimesWithoutPatterns {
                self.departures = self.getDeparturesFromStoptimes(hslStopId, stoptimes)
            }
        }
    }
    
    
    func getDeparturesFromStoptimes(_ hslStopId: String, _ stoptimes: [StopQuery.Data.Stop.StoptimesWithoutPattern?]) -> [Departure] {
        var departures: [Departure] = []
        
        for stoptime in stoptimes {
            if let departureTimestamp = stoptime?.realtimeDeparture,
                let destination = stoptime?.headsign,
                let routeName = stoptime?.trip?.route.shortName,
                let isRealTime = stoptime?.realtime,
                let departureDelay = stoptime?.departureDelay {
                
                let departure = Departure(hslStopId: hslStopId,
                                          departureTimestamp: departureTimestamp,
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
        apollo.clearCache()
    }
    
    func clearDepartureCache() {
        departures = []
        apollo.clearCache()
    }
    
}
