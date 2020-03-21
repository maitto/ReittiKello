//
//  StopData.swift
//  PysakkiKello WatchKit Extension
//
//  Created by Mortti Aittokoski on 19.3.2020.
//  Copyright © 2020 Mortti Aittokoski. All rights reserved.
//

import Foundation

class ViewData: ObservableObject {
    static let shared = ViewData()
    
    @Published var stops: [Stop] = []
    @Published var departures: [Departure] = []
    @Published var stopListTitle = ""
    @Published var viewModeButtonTitle = ""
    @Published var toggleFavoritedButtonTitle = ""
    @Published var noDataTitle = ""
}
