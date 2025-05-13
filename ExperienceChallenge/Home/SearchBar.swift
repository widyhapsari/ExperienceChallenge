//
//  SearchBar.swift
//  ExperienceChallenge
//
//  Created by Rastya Widya Hapsari on 10/05/25.
//

import SwiftUI

struct SearchBar: View {
    @State private var searchText = ""
    @State private var selectedStop: BusStop? = nil
    @State private var isNavigating = false

    @FocusState private var isSearchFocused: Bool
    
    var filteredStops: [BusStop] {
        if searchText.isEmpty {
            return allBusStops
        } else {
            return allBusStops.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 26) {
                //search bar island
                SearchBarIsland (
                                    searchText: $searchText,
                                    isFocused: $isSearchFocused,
                                    mode: .search
                                )
                
                if isSearchFocused || !searchText.isEmpty {
                    VStack(alignment: .leading) {
                        ForEach(filteredStops) { stop in
                            Button(action: {
                                searchText = stop.name
                                selectedStop = stop
                                isSearchFocused = false
                                isNavigating = true
                            }) {
                                HStack(spacing: 12) {
                                    Image(systemName: "mappin.circle.fill")
                                        .foregroundStyle(.secondary)
                                        .background(Circle().fill(Color.white))
                                    
                                    Text(stop.name)
                                        .foregroundColor(.primary)
                                }
                                .padding(.vertical, 12)
                            }
                            Divider()
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                } else {
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
                    .padding(.horizontal, 15)
                    .padding(.vertical, 15)
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            
            // NavigationLink
            .navigationDestination(isPresented: $isNavigating) {
                if let stop = selectedStop {
                    CameraView(source: .home, stop: stop)
                }
            }

            
        }
    }
}


#Preview {
    SearchBar()
}
