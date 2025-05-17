//
//  Functions.swift
//  ExperienceChallenge
//
//  Created by Rastya Widya Hapsari on 16/05/25.
//

import SwiftUI

func shelterData(for routeCode: String) -> [ShelterData] {
    switch routeCode.uppercased() {
    case "GS":
        return GreenwichPark_Sektor13
    case "BC":
        return TheBreeze_ICE
    case "ID1":
        return Intermoda_DePark1
    case "ID2":
        return Intermoda_DePark2
    case "EC":
        return Intermoda_CBD
    case "IS":
        return Intermoda_Sektor13
    case "IV":
        return Intermoda_VanyaPark
    default:
        return [] // or return a default route if needed
    }
}

func colorForRoute(_ routeCode: String) -> Color {
    switch routeCode.uppercased() {
    case "BC":
        return .ECBC // The Breeze - ICE
    case "GS":
        return .ECGS // Greenwich Park
    case "ID1":
        return .ECID_1
    case "ID2":
        return .ECID_2
    case "EC":
        return .ECEC
    case "IS":
        return .ECIS
    case "IV":
        return .ECIV
    default:
        return .gray
    }
}
