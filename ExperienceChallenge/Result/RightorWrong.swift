//
//  RightorWrong.swift
//  ExperienceChallenge
//
//  Created by Rastya Widya Hapsari on 13/05/25.
//

import SwiftUI

struct RightorWrong: View {
    let isGoingToDestination: Bool

        var body: some View {
            VStack(spacing: 16) {
                Image(systemName: isGoingToDestination ? "checkmark.seal.fill" : "xmark.seal.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .foregroundStyle(isGoingToDestination ? .green : .red)
                    .background(Circle().fill(Color.ecLightDark))
                
                VStack {
                    HStack {
                        Text("The bus")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text(isGoingToDestination ? "is going" : "is not going")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundStyle(isGoingToDestination ? .green : .red)
                        
                        Text("to")
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                    
                    Text("your destination")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
            }
        }

}

#Preview {
    RightorWrong(isGoingToDestination: true)
}
