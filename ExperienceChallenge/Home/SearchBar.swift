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
    @State private var searchHistory: [String] = []

    @FocusState private var isSearchFocused: Bool
    
    // Load search history from UserDefaults when the view appears
       private func loadSearchHistory() {
           searchHistory = UserDefaults.standard.stringArray(forKey: "searchHistory") ?? []
       }
       
       // Save search text to history
       private func saveToHistory(_ text: String) {
           if !text.isEmpty && !searchHistory.contains(text) {
               searchHistory.insert(text, at: 0)
               
               // Limit history to 10 items
               if searchHistory.count > 10 {
                   searchHistory = Array(searchHistory.prefix(10))
               }
               
               // Save to UserDefaults for persistence
               UserDefaults.standard.set(searchHistory, forKey: "searchHistory")
           }
       }
    
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
                        
                        // Show search history
//                        if !searchHistory.isEmpty {
//                            VStack(alignment: .leading, spacing: 8) {
//                                HStack {
//                                    Text("Search History")
//                                        .font(.headline)
//                                }
//                                .padding(.horizontal)
//                                
//                                ScrollView {
//                                    LazyVStack(alignment: .leading) {
//                                        ForEach(searchHistory, id: \.self) { item in
//                                            Button(action: {
//                                                searchText = item
//                                                // Optionally perform search immediately
//                                            }) {
//                                                HStack {
//                                                    Image(systemName: "clock.arrow.circlepath")
//                                                        .foregroundColor(.gray)
//                                                    
//                                                    Text(item)
//                                                    
//                                                    Spacer()
//                                                    
//                                                    Button(action: {
//                                                        if let index = searchHistory.firstIndex(of: item) {
//                                                            searchHistory.remove(at: index)
//                                                            UserDefaults.standard.set(searchHistory, forKey: "searchHistory")
//                                                        }
//                                                    }) {
//                                                        Image(systemName: "xmark")
//                                                            .foregroundColor(.gray)
//                                                    }
//                                                }
//                                                .padding(.vertical, 8)
//                                                .padding(.horizontal)
//                                            }
//                                            .buttonStyle(PlainButtonStyle())
//                                            
//                                            Divider()
//                                                .padding(.leading)
//                                        }
//                                    }
//                                }
//                                .frame(maxHeight: 300)
//                            }
//                            .background(Color(.systemBackground))
//                            .cornerRadius(12)
//                            .shadow(radius: 2)
//                            .padding()
//                        }
                        
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
