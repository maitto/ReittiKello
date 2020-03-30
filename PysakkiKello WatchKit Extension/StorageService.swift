//
//  StorageService.swift
//  PysakkiKello WatchKit Extension
//
//  Created by Mortti Aittokoski on 13.3.2020.
//  Copyright © 2020 Mortti Aittokoski. All rights reserved.
//

import Foundation
import SQLite

class StorageService {
    static let shared = StorageService()
    let key = "favorites"
    let defaults = UserDefaults.standard

    var favoritesUpdated = false

    var dbConnection: Connection?
    var dbPath = ""
    let stopTable = Table("stops")
    let id = Expression<String>("id")
    let name = Expression<String>("name")
    let platform = Expression<String?>("platform")

    func createDatabase() {
        guard let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
        ).first else {
            return
        }

        dbPath = "\(path)/db.sqlite3"
        do {
            dbConnection = try Connection(dbPath)
        } catch {
            print(error)
        }
        guard let dbConnection = dbConnection else {
            return
        }
        do {
            try dbConnection.run(stopTable.create { table in
                table.column(id, primaryKey: true)
                table.column(name)
                table.column(platform)
            })
        } catch {
            print(error)
        }
    }

    func getFavoriteStops() -> [Stop] {
        var stops: [Stop] = []
        guard let dbConnection = dbConnection else {
            return stops
        }

        do {
            for stop in try dbConnection.prepare(stopTable) {
                stops.append(Stop(id: stop[id], stopName: stop[name], platformCode: stop[platform]))
            }
        } catch {
            print(error)
        }

        return stops
    }

    func isStopFavorited(_ stopId: String) -> Bool {
        guard let dbConnection = dbConnection else {
            return false
        }
        let stop = stopTable.filter(id == stopId).exists
        do {
            return try dbConnection.scalar(stop)
        } catch {
            print(error)
            return false
        }
    }

    func addFavoriteStop(_ stopId: String, stopName: String, platformName: String?) {
        guard let dbConnection = dbConnection else {
            return
        }
        let insert = stopTable.insert(id <- stopId, name <- stopName, platform <- platformName)
        do {
            try dbConnection.run(insert)
        } catch {
            print(error)
        }
    }

    func removeFavoriteStop(_ stopId: String) {
        guard let dbConnection = dbConnection else {
            return
        }
        let stop = stopTable.filter(id == stopId)
        do {
            try dbConnection.run(stop.delete())
        } catch {
            print(error)
        }
    }
}
