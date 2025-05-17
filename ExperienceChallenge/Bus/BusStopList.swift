//
//  BusStopList.swift
//  ExperienceChallenge
//
//  Created by Rastya Widya Hapsari on 07/05/25.
//

import Foundation

struct BusStop: Identifiable, Equatable {
    let id: UUID
    let name: String

    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }
}

// Default list of bus stops
let allBusStops: [BusStop] = [
    BusStop(name: "Studento"),
    BusStop(name: "Intermoda"),
    BusStop(name: "Foresta"),
    BusStop(name: "ICE"),
    BusStop(name: "Naturale"),
    BusStop(name: "The Breeze")
]

let sortedBusStop = allBusStops.sorted { $0.name < $1.name }

// Optional: A default/fallback bus stop
let defaultStop = BusStop(name: "")
