//
//  DeparturesModel.swift
//  PysakkiKello WatchKit Extension
//
//  Created by Mortti Aittokoski on 2.6.2020.
//  Copyright © 2020 Mortti Aittokoski. All rights reserved.
//

import UIKit

class DeparturesModel: ObservableObject {
    static let shared = DeparturesModel()
    
    @Published var stopId: String = ""
    @Published var departures: [Departure] = []
    @Published var toggleFavoritedButtonTitle = ""
    @Published var toggleFavoritedButtonImage = UIImage()
}
