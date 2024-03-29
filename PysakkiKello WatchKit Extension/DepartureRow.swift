//
//  DepartureRow.swift
//  PysakkiKello WatchKit Extension
//
//  Created by Mortti Aittokoski on 23.2.2020.
//  Copyright © 2020 Mortti Aittokoski. All rights reserved.
//

import SwiftUI

struct DepartureRow: View {
    var departure: Departure

    var body: some View {
        HStack {
            Text(departure.formattedDepartureTime) .foregroundColor(getBackgroundColorForDeparture(departure))
            Text(departure.routeName).frame(minWidth: 9, idealWidth: 9, maxWidth: 20, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment: .center)
            Text(departure.destination)
        }
    }
}

struct DepartureRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DepartureRow(departure: Departure(hslStopId: "", departureTimestamp: 123, routeName: "U", destination: "Helsinki", isRealTime: true, departureDelay: 10))
        }
    }
}

fileprivate func getBackgroundColorForDeparture(_ departure: Departure) -> Color? {
    if departure.departureDelay > 60 {
        return .orange
    } else if departure.isRealTime {
        return .green
    } else {
        return nil
    }
}
