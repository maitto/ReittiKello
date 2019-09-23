//
//  DeparturesView.swift
//  ReittiKello WatchKit Extension
//
//  Created by Mortti Aittokoski on 23.9.2019.
//  Copyright © 2019 Mortti Aittokoski. All rights reserved.
//


import SwiftUI

struct DeparturesView: View {
    var departures: [Departure]
    
    var body: some View {
        
        List(departures, rowContent: DepartureRow.init)
    }
}

struct DeparturessView_Previews: PreviewProvider {
    static var previews: some View {
        DeparturesView(departures: [])
    }
}

