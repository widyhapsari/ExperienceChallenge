//
//  HomeView.swift
//  ExperienceChallenge
//
//  Created by Rastya Widya Hapsari on 07/05/25.
//

import SwiftUI

extension LinearGradient {
    static let appPrimaryGradient = LinearGradient(
        colors: [Color(red: 1, green: 0.5, blue: 0.21), Color(red: 1, green: 0.33, blue: 0.33)],
        startPoint: .top,
        endPoint: .bottom
    )
}

struct HomeView: View {
    @State private var searchText = ""
    
    var filteredStops: [BusStop] {
        if searchText.isEmpty {
            return []
        } else {
            return allBusStops.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
                || $0.code.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 26) {
                VStack(spacing: 0) {
                    Text("Where is your next stop?")
                        .font(.title3)
                        .bold()
                    
                    
                    // Unified input section
                    HStack(alignment: .top, spacing: 12) {
                        // Icon column
                        VStack(spacing: 6) {
                            Image(systemName: "location.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 22, height: 22)
                                .foregroundColor(.ecBlue)
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
                            TextField("Next bus stop", text: $searchText)
                        }
                    }
                    .padding(12)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(18)
                    .shadow(color: Color.black.opacity(0.08), radius: 1, x: 2, y: 2)
                    .padding(.horizontal)
                    .padding(.top, 16)
                    
                    
                }
                
                //history
                VStack(alignment: .leading, spacing: 15) {
                    Text("Recent bus stop")
                        .font(.title3)
                        .bold()
                    
                    HStack(spacing: 12) {
                        Image(systemName: "clock.fill")
                            .foregroundStyle(.secondary)
                            .background(Circle().fill(Color.white))
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Studento")
                                .font(.headline)
                            
                            HStack(spacing: 12) {
                                Text("B 7266 JF")
                                    .font(.system(size: 14))
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color.ecBusLightGreen)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 7)
                                    .overlay(RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.ecBusLightGreen, lineWidth: 1))
                                
                                Text("B 7366 PAA")
                                    .font(.system(size: 14))
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color.ecBusPink)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 7)
                                    .overlay(RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.ecBusPink, lineWidth: 1))
                                
                                Text("B 7466 PAA")
                                    .font(.system(size: 14))
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color.ecBusLightGreen)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 7)
                                    .overlay(RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.ecBusLightGreen, lineWidth: 1))
                            }
                            
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(.horizontal, 15)
                .padding(.vertical, 15)
                //.background(Color(.secondarySystemBackground))
                
                //bus scanner button
                ZStack {
                    Circle()
                        .fill(LinearGradient.appPrimaryGradient)
                        .frame(width: 100, height: 100)
                        .shadow(color: .black.opacity(0.4), radius: 3.5, x: 3, y: 3)
                    
                    Image(systemName: "viewfinder")
                        .font(.system(size: 67))
                        .fontWeight(.light)
                        .foregroundColor(.white)
                    
                    Image(systemName: "bus")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                        .fontWeight(.light)
                }
                .padding(30)
            }
            .padding(.top, 8)
        }
    }
}

#Preview {
    HomeView()
}
