//
//  RunStore.swift
//  RunClub
//
//  Created by Magistra Apta on 05/05/25.
//

import Foundation

class RunStore: ObservableObject {
    @Published var runSessions: [RunSession] = []
    
    private let saveKey = "savedRuns"
    
    init() {
        loadRuns()
    }
    
    func saveRun( run: RunSession) {
        runSessions.append(run)
        saveToDisk()
    }
    
    private func saveToDisk() {
        if let encoded = try? JSONEncoder().encode(runSessions) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    func loadRuns() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([RunSession].self, from: data) {
            runSessions = decoded
        }
    }
    
    
}
