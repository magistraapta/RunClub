//
//  StatsView.swift
//  RunClub
//
//  Created by Magistra Apta on 29/04/25.
//

import SwiftUI
import Charts

struct StatsView: View {
    @EnvironmentObject var runStore: RunStore
    
    private let calendar = Calendar.current

    // Group and sum distances by week
    private var weeklyDistance: [(week: Date, distance: Double)] {
        let grouped = Dictionary(grouping: runStore.runSessions) { session in
            calendar.dateInterval(of: .weekOfYear, for: session.date)?.start ?? session.date
        }

        return grouped.map { (week, sessions) in
            let totalDistance = sessions.reduce(0) { $0 + $1.distance }
            return (week, totalDistance / 1000) // convert to km
        }
        .sorted { $0.week < $1.week }
    }

    // Group and sum distances by month
    private var monthlyDistance: [(month: Date, distance: Double)] {
        let grouped = Dictionary(grouping: runStore.runSessions) { session in
            calendar.dateInterval(of: .month, for: session.date)?.start ?? session.date
        }

        return grouped.map { (month, sessions) in
            let totalDistance = sessions.reduce(0) { $0 + $1.distance }
            return (month, totalDistance / 1000) // convert to km
        }
        .sorted { $0.month < $1.month }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    Text("Total Distance")
                        .font(.headline)
                    
                    Chart {
                        ForEach(runStore.runSessions) { session in
                            BarMark(
                                x: .value("Run", session.title),
                                y: .value("Distance (km)", session.distance / 1000) // meters to km
                            )
                            .foregroundStyle(.blue)
                        }
                    }
                    .frame(height: 200)
                    
                    Text("Average Pace")
                        .font(.headline)
                    
                    Chart {
                        ForEach(runStore.runSessions) { session in
                            LineMark(
                                x: .value("Run", session.title),
                                y: .value("Pace (min/km)", session.averagePace)
                            )
                            .symbol(Circle())
                            .interpolationMethod(.catmullRom)
                        }
                    }
                    .frame(height: 200)
                    
                    Text("Monthly Distance")
                        .font(.headline)

                    Chart {
                        ForEach(monthlyDistance, id: \.month) { item in
                            BarMark(
                                x: .value("Month", item.month, unit: .month),
                                y: .value("Distance (km)", item.distance)
                            )
                            .foregroundStyle(.orange)
                        }
                    }
                    .frame(height: 200)
                }
                .padding()
            }
            .navigationTitle("RunStats")
        }
    }
}


struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
    }
}
