//
//  ResultView.swift
//  ExperienceChallenge
//
//  Created by Rastya Widya Hapsari on 11/05/25.
//

import SwiftUI

struct ResultView: View {
    @State private var hasScrolled = false
    @State private var isSearchBarActive: Bool = false
    @State private var scrollOffset: CGFloat = 0
    @Environment(\.dismiss) var dismiss
    let source: CameraViewSource
    let showResultCard: Bool
    let busInfo: BusInfo
    let searchText: String
    
    var body: some View {
        let routeStops = shelterData(for: busInfo.routeCode)
        let lineColor = colorForRoute(busInfo.routeCode)
        
        // Find The Breeze index
        let breezeIndex = routeStops.firstIndex {
            $0.shelter.localizedCaseInsensitiveContains("The Breeze")
        }
        
        // Find the earliest search text match that appears after The Breeze
        let earliestDestinationIndex: Int? = if let bIndex = breezeIndex {
            // Look for the first match after The Breeze
            routeStops.indices.drop(while: { $0 <= bIndex }).first {
                routeStops[$0].shelter.localizedCaseInsensitiveContains(searchText)
            }
        } else {
            // If The Breeze isn't found, don't highlight any destination
            nil
        }
        
        VStack {
            if source == .home {
                RightorWrong(isGoingToDestination: earliestDestinationIndex != nil)
                    .padding(24)
            }
            
            VStack(spacing: 12) {
                // Plate number
                Text(busInfo.plateNumber)
                    .scaledFont(size: 14)
                    .fontWeight(.semibold)
                    .foregroundColor(lineColor)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .overlay(RoundedRectangle(cornerRadius: 8)
                        .stroke(lineColor, lineWidth: 1))
                
                // Jurusan bus
                Text(busInfo.routeName)
                    .font(.title3)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
            }
            .padding(.bottom, 24)
            
            // Bus route ScrollView with shadow overlay
            ZStack(alignment: .top) {
                ScrollView {
                    GeometryReader { geo in
                        Color.clear
                            .preference(key: ScrollOffsetKey.self, value: geo.frame(in: .named("scroll")).minY)
                            .frame(height: 0)
                    }
                    
                    BusRoute(
                        stops: routeStops,
                        breezeIndex: breezeIndex,
                        highlightDestinationIndex: earliestDestinationIndex,
                        searchText: searchText, lineColor: lineColor
                    )
                   // .padding(.top, 10)
                }
                .coordinateSpace(name: "scroll")
                .onPreferenceChange(ScrollOffsetKey.self) { offset in
                    scrollOffset = offset
                    hasScrolled = offset < 0
                }
                
                // Top shadow overlay
                VStack {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    .black.opacity(0.25),
                                    .clear
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(height: 8)
                    Spacer()
                }
                .opacity(scrollOffset < -10 ? 1 : 0)
                .animation(.easeInOut(duration: 0.2), value: scrollOffset)
                .allowsHitTesting(false) // So it doesn't interfere with scrolling
            }
        }
        .padding(.top, 8)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.blue)
                    Text("Back")
                        .foregroundColor(.blue)
                        .font(.title3)
                }
            }
        }
    }
}

struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}


#Preview {
    ResultView(
            source: .home,
            showResultCard: true,
            busInfo: BusInfo(
                plateNumber: "B 1234 XYZ",
                routeCode: "BC",
                routeName: "The Breeze - AEON - ICE - The Breeze"
            ), searchText: "Studento"
        )
}
