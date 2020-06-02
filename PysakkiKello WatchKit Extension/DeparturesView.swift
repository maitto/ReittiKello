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

    @ObservedObject var departuresModel: DeparturesModel
    let viewModel = ViewModel.shared

    var body: some View {
        VStack(alignment: .leading, spacing: nil, content: {
            Text(stopName)
            if platform != nil {
                Text("\("platform".localized()) \(platform ?? "")")
                    .font(.footnote)
            }
            List(departuresModel.departures, rowContent: DepartureRow.init)
                .contextMenu {
                    Button(action: {
                        self.viewModel.toggleIsStopFavorited(self.hslStopId, name: self.stopName, platform: self.platform)
                    }) {
                        VStack {
                            Text(departuresModel.toggleFavoritedButtonTitle)
                            Image(uiImage: departuresModel.toggleFavoritedButtonImage)
                        }
                    }
            }
        }).onAppear {
            print("DeparturesView onAppear")
            self.viewModel.viewMode = .departures
            self.viewModel.updateDepartures(self.hslStopId)
        }
    }
}

struct DeparturessView_Previews: PreviewProvider {
    static var previews: some View {
        DeparturesView(hslStopId: "", stopName: "", platform: "", departuresModel: DeparturesModel())
    }
}
