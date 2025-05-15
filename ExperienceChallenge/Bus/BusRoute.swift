//
//  BusRoute.swift
//  ExperienceChallenge
//
//  Created by Rastya Widya Hapsari on 11/05/25.
//

import SwiftUI

func shelterData(for routeCode: String) -> [ShelterData] {
    switch routeCode.uppercased() {
    case "GS":
        return GreenwichPark_Sektor13
    case "BC":
        return TheBreeze_ICE
    case "ID2":
        return Intermoda_DePark2
    case "EC":
        return Intermoda_CBD
    default:
        return [] // or return a default route if needed
    }
}


struct ShelterData {
    let shelter: String
    let interval: Int
}

let TheBreeze_ICE: [ShelterData] = [
    .init(shelter: "The Breeze", interval: 0),
    .init(shelter: "CBD Timur 1", interval: 3),
    .init(shelter: "Lobby AEON Mall", interval: 8),
    .init(shelter: "AEON Mall 2", interval:11),
    .init(shelter: "CBD Utara 3", interval:13),
    .init(shelter: "ICE 1", interval:16),
    .init(shelter: "ICE 2", interval:18),
    .init(shelter: "ICE Business Park", interval:20),
    .init(shelter: "ICE 6", interval:21),
    .init(shelter: "ICE 5", interval:22),
    .init(shelter: "CBD Barat 1", interval:25),
    .init(shelter: "CBD Barat 2", interval:26),
    .init(shelter: "Lobby AEON Mall", interval:29),
    .init(shelter: "AEON Mall 2", interval:32),
    .init(shelter: "GOP 2", interval:35),
    .init(shelter: "Nava Park 1", interval:37),
    .init(shelter: "Green Cove", interval:39)
]

let GreenwichPark_Sektor13: [ShelterData] = [
    .init(shelter: "Greenwich Park Office", interval: 0),
    .init(shelter: "Jadeite 2", interval: 4),
    .init(shelter: "De Maja", interval: 7),
    .init(shelter: "De Heliconia 2", interval: 8),
    .init(shelter: "De Nara", interval: 9),
    .init(shelter: "De Park 2", interval: 12),
    .init(shelter: "Giardina", interval: 16),
    .init(shelter: "Collinare", interval: 18),
    .init(shelter: "Foglio", interval: 20),
    .init(shelter: "Studento 2", interval: 21),
    .init(shelter: "Albera", interval: 23),
    .init(shelter: "Foresta 1", interval: 24),
    .init(shelter: "GOP 1", interval: 27),
    .init(shelter: "SML Plaza", interval: 30),
    .init(shelter: "The Breeze", interval: 32),
    .init(shelter: "CBD Timur 1", interval: 35),
    .init(shelter: "GOP 2", interval: 36),
    .init(shelter: "Nava Park 1", interval: 38),
    .init(shelter: "SWA 2", interval: 41),
    .init(shelter: "BSD City 1", interval: 43),
    .init(shelter: "Eka Hospital 1", interval: 45),
    .init(shelter: "Puspita Loka", interval: 48),
    .init(shelter: "Polsek Serpong", interval: 51),
    .init(shelter: "Ruko Madrid", interval: 53),
    .init(shelter: "Pasar Modern Timur", interval: 55),
    .init(shelter: "Griyaloka 1", interval: 57),
    .init(shelter: "Sektor 1.3", interval: 60)
]

