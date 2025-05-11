//
//  SearchBarIsland.swift
//  ExperienceChallenge
//
//  Created by Rastya Widya Hapsari on 11/05/25.
//

import SwiftUI

enum SearchBarMode{
    case search
    case changeDestination
}

struct SearchBarIsland: View {
    @Binding var searchText: String
    @FocusState.Binding var isFocused: Bool
    var mode: SearchBarMode
    var onTap: (() -> Void)? = nil
    
    var body: some View {
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
                Text("The Breeze")
                Divider()
                VStack(alignment: .leading) {
                    TextField("Your destination", text: $searchText)
                        .focused($isFocused)
                        .disabled(mode == .changeDestination) // Make non-editable in CameraView
                        .contentShape(Rectangle()) // Ensure the full area is tappable
                            .onTapGesture {
                                if mode == .changeDestination {
                                    onTap?()
                                }
                            }
                }
            }
        }
        
        .padding(12)
        .background(backgroundColor)
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.08), radius: 1, x: 2, y: 2)
        .padding(.horizontal)
        .padding(.top, 16)
    }
        
    private var backgroundColor: Color {
            switch mode {
            case .search:
                return Color(.secondarySystemBackground)
            case .changeDestination:
                return Color(.ecDarkSearchBar) // Or any other color
            }
        }
}
