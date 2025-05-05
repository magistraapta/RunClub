//
//  ContentView.swift
//  RunClub
//
//  Created by Magistra Apta on 28/04/25.
//

import SwiftUI

struct ContentView: View {
    
    enum Tab {
        case home, record, stats
    }
    
    @StateObject var runStore = RunStore()
    @State var selectedTab: Tab = .home
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(Tab.home)
            
            RunningView()
                .tabItem {
                    Label("Record", systemImage: "record.circle.fill")
                }
                .tag(Tab.record)
            
            
            StatsView()
                .tabItem {
                    Label("Stats", systemImage: "figure.run.circle.fill")
                }
                .tag(Tab.stats)
        }
        .environmentObject(runStore)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
