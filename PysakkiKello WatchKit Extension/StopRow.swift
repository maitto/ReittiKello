//
//  StopRow.swift
//  PysakkiKello WatchKit Extension
//
//  Created by Mortti Aittokoski on 23.2.2020.
//  Copyright © 2020 Mortti Aittokoski. All rights reserved.
//

import SwiftUI

struct StopRow: View {
    var stop: Stop
    
    var body: some View {
        NavigationLink(destination: DeparturesView(departures: stop.departures)) {
            Text(stop.stopName)
        }
    }
}

struct StopRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StopRow(stop: Stop(departures: [], stopName: "stop name"))
        }
    }
}
