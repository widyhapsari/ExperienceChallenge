//
//  BusRoute.swift
//  ExperienceChallenge
//
//  Created by Rastya Widya Hapsari on 11/05/25.
//

import SwiftUI

struct BusRoute: View {
    var body: some View {
        VStack {
            BusShelter(shelter:"The Breeze", timeHour: 7, timeMinute: 20, interval: 0, edgeSet: .top, whiteCircleOpacity: 1)
        }
    }
}

#Preview {
    BusRoute()
}

struct BusShelter: View {
    var shelter: String
    var timeHour: Int
    var timeMinute: Int
    var interval: Int
    var edgeSet: Edge.Set
    var whiteCircleOpacity: Double
    
    var body: some View {
        HStack(spacing: 180) {
            HStack(spacing: 22) {
                ZStack {
                    Rectangle()
                        .fill(Color.ecTosca)
                        .padding(edgeSet, 40)
                        .frame(width: 20, height: 80)
                    
                    Circle()
                        .stroke(style: StrokeStyle(lineWidth: 6))
                        .foregroundColor(.ecTosca)
                        .background((Color.white).opacity(whiteCircleOpacity))
                        .frame(width: 14, height: 14)
                    
                }
                
                Text(shelter)
                    .font(.callout)
            }
            
            Text("\(timeHour + interval).\(timeMinute)")
                .font(.callout)
                .padding(.trailing)
            
        }
    }
}
