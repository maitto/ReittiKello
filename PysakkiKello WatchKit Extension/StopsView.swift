//
//  StopsView.swift
//  PysakkiKello WatchKit Extension
//
//  Created by Mortti Aittokoski on 23.2.2020.
//  Copyright © 2020 Mortti Aittokoski. All rights reserved.
//

import SwiftUI

struct StopsView: View {
    @ObservedObject var viewData: ViewData
    let viewModel = ViewModel.shared

    var body: some View {
        VStack(alignment: .leading, spacing: nil, content: {
            if viewData.noDataTitle != "" {
                Text(viewData.noDataTitle)
            } else {
                Text(viewData.stopListTitle)
                List(viewData.stops, rowContent: StopRow.init)
            }
        })
            .contextMenu {
                Button(action: {
                    self.viewModel.toggleListMode()
                }) {
                    VStack {
                        Text(viewData.stopListModeButtonTitle)
                        Image(uiImage: viewData.stopListModeButtonImage)
                    }
                }
        }.onAppear {
            print("onAppear StopsView")
            self.viewModel.viewMode = .stops
            if self.viewData.shouldUpdateStops {
                self.viewData.shouldUpdateStops = false
                self.viewModel.updateStops()
            }
        }
    }
}

struct StopsView_Previews: PreviewProvider {
    static var previews: some View {
        StopsView(viewData: ViewData())
    }
}
