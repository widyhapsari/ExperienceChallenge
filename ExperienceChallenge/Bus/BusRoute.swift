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
            BusShelter()
        }
    }
}

#Preview {
    BusRoute()
}

struct BusShelter: View {
    var body: some View {
        HStack(spacing: 180) {
            HStack(spacing: 22) {
                ZStack {
                    Rectangle()
                        .fill(Color.ecTosca)
                        .padding(.top, 40)
                        .frame(width: 20, height: 80)
                    
                    Circle()
                        .stroke(style: StrokeStyle(lineWidth: 6))
                        .foregroundColor(.ecTosca)
                        .background((Color.white).opacity(1))
                        .frame(width: 14, height: 14)
                    
                }
                
                Text("Intermoda")
                    .font(.callout)
            }
            
            Text("11.40")
                .font(.callout)
                .padding(.trailing)
            
        }
    }
}
