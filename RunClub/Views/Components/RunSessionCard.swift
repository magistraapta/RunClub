//
//  RunSessionCard.swift
//  RunClub
//
//  Created by Magistra Apta on 05/05/25.
//

import SwiftUI
import MapKit
struct RunSessionCard: View {
    var title: String
    var date: String
    var coordinate: [CLLocationCoordinate2D] = []
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
                    // Title section
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(date)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // Divider
            Divider()
                .padding(.vertical, 4)
            
            if !coordinate.isEmpty {
                MapViewWithRoute(coordinates: coordinate)
                    .frame(height: 200)
                    .cornerRadius(9)
            } else {
                Text("No route recorded")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.vertical)
            }
            
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

struct RunSessionCard_Previews: PreviewProvider {
    static var previews: some View {
        RunSessionCard(title: "easy run", date: "2024-04-05")
    }
}
