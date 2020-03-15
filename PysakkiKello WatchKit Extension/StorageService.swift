//
//  StorageService.swift
//  PysakkiKello WatchKit Extension
//
//  Created by Mortti Aittokoski on 13.3.2020.
//  Copyright © 2020 Mortti Aittokoski. All rights reserved.
//

import Foundation

class StorageService {
    static let shared = StorageService()
    let key = "favorites"
    let defaults = UserDefaults.standard
    
    func getFavoriteStops() -> [String] {
        let favorites = defaults.stringArray(forKey: key) ?? []
        return favorites
    }
    
    func addFavoriteStop(_ id: String) {
        var favorites = defaults.stringArray(forKey: key) ?? []
        favorites.append(id)
        defaults.set(favorites, forKey: key)
    }
    
    func removeFavoriteStop(_ id: String) {
        var favorites = defaults.stringArray(forKey: key) ?? []
        if let index = favorites.firstIndex(of: id) {
            favorites.remove(at: index)
        }
        defaults.set(favorites, forKey: key)
    }
}