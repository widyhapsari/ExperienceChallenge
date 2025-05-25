//
//  SplashScreen.swift
//  ExperienceChallenge
//
//  Created by Rastya Widya Hapsari on 18/05/25.
//

import SwiftUI

struct SplashScreen: View {
    @State private var isActive = false
    @State private var logoScale: CGFloat = 0.5
    @State private var logoOpacity: Double = 0.0
    @State private var hasLaunchedBefore = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")

    
    var body: some View {
        if isActive {
            // Check if this is the first launch
            if hasLaunchedBefore {
                // Not first launch, go directly to HomeView
                ContentView()
            }
            else {
                // First launch, show tutorial
                TutorialView(onFinish: {
                    UserDefaults.standard.set(false, forKey: "hasLaunchedBefore")
                    hasLaunchedBefore = false
                })
            }
        } else {
            ZStack {
                LinearGradient.appPrimaryGradient
                    .ignoresSafeArea(edges: .all)
                
                Image("BLinkLogo")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 250, height: 250)
                    .cornerRadius(24)
                    //.scaleEffect(logoScale)
                    .opacity(logoOpacity)
                    .onAppear {
                        withAnimation(.easeOut(duration: 0.8)) {
                            //logoScale = 1.0
                            logoOpacity = 1.0
                        }
                        // Transition after animation
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            withAnimation {
                                self.isActive = true
                            }
                        }
                    }
            }
        }
    }
        
}


#Preview {
    SplashScreen()
}
