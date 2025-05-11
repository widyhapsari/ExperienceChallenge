//
//  BusScannerButton.swift
//  ExperienceChallenge
//
//  Created by Rastya Widya Hapsari on 10/05/25.
//

import SwiftUI

struct BusScannerButton: View {
    
    var body: some View {
        //bus scanner button
        NavigationLink(destination: CameraView(source: .scanner, stop: defaultStop)) {
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
            //.background(Color.red.opacity(0.3))
        }
    }
}

#Preview {
    BusScannerButton()
}
