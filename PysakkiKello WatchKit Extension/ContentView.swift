//
//  ContentView.swift
//  PysakkiKello WatchKit Extension
//
//  Created by Mortti Aittokoski on 23.2.2020.
//  Copyright © 2020 Mortti Aittokoski. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var stopData: StopData
    
    var body: some View {
        VStack(alignment: .leading, spacing: nil, content: {
            if UseCases.shared.getShouldHideStopsList() {
                Text(UseCases.shared.getTextForNoDataState())
            } else {
                Text(UseCases.shared.getViewModeListTitle())
                List(stopData.stops, rowContent: StopRow.init)
            }
        })
            .contextMenu {
                Button(action: {
                    UseCases.shared.toggleListMode()
                }) {
                    Text(UseCases.shared.getViewModeChangeTitle())
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(stopData: StopData())
    }
}
