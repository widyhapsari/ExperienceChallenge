//
//  HomeView.swift
//  ExperienceChallenge
//
//  Created by Rastya Widya Hapsari on 07/05/25.
//

import SwiftUI

struct HomeView: View {
    @State private var scanBus = false
    
    var body: some View {
            VStack(spacing: 26) {
                VStack(spacing: 0) {
                    Text("Where is your next stop?")
                        .scaledFont(size: 18, weight: .semibold)
                        .bold()
                    
                    
                    // Unified input section
                    SearchBar()
                    
                }
                
                
                
               
            }
            .padding(.top, 8)
        }
    
}

#Preview {
    HomeView()
}
