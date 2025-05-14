//
//  PlateNumberList.swift
//  ExperienceChallenge
//
//  Created by Rastya Widya Hapsari on 13/05/25.
//

import Foundation

struct BusInfo: Identifiable, Hashable {
    let id: UUID
    let plateNumber: String
    let routeCode: String
    let routeName: String

    init(id: UUID = UUID(), plateNumber: String, routeCode: String, routeName: String) {
        self.id = id
        self.plateNumber = plateNumber
        self.routeCode = routeCode
        self.routeName = routeName
        
    }
}

// Default list of bus stops
let allBusInfo: [BusInfo] = [
    BusInfo(plateNumber: "B 7566 PAA", routeCode: "GS", routeName: "Greenwich - Sektor 1.3 Loop Line"),
    BusInfo(plateNumber: "B 7266 JF", routeCode: "GS", routeName: "Greenwich - Sektor 1.3 Loop Line"),
    BusInfo(plateNumber: "B 7466 PAA", routeCode: "GS", routeName: "Greenwich - Sektor 1.3 Loop Line"),
    BusInfo(plateNumber: "B 7366 JE", routeCode: "ID1", routeName: "Intermoda - De Park 1"),
    BusInfo(plateNumber: "B 7366 PAA", routeCode: "ID2", routeName: "Intermoda - De Park 2"),
    BusInfo(plateNumber: "B 7866 PAA", routeCode: "ID2", routeName: "Intermoda - De Park 2"),
    BusInfo(plateNumber: "B 7666 PAA", routeCode: "IS", routeName: "Intermoda - Halte Sektor 1.3"),
    BusInfo(plateNumber: "B 7966 PAA", routeCode: "IS", routeName: "Intermoda - Halte Sektor 1.3"),
    BusInfo(plateNumber: "B 7002 PGX", routeCode: "EC", routeName: "Electric Line | Intermoda - ICE - QBIG - Ara Rasa - The Breeze - Digital Hub - AEON Mall Loop Line"),
    BusInfo(plateNumber: "B 7166 PAA", routeCode: "BC", routeName: "The Breeze - AEON - ICE - The Breeze Loop Line"),
    BusInfo(plateNumber: "B 7866 PAA", routeCode: "BC", routeName: "The Breeze - AEON - ICE - The Breeze Loop Line"),
    BusInfo(plateNumber: "B 7766 PAA", routeCode: "IV", routeName: "Intermoda - Vanya")
]

let sortedPlateNumber = allBusInfo.sorted { $0.plateNumber < $1.plateNumber }

// Optional: A default/fallback bus stop
let defaultBusInfo = BusInfo(plateNumber: "B7166PAA", routeCode: "BC", routeName: "The Breeze - AEON - ICE - The Breeze Loop Line")
