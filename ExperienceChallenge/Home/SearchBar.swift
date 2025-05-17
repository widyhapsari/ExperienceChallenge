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
    @AppStorage("searchHistory") private var searchHistoryData: Data = Data()
    @State private var searchHistory: [String] = []


    @FocusState private var isSearchFocused: Bool
    
    private func loadSearchHistory() {
        if let decoded = try? JSONDecoder().decode([String].self, from: searchHistoryData) {
            searchHistory = decoded
        }
    }

    private func saveSearchHistory() {
        if let encoded = try? JSONEncoder().encode(searchHistory) {
            searchHistoryData = encoded
        }
    }

    private func updateSearchHistory(with term: String) {
        let trimmed = term.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }

        if let existingIndex = searchHistory.firstIndex(of: trimmed) {
            searchHistory.remove(at: existingIndex)
        }
        searchHistory.insert(trimmed, at: 0)

        if searchHistory.count > 10 {
            searchHistory.removeLast()
        }

        saveSearchHistory()
    }

    
    var filteredStops: [BusStop] {
        if searchText.isEmpty {
            return sortedBusStop
        } else {
            return sortedBusStop.filter {
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
                                updateSearchHistory(with: stop.name)
                                selectedStop = stop
                                isSearchFocused = false
                                isNavigating = true
                            }) {
                                HStack {
                                    HStack(spacing: 12) {
                                        Image(systemName: "mappin.circle.fill")
                                            .foregroundStyle(.secondary)
                                            .background(Circle().fill(Color.white))
                                        
                                        Text(stop.name)
                                            .foregroundColor(.primary)
                                            .frame(maxWidth: .infinity, maxHeight: 60, alignment: .leading)
                                    }
                                    Image(systemName: "chevron.right")
                                }
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
                        
                        
                        ForEach(searchHistory.compactMap { term in
                            sortedBusStop.first(where: { $0.name == term }).map { stop in
                                (term, stop)
                            }
                        }, id: \.0) { term, stop in
                            Button(action: {
                                selectedStop = stop
                                searchText = term
                                updateSearchHistory(with: term)
                                isSearchFocused = true
                                isNavigating = true
                            }) {
                                HStack {
                                    HStack(spacing: 12) {
                                        Image(systemName: "clock.fill")
                                            .foregroundStyle(.secondary)
                                            .background(Circle().fill(Color.white))
                                        Text(term)
                                            .foregroundStyle(.ecDarkLight)
                                            .frame(maxWidth: .infinity, maxHeight: 40, alignment: .leading)
                                    }
                                    Image(systemName: "chevron.right")
                                }
                            }
                            Divider()
                        }
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
            .onAppear {
                loadSearchHistory()
            }
            
        }
    }
}


#Preview {
    SearchBar()
}