let Intermoda_DePark2: [ShelterData] = [
    .init(shelter: "Terminal Intermoda", interval: 0),
    .init(shelter: "Icon Centro", interval: 3),
    .init(shelter: "Horizon Broadway", interval: 5),
    .init(shelter: "Extreme Park", interval: 7),
    .init(shelter: "Saveria", interval: 8),
    .init(shelter: "Casa De Parco 1", interval: 9),
    .init(shelter: "SML Plaza", interval: 12),
    .init(shelter: "The Breeze", interval: 14),
    .init(shelter: "CBD Timur 1", interval: 17),
    .init(shelter: "AEON Mall 1", interval: 20),
    .init(shelter: "AEON Mall 2", interval: 22),
    .init(shelter: "GOP 2", interval: 25),
    .init(shelter: "Simpang Foresta", interval: 27),
    .init(shelter: "Allevare", interval: 28),
    .init(shelter: "Flore", interval: 29),
    .init(shelter: "Studento 1", interval: 31),
    .init(shelter: "Naturale", interval: 32),
    .init(shelter: "Fresco", interval: 34),
    .init(shelter: "Primavera", interval: 36),
    .init(shelter: "Foresta 2", interval: 37),
    .init(shelter: "De Park 1", interval: 39),
    .init(shelter: "De Frangipangi", interval: 42),
    .init(shelter: "De Heliconia 1", interval: 43),
    .init(shelter: "De Brassia", interval: 44),
    .init(shelter: "Jadeite 1", interval: 46),
    .init(shelter: "Greenwich Park 2", interval: 48),
    .init(shelter: "Qbig 2", interval: 49),
    .init(shelter: "Qbig 3", interval: 50),
    .init(shelter: "BCA Foresta", interval: 52),
    .init(shelter: "FBL 2", interval: 53),
    .init(shelter: "FBL 1", interval: 54),
    .init(shelter: "ICE 1", interval: 57),
    .init(shelter: "ICE 2", interval: 58),
    .init(shelter: "ICE Business Park", interval: 60),
    .init(shelter: "ICE 6", interval: 61),
    .init(shelter: "ICE 5", interval: 62),
    .init(shelter: "CBD Barat 1", interval: 65),
    .init(shelter: "CBD Barat 2", interval: 66),
    .init(shelter: "Simplicity 1", interval: 68),
    .init(shelter: "Terminal Intermoda", interval: 72)
]

let Intermoda_CBD: [ShelterData] = [
    .init(shelter: "Terminal Intermoda", interval: 0),
    .init(shelter: "Simplicity 2", interval: 3),
    .init(shelter: "Halte Edutown | BSD Link", interval: 5),
    .init(shelter: "Edutown 2", interval: 6),
    .init(shelter: "ICE 1", interval: 8),
    .init(shelter: "ICE 2", interval: 10),
    .init(shelter: "ICE Business Park", interval: 11),
    .init(shelter: "ICE 6", interval: 12),
    .init(shelter: "ICE 5", interval: 13),
    .init(shelter: "Froogy", interval: 15),
    .init(shelter: "Gramedia", interval: 17),
    .init(shelter: "Astra", interval: 18),
    .init(shelter: "Courts Mega Store", interval: 20),
    .init(shelter: "QBig 1", interval: 21),
    .init(shelter: "Lulu", interval: 22),
    .init(shelter: "QBig 2", interval: 23),
    .init(shelter: "BCA Foresta", interval: 26),
    .init(shelter: "FBL 2", interval: 27),
    .init(shelter: "FBL 1", interval: 28),
    .init(shelter: "GOP 1", interval: 36),
    .init(shelter: "SML Plaza", interval: 38),
    .init(shelter: "The Breeze", interval: 40),
    .init(shelter: "Casa De Parco 2", interval: 42),
    .init(shelter: "Digital Hub 1", interval: 43),
    .init(shelter: "Saveria", interval: 44),
    .init(shelter: "Casa De Parco 1", interval: 45),
    .init(shelter: "CBD Timur 1", interval: 46),
    .init(shelter: "CBD Selatan", interval: 47),
    .init(shelter: "AEON Mall 1", interval: 49),
    .init(shelter: "AEON Mall 2", interval: 51),
    .init(shelter: "CBD Utara 3", interval: 53),
    .init(shelter: "CBD Barat 1", interval: 54),
    .init(shelter: "CBD Barat 2", interval: 55),
    .init(shelter: "Simplicity 1", interval: 57),
    .init(shelter: "Terminal Intermoda", interval: 61)
]

          
          
struct BusRoute: View {
    let timeHour = 11
    let timeMinute = 0
    let stops: [ShelterData]

    var body: some View {
        VStack(spacing: -20) {
            ForEach(Array(stops.enumerated()), id: \.offset) { index, stop in
                BusShelter(
                    shelter: stop.shelter,
                    timeHour: timeHour,
                    timeMinute: timeMinute,
                    interval: stop.interval,
                    isFirst: index == 0,
                    isLast: index == stops.count - 1,
                    circleSize: (index == 0 || index == stops.count - 1) ? 3 : 4,
                    whiteCircleOpacity: (index == 0 || index == stops.count - 1) ? 1 : 0.6
                )
            }
        }
        .padding()
    }
}



#Preview {
    BusRoute(stops: TheBreeze_ICE)
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
