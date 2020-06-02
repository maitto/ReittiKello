//
//  StopData.swift
//  PysakkiKello WatchKit Extension
//
//  Created by Mortti Aittokoski on 19.3.2020.
//  Copyright © 2020 Mortti Aittokoski. All rights reserved.
//

import UIKit

class StopsModel: ObservableObject {
    static let shared = StopsModel()

    @Published var stops: [Stop] = []
    @Published var stopListTitle = ""
    @Published var stopListModeButtonTitle = ""
    @Published var stopListModeButtonImage = UIImage()
    @Published var noDataTitle = ""
    @Published var shouldUpdateStops = false
}
