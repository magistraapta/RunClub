//
//  ContentView.swift
//  RunClub
//
//  Created by Magistra Apta on 28/04/25.
//

import SwiftUI

struct ContentView: View {
    
    enum Tab {
        case home, stats
    }
    
    @State var selectedTab: Tab = .home
    var body: some View {
        TabView(selection: $selectedTab) {
            
            RunningView()
                .tabItem {
                    Label("Record", systemImage: "record.circle.fill")
                }
            StatsView()
                .tabItem {
                    Label("Stats", systemImage: "figure.run.circle.fill")
                }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
