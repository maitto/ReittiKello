//
//  ViewModel.swift
//  PysakkiKello WatchKit Extension
//
//  Created by Mortti Aittokoski on 21.3.2020.
//  Copyright © 2020 Mortti Aittokoski. All rights reserved.
//

import UIKit

class ViewModel {
    static let shared = ViewModel()

    var stopListMode: StopListMode = .favorites
    var viewMode: ViewMode = .stops
    
    var networkService: NetworkService?
    var departuresModel: DeparturesModel?
    var stopsModel: StopsModel?
    var locationService: LocationService?
    var storageService: StorageService?

    func initView() {
        locationService = LocationService.shared
        storageService = StorageService.shared
        networkService = NetworkService()
        stopsModel = StopsModel.shared
        departuresModel = DeparturesModel.shared
        storageService?.createDatabase()
        stopListMode = storageService?.getFavoriteStops().isEmpty ?? true ? .nearby : .favorites
        updateNoDataTitle(updating: true)
        updateStopListModeButton()
        updateStopListTitle()
    }

    func updateStops() {
        switch stopListMode {
        case .favorites:
            updateFavoriteStops()
        case .nearby:
            updateNearbyStops()
        }
    }

    func updateDepartures(_ id: String) {
        departuresModel?.stopId = id
        departuresModel?.departures = []
        updateFavoritedButton(id)
        networkService?.getDeparturesForStop(id) { [weak self] departures in
            if self?.viewMode == .departures {
                self?.departuresModel?.departures = departures
                self?.updateNoDataTitle(updating: false)
            }
        }
    }

    func updateNearbyStops(_ lat: Double, _ lon: Double) {
        networkService?.getNearbyStops(lat, lon) { [weak self] stops in
            if self?.stopListMode == .nearby && self?.viewMode == .stops {
                self?.stopsModel?.stops = stops
                self?.updateNoDataTitle(updating: false)
            }
        }
    }

    func toggleListMode() {
        switch stopListMode {
        case .favorites:
            stopListMode = .nearby
        case .nearby:
            stopListMode = .favorites
        }
        updateNoDataTitle(updating: true)
        updateStopListModeButton()
        updateStopListTitle()
        updateStops()
    }

    func toggleIsStopFavorited(_ id: String, name: String, platform: String?) {
        if storageService?.isStopFavorited(id) ?? false {
            storageService?.removeFavoriteStop(id)
        } else {
            storageService?.addFavoriteStop(id, stopName: name, platformName: platform)
        }
        updateFavoritedButton(id)
        stopsModel?.shouldUpdateStops = true
    }

    func onApplicationDidFinishLaunching() {
        initView()
    }

    func onApplicationDidBecomeActive() {
        switch viewMode {
        case .departures:
            if let id = departuresModel?.stopId, id != "" {
                updateDepartures(id)
            }
            stopsModel?.shouldUpdateStops = true
        case .stops:
            updateStops()
        }
    }

    private func updateNearbyStops() {
        locationService?.requestLocation()
    }

    private func updateFavoriteStops() {
        stopsModel?.stops = storageService?.getFavoriteStops() ?? []
        updateNoDataTitle(updating: false)
    }

    private func updateStopListModeButton() {
        switch stopListMode {
        case .favorites:
            stopsModel?.stopListModeButtonTitle = "show_nearby_stops".localized()
            stopsModel?.stopListModeButtonImage = UIImage(systemName: "mappin.and.ellipse") ?? UIImage()
        case .nearby:
            stopsModel?.stopListModeButtonTitle = "show_favorite_stops".localized()
            stopsModel?.stopListModeButtonImage = UIImage(systemName: "star") ?? UIImage()
        }
    }

    private func updateStopListTitle() {
        switch stopListMode {
        case .favorites:
            stopsModel?.stopListTitle = "favorite_stops".localized()
        case .nearby:
            stopsModel?.stopListTitle = "nearby_stops".localized()
        }
    }

    private func updateFavoritedButton(_ id: String) {
        if storageService?.isStopFavorited(id) ?? false {
            departuresModel?.toggleFavoritedButtonTitle = "remove_stop_from_favorites".localized()
            departuresModel?.toggleFavoritedButtonImage = UIImage(systemName: "star.slash.fill") ?? UIImage()
        } else {
            departuresModel?.toggleFavoritedButtonTitle = "add_stop_to_favorites".localized()
            departuresModel?.toggleFavoritedButtonImage = UIImage(systemName: "star.fill") ?? UIImage()
        }
    }

    private func updateNoDataTitle(updating: Bool) {
        if updating {
            stopsModel?.noDataTitle = "updating".localized()
        } else if !(stopsModel?.stops.isEmpty ?? false) {
            stopsModel?.noDataTitle = ""
        } else {
            switch stopListMode {
            case .favorites:
                stopsModel?.noDataTitle = "no_stops_added_to_favorites".localized()
            case .nearby:
                stopsModel?.noDataTitle = "no_stops_nearby".localized()
            }
        }
    }
}
