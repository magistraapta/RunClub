//
//  StatsView.swift
//  RunClub
//
//  Created by Magistra Apta on 29/04/25.
//

import SwiftUI

struct StatsView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("showing user running stats")
            }
        }
        .navigationTitle("Statistics")
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
    }
}
