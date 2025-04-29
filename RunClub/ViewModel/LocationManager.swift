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
    @Published var totalDistance: Double = 0.0
    
    private var lastLocation: CLLocation?
    
    @Published var isTracking: Bool = false
    
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
        totalDistance = 0.0
        lastLocation = nil
        isTracking = true
        locationManager.startUpdatingLocation()
    }
    
    func stopTracking() {
        isTracking = false
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations newLocations: [CLLocation]) {
        for newLocation in newLocations {
            let coordinate = newLocation.coordinate
            locations.append(coordinate)
            
            
            if let last = lastLocation {
                let distance = newLocation.distance(from: last)
                totalDistance += distance
            }
            lastLocation = newLocation
        }
    }
}
