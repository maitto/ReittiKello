//
//  ContentView.swift
//  ReittiKello WatchKit Extension
//
//  Created by Mortti Aittokoski on 10.9.2019.
//  Copyright © 2019 Mortti Aittokoski. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var stopData: StopData
    
    var body: some View {
        
        List(stopData.stops, rowContent: StopRow.init)
            .onAppear(perform: LocationService.shared.requestLocation)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(stopData: StopData())
    }
}
