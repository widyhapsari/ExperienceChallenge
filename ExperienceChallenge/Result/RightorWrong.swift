//
//  RightorWrong.swift
//  ExperienceChallenge
//
//  Created by Rastya Widya Hapsari on 13/05/25.
//

import SwiftUI

struct RightorWrong: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.seal.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .foregroundStyle(.green)
                .background(Circle().fill(Color.white))
            
            VStack {
                HStack {
                    Text("The bus")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("is going")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.green)
                    
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
    RightorWrong()
}
