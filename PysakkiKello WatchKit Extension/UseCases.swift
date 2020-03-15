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
        StopData.shared.clearStopCache()
        let favoriteStopIds = StorageService.shared.getFavoriteStops()
        for id in favoriteStopIds {
            StopData.shared.fetchStopById(id)
        }
    }
    
    func showNearbyStops() {
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
    
    func showStopsAtAppLaunch() {
        switch viewMode {
        case .favorites:
            showFavoriteStops()
        case .nearby:
            showNearbyStops()
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
        if StorageService.shared.getFavoriteStops().contains(id) {
            StorageService.shared.removeFavoriteStop(id)
            if viewMode == .favorites {
                StopData.shared.removeStopFromCache(id)
            }
        } else {
            StorageService.shared.addFavoriteStop(id)
            if viewMode == .favorites {
                    
            }
        }
        
    }
    
    func getToggleIsStopFavoritedButtonTitle(_ id: String) -> String {
        if StorageService.shared.getFavoriteStops().contains(id) {
            return "Remove stop from favorites"
        } else {
            return "Add stop to favorites"
        }
    }
}