//
//  ContentView.swift
//  ExperienceChallenge
//
//  Created by Rastya Widya Hapsari on 07/05/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                HomeView()
                
                VStack {
                    Spacer()
                    BusScannerButton()
                        .padding(.bottom, 60)
                }
            }
            //.background(Color.blue)
        }
    }
}

#Preview {
    ContentView()
}
