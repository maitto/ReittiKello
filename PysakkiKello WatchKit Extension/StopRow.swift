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
        NavigationLink(destination: DeparturesView(hslStopId: stop.id, stopName: stop.stopName, platform: stop.platformCode, departuresModel: DeparturesModel.shared)) {
            VStack {
                Text(stop.stopName)
                if stop.platformCode != nil {
                    Text("\("platform".localized()) \(stop.platformCode ?? "")")
                        .font(.footnote)
                }
            }
        }
    }
}

struct StopRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StopRow(stop: Stop(id: "", stopName: "", platformCode: ""))
        }
    }
}
