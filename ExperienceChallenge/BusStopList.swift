//
//  BusStopList.swift
//  ExperienceChallenge
//
//  Created by Rastya Widya Hapsari on 07/05/25.
//

import Foundation

struct BusStop: Identifiable {
    let id = UUID()
    let name: String
}

let allBusStops: [BusStop] = [
    .init(name: "Studento"),
    .init(name: "Intermoda"),
    .init(name: "Foresta"),
    .init(name: "ICE"),
]
