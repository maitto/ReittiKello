//
//  StopData.swift
//  PysakkiKello WatchKit Extension
//
//  Created by Mortti Aittokoski on 19.3.2020.
//  Copyright © 2020 Mortti Aittokoski. All rights reserved.
//

import UIKit

class ViewData: ObservableObject {
    static let shared = ViewData()

    @Published var stops: [Stop] = []
    @Published var departures: [Departure] = []
    @Published var stopListTitle = ""
    @Published var viewModeButtonTitle = ""
    @Published var viewModeButtonImage = UIImage()
    @Published var toggleFavoritedButtonTitle = ""
    @Published var toggleFavoritedButtonImage = UIImage()
    @Published var noDataTitle = ""
}
