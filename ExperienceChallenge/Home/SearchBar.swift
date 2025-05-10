//
//  SearchBar.swift
//  ExperienceChallenge
//
//  Created by Rastya Widya Hapsari on 10/05/25.
//

import SwiftUI

struct SearchBar: View {
    @State private var searchText = ""
    @FocusState private var isSearchFocused: Bool
    
    var filteredStops: [BusStop] {
        if searchText.isEmpty {
            return allBusStops
        } else {
            return allBusStops.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
//                || $0.code.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 26) {
            HStack(alignment: .top, spacing: 12) {
                // Icon column
                VStack(spacing: 6) {
                    Image(systemName: "location.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 22)
                        .foregroundStyle(.ecBlue)
                        .background(Circle().fill(Color.white))
                    
                    VStack(spacing: 2) {
                        ForEach(0..<4) { _ in
                            Rectangle()
                                .fill(Color.black)
                                .frame(width: 2, height: 2)
                        }
                    }
                    
                    Image(systemName: "mappin.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 22)
                        .foregroundColor(.ecOrange)
                        .background(Circle().fill(Color.white))
                }
                VStack(alignment: .leading, spacing: 14) {
                    //current location
                    Text("The Breeze")
                    
                    Divider()
                    
                    //destination
                    VStack(alignment: .leading) {
                        TextField("Next bus stop", text: $searchText)
                            .focused($isSearchFocused)
                        
                    }
                }
            }
            .padding(12)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(18)
            .shadow(color: Color.black.opacity(0.08), radius: 1, x: 2, y: 2)
            .padding(.horizontal)
            .padding(.top, 16)
            
            // Display the suggestions
            if isSearchFocused || !searchText.isEmpty {
                VStack(alignment: .leading) {
                    ForEach(filteredStops) { stop in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(spacing: 12) {
                                Image(systemName: "clock.fill")
                                    .foregroundStyle(.secondary)
                                    .background(Circle().fill(Color.white))
                                
                                Text("\(stop.name)")
                            }
                            .padding(.vertical, 12)
                            Divider()
                            
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
                //.background(Color.red)
            }
            
            //history
            else {
                VStack(alignment: .leading, spacing: 15) {
                    Text("Recent bus stop")
                        .scaledFont(size: 18, weight: .semibold)
                        .bold()
                    
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 12) {
                            Image(systemName: "clock.fill")
                                .foregroundStyle(.secondary)
                                .background(Circle().fill(Color.white))
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Studento")
                            }
                        }
                    }
                    .padding(.vertical, 12)
                    Divider()
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(.horizontal, 15)
                .padding(.vertical, 15)
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        //.background(Color.blue)
    }
}

#Preview {
    SearchBar()
}
