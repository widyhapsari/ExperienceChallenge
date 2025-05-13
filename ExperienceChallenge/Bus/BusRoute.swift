//
//  BusRoute.swift
//  ExperienceChallenge
//
//  Created by Rastya Widya Hapsari on 11/05/25.
//

import SwiftUI

struct BusRoute: View {
    var body: some View {
        VStack(spacing: -20) {
            BusShelter(
                shelter: "The Breeze",
                timeHour: 11,
                timeMinute: 00,
                interval: 0,
                isFirst: true,
                isLast: false,
                circleSize: 3,
                whiteCircleOpacity: 1
            )
            
            BusShelter(
                shelter: "CBD Timur 1",
                timeHour: 11,
                timeMinute: 00,
                interval: 3,
                isFirst: false,
                isLast: false,
                circleSize: 4,
                whiteCircleOpacity: 0.6
            )
            
            BusShelter(
                shelter: "Lobby AEON Mall",
                timeHour: 11,
                timeMinute: 00,
                interval: 8,
                isFirst: false,
                isLast: false,
                circleSize: 4,
                whiteCircleOpacity: 0.6
            )
            
            BusShelter(
                shelter: "AEON Mall 2",
                timeHour: 11,
                timeMinute: 00,
                interval: 11,
                isFirst: false,
                isLast: false,
                circleSize: 4,
                whiteCircleOpacity: 0.6
            )
            
            BusShelter(
                shelter: "CBD Utara 3",
                timeHour: 11,
                timeMinute: 00,
                interval: 13,
                isFirst: false,
                isLast: false,
                circleSize: 4,
                whiteCircleOpacity: 0.6
            )
            
            BusShelter(
                shelter: "ICE 1",
                timeHour: 11,
                timeMinute: 00,
                interval: 16,
                isFirst: false,
                isLast: false,
                circleSize: 4,
                whiteCircleOpacity: 0.6
            )
            
            BusShelter(
                shelter: "ICE 2",
                timeHour: 11,
                timeMinute: 00,
                interval: 18,
                isFirst: false,
                isLast: false,
                circleSize: 4,
                whiteCircleOpacity: 0.6
            )
            
            BusShelter(
                shelter: "ICE Business Park",
                timeHour: 11,
                timeMinute: 00,
                interval: 20,
                isFirst: false,
                isLast: false,
                circleSize: 4,
                whiteCircleOpacity: 0.6
            )
            
            BusShelter(
                shelter: "ICE 6",
                timeHour: 11,
                timeMinute: 00,
                interval: 21,
                isFirst: false,
                isLast: false,
                circleSize: 4,
                whiteCircleOpacity: 0.6
            )
            
            BusShelter(
                shelter: "ICE 5",
                timeHour: 11,
                timeMinute: 00,
                interval: 22,
                isFirst: false,
                isLast: false,
                circleSize: 4,
                whiteCircleOpacity: 0.6
            )
            
            BusShelter(
                shelter: "CBD Barat 1",
                timeHour: 11,
                timeMinute: 00,
                interval: 25,
                isFirst: false,
                isLast: false,
                circleSize: 4,
                whiteCircleOpacity: 0.6
            )
            
            BusShelter(
                shelter: "CBD Barat 2",
                timeHour: 11,
                timeMinute: 00,
                interval: 26,
                isFirst: false,
                isLast: false,
                circleSize: 4,
                whiteCircleOpacity: 0.6
            )
            
            BusShelter(
                shelter: "Lobby AEON Mall",
                timeHour: 11,
                timeMinute: 00,
                interval: 29,
                isFirst: false,
                isLast: false,
                circleSize: 4,
                whiteCircleOpacity: 0.6
            )
            
            BusShelter(
                shelter: "AEON Mall 2",
                timeHour: 11,
                timeMinute: 00,
                interval: 32,
                isFirst: false,
                isLast: false,
                circleSize: 4,
                whiteCircleOpacity: 0.6
            )
            
            BusShelter(
                shelter: "GOP 2",
                timeHour: 11,
                timeMinute: 00,
                interval: 35,
                isFirst: false,
                isLast: false,
                circleSize: 4,
                whiteCircleOpacity: 0.6
            )
            
            BusShelter(
                shelter: "Nava Park 1",
                timeHour: 11,
                timeMinute: 00,
                interval: 37,
                isFirst: false,
                isLast: false,
                circleSize: 4,
                whiteCircleOpacity: 0.6
            )
            
            BusShelter(
                shelter: "Green Cove",
                timeHour: 11,
                timeMinute: 00,
                interval: 39,
                isFirst: false,
                isLast: true,
                circleSize: 3,
                whiteCircleOpacity: 1
            )
        }
        .padding()
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
    var isFirst: Bool
    var isLast: Bool
    var circleSize: Int
    var whiteCircleOpacity: Double

    private var totalMinutes: Int {
        timeMinute + interval
    }

    private var formattedTime: String {
        let hours = timeHour + (totalMinutes / 60)
        let minutes = totalMinutes % 60
        return String(format: "%02d:%02d", hours, minutes)
    }

    var body: some View {
        HStack {
            ZStack {
                Rectangle()
                    .fill(Color.ecPurple)
                    .frame(width: 14)
                    .padding(.top, isFirst ? 40 : 0)
                    .padding(.bottom, isLast ? 40 : 0)

                Circle()
                    .strokeBorder(Color.ecPurple, lineWidth: CGFloat(circleSize))
                    .background(Circle().fill(Color.white.opacity(whiteCircleOpacity)))
                    .frame(width: 14, height: 14)
            }
            .frame(width: 20, height: 80)
            
            Text(shelter)
                .font(.callout)

            Spacer()

            Text(formattedTime)
                .font(.system(.callout, design: .monospaced))
                .padding(.trailing)
        }
    }
}
