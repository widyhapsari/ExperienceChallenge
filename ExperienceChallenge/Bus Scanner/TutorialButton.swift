//
//  TutorialButton.swift
//  ExperienceChallenge
//
//  Created by Rastya Widya Hapsari on 10/05/25.
//

import SwiftUI

struct TutorialButton: View {
    @State private var showTutorial = false
    
    var body: some View {
        HStack {
            Button(action: {
                showTutorial = true
            }) {
                Image(systemName: "questionmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(.white)
                    .background(Circle().fill(Color.black))
            }
            .padding(.leading, 156)
            //.background(Color.red)
        }
            .fullScreenCover(isPresented: $showTutorial) {
                TutorialView()
            }
    }
}

#Preview {
    TutorialButton()
}
