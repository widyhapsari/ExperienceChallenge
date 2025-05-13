//
//  SearchPlateManually.swift
//  ExperienceChallenge
//
//  Created by Rastya Widya Hapsari on 13/05/25.
//

import SwiftUI


struct SearchPlateManually: View {
    @State var searchPlate = ""
    @State private var selectedPlateNumber: BusInfo? = nil
    let columns = [GridItem(.adaptive(minimum: 100))]
    
    var filteredPlates: [BusInfo] {
        if searchPlate.isEmpty {
            return sortedPlateNumber
        } else {
            return sortedPlateNumber.filter {
                $0.plateNumber.localizedCaseInsensitiveContains(searchPlate)
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Enter Bus Plate Manually")
                .scaledFont(size: 16, weight: .medium)
            
            TextField("Ex: B 7366 PAA", text: $searchPlate)
                .multilineTextAlignment(.center)
                .frame(width: 350, height: 40)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(filteredPlates) { plate in
                    Text(plate.plateNumber)
                        .scaledFont(size: 12, weight: .semibold)
                        .foregroundColor(Color.ecBusPink)
                        .frame(width: 100, height: 28)
                        .overlay(RoundedRectangle(cornerRadius: 8)
                           .stroke(Color.ecBusPink, lineWidth: 1))
                }
            }
            .frame(width: 350)
            //.background(Color(.red))
        }
        Spacer()
    }
}

#Preview {
    SearchPlateManually()
}
