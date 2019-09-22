//
//  ContentView.swift
//  ReittiKello WatchKit Extension
//
//  Created by Mortti Aittokoski on 10.9.2019.
//  Copyright © 2019 Mortti Aittokoski. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var departureData: DepartureData
    
    var body: some View {
        List(departureData.departures, rowContent: DepartureRow.init)
            .onAppear(perform: departureData.fetch)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(departureData: DepartureData())
    }
}
