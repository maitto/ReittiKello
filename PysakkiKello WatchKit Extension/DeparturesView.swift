//
//  DeparturesView.swift
//  PysakkiKello WatchKit Extension
//
//  Created by Mortti Aittokoski on 23.2.2020.
//  Copyright © 2020 Mortti Aittokoski. All rights reserved.
//

import SwiftUI

struct DeparturesView: View {
    var hslStopId: String
    var stopName: String
    var platform: String?
    
    @State private var isStopFavoriteStateChanged = false
    @ObservedObject var stopData: StopData
    
    var body: some View {
        VStack(alignment: .leading, spacing: nil, content: {
            Text(stopName)
            if platform != nil {
                Text("Platform \(platform ?? "")")
                    .font(.footnote)
            }
            List(stopData.departures, rowContent: DepartureRow.init)
                .contextMenu {
                    Button(action: {
                        UseCases.shared.toggleIsStopFavorited(self.hslStopId, name: self.stopName, platform: self.platform)
                        self.isStopFavoriteStateChanged.toggle()
                    }) {
                        if isStopFavoriteStateChanged {
                            Text(UseCases.shared.getToggleIsStopFavoritedButtonTitle(hslStopId))
                        } else {
                            Text(UseCases.shared.getToggleIsStopFavoritedButtonTitle(hslStopId))
                        }
                    }
            }
        }).onAppear {
            print("DeparturesView onAppear")
            UseCases.shared.showDeparturesForStop(self.hslStopId)
        }
    }
}

struct DeparturessView_Previews: PreviewProvider {
    static var previews: some View {
        DeparturesView(hslStopId: "", stopName: "", platform: "", stopData: StopData())
    }
}
