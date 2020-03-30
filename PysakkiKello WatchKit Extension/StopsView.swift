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
                    ViewModel.shared.toggleListMode()
                }) {
                    VStack {
                        Text(viewData.viewModeButtonTitle)
                        Image(uiImage: viewData.viewModeButtonImage)
                    }
                }
        }
    }
}

struct StopsView_Previews: PreviewProvider {
    static var previews: some View {
        StopsView(viewData: ViewData())
    }
}
