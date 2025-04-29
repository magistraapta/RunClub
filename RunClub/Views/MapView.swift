//
//  MapView.swift
//  RunClub
//
//  Created by Magistra Apta on 28/04/25.
//

import SwiftUI
import MapKit

struct RunningMapView: UIViewRepresentable {
    @ObservedObject var locationManager: LocationManager
    
    let mapView = MKMapView()
    
    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeOverlays(uiView.overlays)
        
        let polyline = MKPolyline(coordinates: locationManager.locations, count: locationManager.locations.count)
        uiView.addOverlay(polyline)
        
        if let last = locationManager.locations.last {
            let region = MKCoordinateRegion(center: last, latitudinalMeters: 500, longitudinalMeters: 500)
            uiView.setRegion(region, animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
            Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: RunningMapView
        
        init(_ parent: RunningMapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .systemOrange
                renderer.lineWidth = 5
                return renderer
            }
            return MKOverlayRenderer()
        }
        
    }
}

