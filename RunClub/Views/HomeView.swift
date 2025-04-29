//
//  HomeView.swift
//  RunClub
//
//  Created by Magistra Apta on 28/04/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject var locationManager = LocationManager()
    var body: some View {
        VStack (alignment: .leading) {
            
            
            Text("RunClub")
                .font(.largeTitle)
                .bold()
            
            Spacer()
            
            VStack {
                RunningMapView(locationManager: locationManager)
//                    .edgesIgnoringSafeArea(.all)
//                    .frame(height: 600)
                    .ignoresSafeArea()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                
                Text(String(format: "Distance: %.2f meters", locationManager.totalDistance))
                                .padding()
                
                HStack (spacing: 8){
                    Button {
                        locationManager.startTracking()
                    } label: {
                        Text("Start Run")
                            .foregroundColor(.white)
                            .padding()
                            .background(locationManager.isTracking ? Color.gray : Color.green)
                            .cornerRadius(10)
                    }
                    .disabled(locationManager.isTracking)
                    
                    if locationManager.isTracking {
                        Button {
                            locationManager.stopTracking()
                        } label: {
                            Text("Stop Run")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(10)
                        }
                    }
                }
            }
            
            
            Spacer()
        }
        .padding()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
