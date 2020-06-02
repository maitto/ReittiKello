//
//  HostingController.swift
//  PysakkiKello WatchKit Extension
//
//  Created by Mortti Aittokoski on 23.2.2020.
//  Copyright © 2020 Mortti Aittokoski. All rights reserved.
//

import WatchKit
import Foundation
import SwiftUI

class HostingController: WKHostingController<StopsView> {
    override var body: StopsView {
        return StopsView(stopsModel: StopsModel.shared)
    }
}
