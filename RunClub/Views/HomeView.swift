//
//  HomeView.swift
//  RunClub
//
//  Created by Magistra Apta on 28/04/25.
//

import SwiftUI



struct HomeView: View {
    @EnvironmentObject var runStore: RunStore
    @StateObject var locationManager = LocationManager()
    var body: some View {
        VStack(alignment: .leading) {
            Text("RunClub")
                .font(.largeTitle)
                .bold()

            Spacer()

            ScrollView {
                ForEach(runStore.runSessions) { runSession in
                    RunSessionCard(
                        title: runSession.title,
                        date: formatDate(runSession.date),
                        coordinate: runSession.route.map { $0.cllocationCoordinate2D }
                    )
                }
            }
        }
        .padding()
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
