//
//  SaveRunSessionsView.swift
//  RunClub
//
//  Created by Magistra Apta on 05/05/25.
//

import SwiftUI
import MapKit

struct SaveRunSessionsView: View {
    let duration: TimeInterval
    let distance: Double
    let averagePace: Double
    let coordinates: [CLLocationCoordinate2D]
    
    // New data for the form
    @State private var sessionTitle: String = ""
    @State private var notes: String = ""
    @State private var showingSuccessAlert = false
    @Environment(\.dismiss) private var dismiss
    
    // Access to the data store
    @ObservedObject var runStore: RunStore
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack (alignment: .leading, spacing: 20) {
                    MapViewWithRoute(coordinates: coordinates)
                        .frame(height: 200)
                        .cornerRadius(12)
                        .padding(.horizontal)
                    
                    RunSummaryCard(duration: duration, distance: distance, averagePace: averagePace)
                        .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Run Title")
                            .font(.headline)
                        
                        TextField("Morning Run, Evening Jog, etc.", text: $sessionTitle)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notes (Optional)")
                            .font(.headline)
                        
                        TextEditor(text: $notes)
                            .frame(height: 100)
                            .padding(4)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    
                    Button(action: saveSession) {
                        Text("Save Run")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    Spacer()
                }
                .padding(.vertical)
            }
            .navigationTitle("Save Your Run")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Run Saved Successfully", isPresented: $showingSuccessAlert) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("Your run has been saved.")
            }
        }
    }
    private func saveSession() {
        // Convert coordinates to Coordinate model
        let routeCoordinates = coordinates.map { Coordinate(coordinate: $0) }
        
        // Create new run session
        let title = sessionTitle.isEmpty ? generateDefaultTitle() : sessionTitle
        let newSession = RunSession(
            id: UUID(),
            title: title,
            date: Date(),
            duration: duration,
            distance: distance,
            averagePace: averagePace,
            route: routeCoordinates,
            notes: notes
        )
        
        // Save to store
        runStore.saveRun(run: newSession)
        
        // Show success alert
        showingSuccessAlert = true
    }
    
    private func generateDefaultTitle() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, h:mm a"
        return "Run on \(dateFormatter.string(from: Date()))"
    }
    
}

struct RunSummaryCard: View {
    let duration: TimeInterval
    let distance: Double
    let averagePace: Double
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Run Summary")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 20) {
                StatItem(
                    value: formatDuration(duration),
                    label: "Duration"
                )
                
                Divider()
                    .frame(width: 1, height: 40)
                
                StatItem(
                    value: String(format: "%.2f km", distance / 1000),
                    label: "Distance"
                )
                
                Divider()
                    .frame(width: 1, height: 40)
                
                StatItem(
                    value: formatPace(averagePace),
                    label: "Avg Pace"
                )
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private func formatDuration(_ seconds: TimeInterval) -> String {
        let hours = Int(seconds) / 3600
        let minutes = (Int(seconds) % 3600) / 60
        let seconds = Int(seconds) % 60
        
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
    
    private func formatPace(_ pace: Double) -> String {
        let minutes = Int(pace) / 60
        let seconds = Int(pace) % 60
        return String(format: "%d:%02d /km", minutes, seconds)
    }
}

struct StatItem: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title3)
                .fontWeight(.semibold)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct SaveRunSessionsView_Previews: PreviewProvider {
    static var previews: some View {
        SaveRunSessionsView(
            duration: 1200, // 20 minutes
            distance: 3500, // 3.5 km
            averagePace: 342, // 5:42 min/km
            coordinates: [
                CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
                CLLocationCoordinate2D(latitude: 37.7750, longitude: -122.4195),
                CLLocationCoordinate2D(latitude: 37.7751, longitude: -122.4196)
            ],
            runStore: RunStore()
        )
    }
}
