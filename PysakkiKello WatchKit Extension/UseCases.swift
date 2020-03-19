//
//  UseCases.swift
//  PysakkiKello WatchKit Extension
//
//  Created by Mortti Aittokoski on 14.3.2020.
//  Copyright © 2020 Mortti Aittokoski. All rights reserved.
//

import Foundation
import CoreLocation

enum ViewMode {
    case favorites
    case nearby
}

class UseCases {
    static let shared = UseCases()
    
    var viewMode: ViewMode = StorageService.shared.getFavoriteStops().isEmpty ? .nearby : .favorites
    
    func updateFavoriteStops() {
        StopData.shared.stops = StorageService.shared.getFavoriteStops()
    }
    
    func updateNearbyStops() {
        StopData.shared.isLoading = true
        StopData.shared.clearStopCache()
        LocationService.shared.requestLocation()
    }
    
    func showDeparturesForStop(_ id: String) {
        StopData.shared.clearDepartureCache()
        StopData.shared.fetchStop(id)
    }
    
    func toggleListMode() {
        switch viewMode {
        case .favorites:
            viewMode = .nearby
            updateNearbyStops()
        case .nearby:
            viewMode = .favorites
            updateFavoriteStops()
        }
    }
    
    func updateStops() {
        switch viewMode {
        case .favorites:
            updateFavoriteStops()
        case .nearby:
            updateNearbyStops()
        }
    }
    
    func updateDepartures() {
        if let hslStopId = StopData.shared.departures.first?.hslStopId {
            StopData.shared.fetchStop(hslStopId)
        }
    }
    
    func getViewModeListTitle() -> String {
        switch viewMode {
        case .favorites:
            return "Favorite stops"
        case .nearby:
            return "Nearby stops"
        }
    }
    
    func getViewModeChangeTitle() -> String {
        switch viewMode {
        case .favorites:
            return "Show nearby stops"
        case .nearby:
            return "Show favorite stops"
        }
    }
    
    func toggleIsStopFavorited(_ id: String, name: String, platform: String?) {
        if StorageService.shared.isStopFavorited(id) {
            StorageService.shared.removeFavoriteStop(id)
        } else {
            StorageService.shared.addFavoriteStop(id, stopName: name, platformName: platform)
        }
    }
    
    func getToggleIsStopFavoritedButtonTitle(_ id: String) -> String {
        if StorageService.shared.isStopFavorited(id) {
            return "Remove stop from favorites"
        } else {
            return "Add stop to favorites"
        }
    }
    
    func getTextForNoDataState() -> String {
        if StopData.shared.isLoading {
            return "Loading..."
        } else {
            switch viewMode {
            case .favorites:
                return "No stops added to favorites"
            case .nearby:
                return "No stops nearby"
            }
        }
    }
    
    func getShouldHideStopsList() -> Bool {
        return StopData.shared.isLoading || StopData.shared.stops.isEmpty
    }
}
