//
//  HostingController.swift
//  ReittiKello WatchKit Extension
//
//  Created by Mortti Aittokoski on 10.9.2019.
//  Copyright © 2019 Mortti Aittokoski. All rights reserved.
//

import WatchKit
import Foundation
import SwiftUI

class HostingController: WKHostingController<ContentView> {
    override var body: ContentView {
        return ContentView(departureData: DepartureData())
    }
}
