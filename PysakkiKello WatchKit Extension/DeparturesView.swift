//
//  DeparturesView.swift
//  PysakkiKello WatchKit Extension
//
//  Created by Mortti Aittokoski on 23.2.2020.
//  Copyright © 2020 Mortti Aittokoski. All rights reserved.
//

import SwiftUI

struct DeparturesView: View {
    var departures: [Departure]
    var hslStopId: String
    
    var body: some View {
        List(departures, rowContent: DepartureRow.init)
        .contextMenu {
            Button(action: {
                UseCases.shared.toggleIsStopFavorited(self.hslStopId)
            }) {
                Text(UseCases.shared.getToggleIsStopFavoritedButtonTitle(hslStopId))
            }
        }
    }
}

struct DeparturessView_Previews: PreviewProvider {
    static var previews: some View {
        DeparturesView(departures: [], hslStopId: "")
    }
}
