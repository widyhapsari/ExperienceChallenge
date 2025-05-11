//
//  ResultView.swift
//  ExperienceChallenge
//
//  Created by Rastya Widya Hapsari on 11/05/25.
//

import SwiftUI

struct ResultView: View {
    var body: some View {
        //plate number
        Text("B 7366 JF")
            .scaledFont(size: 14)
            //.frame(maxWidth: .infinity, alignment: .center)
            .fontWeight(.semibold)
            .foregroundColor(Color.ecTosca)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .overlay(RoundedRectangle(cornerRadius: 8)
                .stroke(Color.ecTosca, lineWidth: 1))
        
        //jurusan bus
        Text("Intermoda - De Park (Rute 1)")
            .font(.title3)
            .fontWeight(.medium)
        
    }
}

#Preview {
    ResultView()
}
