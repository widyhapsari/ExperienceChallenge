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
    let code: String
}

let allBusStops: [BusStop] = [
    .init(name: "Studento", code: "01"),
    .init(name: "Intermoda", code: "02"),
    .init(name: "Foresta", code: "03"),
    .init(name: "ICE", code: "04"),
]
