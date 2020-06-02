//
//  StopsView.swift
//  PysakkiKello WatchKit Extension
//
//  Created by Mortti Aittokoski on 23.2.2020.
//  Copyright © 2020 Mortti Aittokoski. All rights reserved.
//

import SwiftUI

struct StopsView: View {
    @ObservedObject var stopsModel: StopsModel
    let viewModel = ViewModel.shared

    var body: some View {
        VStack(alignment: .leading, spacing: nil, content: {
            if stopsModel.noDataTitle != "" {
                Text(stopsModel.noDataTitle)
            } else {
                Text(stopsModel.stopListTitle)
                List(stopsModel.stops, rowContent: StopRow.init)
            }
        })
            .contextMenu {
                Button(action: {
                    self.viewModel.toggleListMode()
                }) {
                    VStack {
                        Text(stopsModel.stopListModeButtonTitle)
                        Image(uiImage: stopsModel.stopListModeButtonImage)
                    }
                }
        }.onAppear {
            print("onAppear StopsView")
            self.viewModel.viewMode = .stops
            if self.stopsModel.shouldUpdateStops {
                self.stopsModel.shouldUpdateStops = false
                self.viewModel.updateStops()
            }
        }
    }
}

struct StopsView_Previews: PreviewProvider {
    static var previews: some View {
        StopsView(stopsModel: StopsModel())
    }
}
