//
//  ViewModel.swift
//  PysakkiKello WatchKit Extension
//
//  Created by Mortti Aittokoski on 21.3.2020.
//  Copyright © 2020 Mortti Aittokoski. All rights reserved.
//

import Foundation

class ViewModel {
    static let shared = ViewModel()
    
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
            ViewData.shared.viewModeButtonTitle = "show_nearby_stops".localized()
        case .nearby:
            ViewData.shared.viewModeButtonTitle = "show_favorite_stops".localized()
        }
    }
    
    private func updateStopListTitle() {
        switch viewMode {
        case .favorites:
            ViewData.shared.stopListTitle = "favorite_stops".localized()
        case .nearby:
            ViewData.shared.stopListTitle = "nearby_stops".localized()
        }
    }
    
    private func updateFavoritedButtonTitle(_ id: String) {
        if StorageService.shared.isStopFavorited(id) {
            ViewData.shared.toggleFavoritedButtonTitle = "remove_stop_from_favorites".localized()
        } else {
            ViewData.shared.toggleFavoritedButtonTitle = "add_stop_to_favorites".localized()
        }
    }
    
    private func updateNoDataTitle(updating: Bool) {
        if updating {
            ViewData.shared.noDataTitle = "updating".localized()
        } else if !ViewData.shared.stops.isEmpty {
            ViewData.shared.noDataTitle = ""
        } else {
            switch viewMode {
            case .favorites:
                ViewData.shared.noDataTitle = "no_stops_added_to_favorites".localized()
            case .nearby:
                ViewData.shared.noDataTitle = "no_stops_nearby".localized()
            }
        }
    }
}