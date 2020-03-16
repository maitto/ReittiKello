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
    
    func showFavoriteStops() {
        StopData.shared.isLoading = true
        let favoriteStopIds = StorageService.shared.getFavoriteStops()
        StopData.shared.clearStopCache()
        StopData.shared.fetchStopsById(favoriteStopIds)
    }
    
    func showNearbyStops() {
        StopData.shared.isLoading = true
        StopData.shared.clearStopCache()
        LocationService.shared.requestLocation()
    }
    
    func toggleListMode() {
        switch viewMode {
        case .favorites:
            viewMode = .nearby
            showNearbyStops()
        case .nearby:
            viewMode = .favorites
            showFavoriteStops()
        }
    }
    
    func updateStops() {
        switch viewMode {
        case .favorites:
            showFavoriteStops()
        case .nearby:
            showNearbyStops()
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
    
    func toggleIsStopFavorited(_ id: String) {
        if StorageService.shared.isStopFavorited(id) {
            StorageService.shared.removeFavoriteStop(id)
        } else {
            StorageService.shared.addFavoriteStop(id)
        }
        updateStops()
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
