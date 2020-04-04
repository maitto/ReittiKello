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
    weak var viewData: ViewData?

    func initView() {
        networkService = NetworkService()
        viewData = ViewData.shared
        stopListMode = StorageService.shared.getFavoriteStops().isEmpty ? .nearby : .favorites
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
        viewData?.departures = []
        updateFavoritedButton(id)
        networkService?.getDeparturesForStop(id) { [weak self] departures in
            if self?.viewMode == .departures {
                self?.viewData?.departures = departures
                self?.updateNoDataTitle(updating: false)
            }
        }
    }

    func updateNearbyStops(_ lat: Double, _ lon: Double) {
        networkService?.getNearbyStops(lat, lon) { [weak self] stops in
            if self?.stopListMode == .nearby && self?.viewMode == .stops {
                self?.viewData?.stops = stops
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
        if StorageService.shared.isStopFavorited(id) {
            StorageService.shared.removeFavoriteStop(id)
        } else {
            StorageService.shared.addFavoriteStop(id, stopName: name, platformName: platform)
        }
        updateFavoritedButton(id)
        viewData?.shouldUpdateStops = true
    }

    func onApplicationDidFinishLaunching() {
        StorageService.shared.createDatabase()
        initView()
    }

    func onApplicationDidBecomeActive() {
        switch viewMode {
        case .departures:
            if let id = ViewData.shared.departures.first?.hslStopId {
                updateDepartures(id)
            }
            viewData?.shouldUpdateStops = true
        case .stops:
            updateStops()
        }
    }

    private func updateNearbyStops() {
        LocationService.shared.requestLocation()
    }

    private func updateFavoriteStops() {
        ViewData.shared.stops = StorageService.shared.getFavoriteStops()
        updateNoDataTitle(updating: false)
    }

    private func updateStopListModeButton() {
        switch stopListMode {
        case .favorites:
            ViewData.shared.stopListModeButtonTitle = "show_nearby_stops".localized()
            ViewData.shared.stopListModeButtonImage = UIImage(systemName: "mappin.and.ellipse") ?? UIImage()
        case .nearby:
            ViewData.shared.stopListModeButtonTitle = "show_favorite_stops".localized()
            ViewData.shared.stopListModeButtonImage = UIImage(systemName: "star") ?? UIImage()
        }
    }

    private func updateStopListTitle() {
        switch stopListMode {
        case .favorites:
            ViewData.shared.stopListTitle = "favorite_stops".localized()
        case .nearby:
            ViewData.shared.stopListTitle = "nearby_stops".localized()
        }
    }

    private func updateFavoritedButton(_ id: String) {
        if StorageService.shared.isStopFavorited(id) {
            ViewData.shared.toggleFavoritedButtonTitle = "remove_stop_from_favorites".localized()
            ViewData.shared.toggleFavoritedButtonImage = UIImage(systemName: "star.slash.fill") ?? UIImage()
        } else {
            ViewData.shared.toggleFavoritedButtonTitle = "add_stop_to_favorites".localized()
            ViewData.shared.toggleFavoritedButtonImage = UIImage(systemName: "star.fill") ?? UIImage()
        }
    }

    private func updateNoDataTitle(updating: Bool) {
        if updating {
            ViewData.shared.noDataTitle = "updating".localized()
        } else if !ViewData.shared.stops.isEmpty {
            ViewData.shared.noDataTitle = ""
        } else {
            switch stopListMode {
            case .favorites:
                ViewData.shared.noDataTitle = "no_stops_added_to_favorites".localized()
            case .nearby:
                ViewData.shared.noDataTitle = "no_stops_nearby".localized()
            }
        }
    }
}
