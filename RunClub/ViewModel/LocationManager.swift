//
//  LocationManager.swift
//  RunClub
//
//  Created by Magistra Apta on 28/04/25.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    
    @Published var locations: [CLLocationCoordinate2D] = []
    @Published var elapsedTime: TimeInterval = 0
    @Published var totalDistance: Double = 0.0
    @Published var averagePace: Double = 0
    @Published var isTracking: Bool = false
    
    private var timer: Timer?
    private var lastLocation: CLLocation?
    
    
    
    override init(){
        super.init()
        locationManager.delegate = self
        locationManager.activityType = .fitness
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func startTracking() {
        locations = []
        elapsedTime = 0
        averagePace = 0
        totalDistance = 0.0
        lastLocation = nil
        isTracking = true
        locationManager.startUpdatingLocation()
        
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.elapsedTime += 1
            self.updatePace()
        })
    }
    
    func stopTracking() {
        isTracking = false
        locationManager.stopUpdatingLocation()
        timer?.invalidate()
    }
    
    func reset() {
        locations.removeAll()
        elapsedTime = 0
        totalDistance = 0
        averagePace = 0
    }
    
    private func updatePace(){
        guard totalDistance > 0 else {
            return
        }
        
        averagePace = elapsedTime / (totalDistance/1000)
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations newLocations: [CLLocation]) {
        guard isTracking else { return }
        
        for newLocation in newLocations {
            let coordinate = newLocation.coordinate
            locations.append(coordinate)
            
            if locations.count > 1 {
                let last = CLLocation(latitude: locations[locations.count  - 2].latitude, longitude: locations[locations.count - 2].longitude)
                let current = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                totalDistance += current.distance(from: last)
            }
        }
    }
}
