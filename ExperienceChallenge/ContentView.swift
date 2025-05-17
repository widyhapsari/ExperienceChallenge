//
//  ContentView.swift
//  ExperienceChallenge
//
//  Created by Rastya Widya Hapsari on 07/05/25.
//

import SwiftUI

struct ContentView: View {
    @State private var keyboardIsVisible = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                HomeView()
                
                VStack {
                    Spacer()
                    BusScannerButton()
                        .padding(.bottom, 60)
                }
                .ignoresSafeArea(.keyboard)
            }
            // Add these modifiers to detect keyboard visibility
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
                keyboardIsVisible = true
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                keyboardIsVisible = false
            }
        }
    }
}

#Preview {
    ContentView()
}
