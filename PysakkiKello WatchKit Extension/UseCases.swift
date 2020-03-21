//
//  UseCases.swift
//  PysakkiKello WatchKit Extension
//
//  Created by Mortti Aittokoski on 21.3.2020.
//  Copyright © 2020 Mortti Aittokoski. All rights reserved.
//

import Foundation

class UseCases {
    
    static let shared = UseCases()
    
    var viewMode: ViewMode = .favorites
    
    func initView() {
        viewMode = StorageService.shared.getFavoriteStops().isEmpty ? .nearby : .favorites
        updateNoDataTitle(updating: true)
        updateViewModeButtonTitle()
        updateStopListTitle()
    }
    
    func updateStops() {
        switch viewMode {
        case .favorites:
            updateFavoriteStops()
        case .nearby:
            updateNearbyStops()
        }
    }
    
    func updateDepartures(_ id: String) {
        ViewData.shared.departures = []
        updateFavoritedButtonTitle(id)
        NetworkService.shared.getDeparturesForStop(id) { departures in
            ViewData.shared.departures = departures
            self.updateNoDataTitle(updating: false)
        }
    }
    
    func updateNearbyStops(_ lat: Double,_ lon: Double) {
        NetworkService.shared.getNearbyStops(lat, lon) { stops in
            ViewData.shared.stops = stops
            self.updateNoDataTitle(updating: false)
        }
    }
    
    func toggleListMode() {
        switch viewMode {
        case .favorites:
            viewMode = .nearby
        case .nearby:
            viewMode = .favorites
        }
        updateNoDataTitle(updating: true)
        updateViewModeButtonTitle()
        updateStopListTitle()
        updateStops()
    }
    
    func toggleIsStopFavorited(_ id: String, name: String, platform: String?) {
        if StorageService.shared.isStopFavorited(id) {
            StorageService.shared.removeFavoriteStop(id)
        } else {
            StorageService.shared.addFavoriteStop(id, stopName: name, platformName: platform)
        }
        updateFavoritedButtonTitle(id)
        updateStops()
    }
    
    func onApplicationDidFinishLaunching() {
        StorageService.shared.createDatabase()
        initView()
    }
    
    func onApplicationDidBecomeActive() {
        if let id = ViewData.shared.departures.first?.hslStopId {
            updateDepartures(id)
        }
        updateStops()
    }
    
    private func updateNearbyStops() {
        LocationService.shared.requestLocation()
    }
    
    private func updateFavoriteStops() {
        ViewData.shared.stops = StorageService.shared.getFavoriteStops()
        updateNoDataTitle(updating: false)
    }
    
    private func updateViewModeButtonTitle() {
        switch viewMode {
        case .favorites:
            ViewData.shared.viewModeButtonTitle = "Show nearby stops"
        case .nearby:
            ViewData.shared.viewModeButtonTitle = "Show favorite stops"
        }
    }
    
    private func updateStopListTitle() {
        switch viewMode {
        case .favorites:
            ViewData.shared.stopListTitle = "Favorite stops"
        case .nearby:
            ViewData.shared.stopListTitle = "Nearby stops"
        }
    }
    
    private func updateFavoritedButtonTitle(_ id: String) {
        if StorageService.shared.isStopFavorited(id) {
            ViewData.shared.toggleFavoritedButtonTitle = "Remove stop from favorites"
        } else {
            ViewData.shared.toggleFavoritedButtonTitle = "Add stop to favorites"
        }
    }
    
    private func updateNoDataTitle(updating: Bool) {
        if updating {
            ViewData.shared.noDataTitle = "Updating..."
        } else {
            switch viewMode {
            case .favorites:
                if ViewData.shared.stops.isEmpty {
                    ViewData.shared.noDataTitle = "No stops added to favorites"
                } else {
                    ViewData.shared.noDataTitle = ""
                }
            case .nearby:
                if ViewData.shared.stops.isEmpty {
                    ViewData.shared.noDataTitle = "No stops nearby"
                } else {
                    ViewData.shared.noDataTitle = ""
                }
            }
        }
    }
}
