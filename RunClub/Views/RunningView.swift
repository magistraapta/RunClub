//
//  RunningView.swift
//  RunClub
//
//  Created by Magistra Apta on 29/04/25.
//

import SwiftUI

struct RunningView: View {
    @StateObject var runManager = LocationManager()
    @EnvironmentObject var runStore: RunStore
    @State private var showingSaveScreen = false
    @State private var completedRun: (duration: TimeInterval, distance: Double, averagePace: Double)? = nil

    var body: some View {
        ZStack {
            if runManager.isTracking {
                trackingView()
            } else {
                VStack (alignment: .leading){
                    Text("Running session")
                        .bold()
                        .font(.largeTitle)
                    
                    VStack {
                        MapViewWithRoute(coordinates: runManager.locations)
                            .ignoresSafeArea(edges: .horizontal)
                            .cornerRadius(10)

                        Button(action: {
                            runManager.startTracking()
                        }) {
                            Text("Start Run")
                                .font(.title3)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding()
                    }
                }
                .padding()
            }
        }
        .sheet(isPresented: $showingSaveScreen) {
            // Only show if we have completed run data
            if let runData = completedRun {
                SaveRunSessionsView(
                    duration: runData.duration,
                    distance: runData.distance,
                    averagePace: runData.averagePace,
                    coordinates: runManager.locations,
                    runStore: runStore
                )
            }
        }
    }
    
    private func trackingView() -> some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Time: \(formatTime(runManager.elapsedTime))")
                    Text("Distance: \(String(format: "%.2f", runManager.totalDistance / 1000)) km")
                    Text("Pace: \(formatPace(runManager.averagePace))")
                }
                .font(.largeTitle)
                .bold()
                .padding()
                Spacer()
            }
            .background(Color.white.opacity(0.7))
            
            Spacer()

            Button(action: {
                // Save run data before stopping tracking
                completedRun = (
                    duration: runManager.elapsedTime,
                    distance: runManager.totalDistance,
                    averagePace: runManager.averagePace
                )
                
                // Stop tracking
                runManager.stopTracking()
                
                // Show save screen
                showingSaveScreen = true
            }) {
                Text("Stop Run")
                    .font(.title3)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.bottom, 40)
        }
        .padding()
    }

    func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    func formatPace(_ pace: Double) -> String {
        guard pace.isFinite else { return "--:--" }
        let minutes = Int(pace) / 60
        let seconds = Int(pace) % 60
        return String(format: "%02d:%02d min/km", minutes, seconds)
    }
}

struct RunningView_Previews: PreviewProvider {
    static var previews: some View {
        RunningView()
    }
}
