//
//  DeprtureRow.swift
//  ReittiKello WatchKit Extension
//
//  Created by Mortti Aittokoski on 14.9.2019.
//  Copyright © 2019 Mortti Aittokoski. All rights reserved.
//

import SwiftUI

struct DepartureRow: View {
    var departure: Departure
    
    var body: some View {
        
        HStack {
            Text(departure.departureTimestamp) .foregroundColor(getBackgroundColorForDeparture(departure))
            Spacer()
            Text(departure.lineNumber)
            Spacer()
            Text(departure.destination)
        }
    }
}

struct DepartureRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DepartureRow(departure: Departure(id: "1", departureTimestamp: "123", lineNumber: "U", destination: "Helsinki", realTime: true, departureDelay: 10))
        }
    }
}


func getBackgroundColorForDeparture(_ departure: Departure) -> Color? {
    if departure.departureDelay > 0 {
        return .orange
    } else if departure.realTime {
        return .green
    } else {
        return nil
    }
}
