//
//  RunSessionModel.swift
//  RunClub
//
//  Created by Magistra Apta on 29/04/25.
//

import Foundation
import CoreLocation


struct RunSession: Identifiable, Codable {
    var id = UUID()
    let date: Date
    let duration: TimeInterval
    let distance: Double
    let averagePace: Double
    let route: [Coordinate]
}

struct Coordinate: Codable {
    let longitude: Double
    let latitude: Double
    
    init(coordinate: CLLocationCoordinate2D) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
    }
    
    var cllocationCoordinate2D: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
