//
//  TutorialView.swift
//  ExperienceChallenge
//
//  Created by Rastya Widya Hapsari on 08/05/25.
//

import SwiftUI



struct TutorialView: View {
    @Environment(\.dismiss) var dismiss
    let onFinish: () -> Void
    
    var body: some View {
        VStack(alignment: .center, spacing: 45) {
            VStack(alignment: .center, spacing: 10) {
                Text("How to Scan")
                    .scaledFont(size: 18, weight: .semibold)
                    .multilineTextAlignment(.center)
                
                Text("BSD Link Plate Number")
                    .scaledFont(size: 18, weight: .semibold)
                    .multilineTextAlignment(.center)
            }
            
            //tutorial cards
            VStack(spacing: 18) {
                TutorialViewCard(number: "1.", title: "Allow Camera Use", desc: "We need camera permission \non your device")
                TutorialViewCard(number: "2.", title: "Point at The Bus", desc: "Point your camera at the bus plate number")
                TutorialViewCard(number: "3.", title: "Take a Snap", desc: "Press the snap button to get the route information")
            }
            
            Button("Continue") {
                onFinish()}
                    .scaledFont(size: 16, weight: .semibold)
                    .frame(width: 108, height: 36, alignment: .center)
                    .background(Color(.ecOrange))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            
            
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 135)
        .frame(width: 393, height: 852, alignment: .top)
        .background(.ecSecondaryLightDark)
        
        Spacer(minLength: 10)
            
    }
}

#Preview {
    TutorialView (onFinish: {})
}

struct TutorialViewCard: View {
    var number: String
    var title: String
    var desc: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Text(number)
                .scaledFont(size: 15, weight: .semibold)
                .frame(width: 40, height: 39, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text(desc)
                    .font(.callout)
                    .frame(width: 210, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 30)
        .background(.ecLightDark)
        .cornerRadius(15)
    }
}
