//
//  ResultView.swift
//  ExperienceChallenge
//
//  Created by Rastya Widya Hapsari on 11/05/25.
//

import SwiftUI

struct ResultView: View {
    @State private var hasScrolled = false
    
    var body: some View {
        VStack {
            // Plate number
            Text("B 7866 PAA")
                .scaledFont(size: 14)
                .fontWeight(.semibold)
                .foregroundColor(Color.ecPurple)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .overlay(RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.ecPurple, lineWidth: 1))
            
            // Jurusan bus
            Text("The Breeze - AEON - ICE - The Breeze")
                .font(.title3)
                .fontWeight(.medium)
            
            // Bus route ScrollView
            ScrollView {
                GeometryReader { geo in
                    Color.clear
                        .preference(key: ScrollOffsetKey.self, value: geo.frame(in: .named("scroll")).minY)
                }
                .frame(height: 0)
                
                BusRoute()
            }
            .coordinateSpace(name: "scroll")
            .onPreferenceChange(ScrollOffsetKey.self) { offset in
                hasScrolled = offset < -5
            }
            .overlay(
                // Top shadow overlay
                VStack {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    .black.opacity(hasScrolled ? 0.8 : 0),
                                    .black.opacity(hasScrolled ? 0.8 : 0)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(height: 4)
                    Spacer()
                }
                .animation(.easeInOut(duration: 0.2), value: hasScrolled)
                .allowsHitTesting(false), // Ensures the overlay doesn't interfere with scrolling
                alignment: .top
            )
        }
        .padding(.top, 8)
    }
}

private struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    ResultView()
}
