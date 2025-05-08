//
//  extensions.swift
//  ExperienceChallenge
//
//  Created by Rastya Widya Hapsari on 08/05/25.
//

import SwiftUICore

//orange gradient
extension LinearGradient {
    static let appPrimaryGradient = LinearGradient(
        colors: [Color(red: 1, green: 0.5, blue: 0.21), Color(red: 1, green: 0.33, blue: 0.33)],
        startPoint: .top,
        endPoint: .bottom
    )
}


//dynamic font
extension View {
    func scaledFont(size: CGFloat, weight: Font.Weight = .regular, widthScaleFactor: CGFloat = 1.0) -> some View {
        self.modifier(ScaledFont(size: size, weight: weight, widthScaleFactor: widthScaleFactor))
    }
}

struct ScaledFont: ViewModifier {
    var size: CGFloat
    var weight: Font.Weight
    var widthScaleFactor: CGFloat
    
    @Environment(\.sizeCategory) var sizeCategory
    
    func body(content: Content) -> some View {
           let scaleFactor = computeScaleFactor()
           
           return content
               .font(.system(size: size, weight: weight))
               .scaleEffect(scaleFactor, anchor: .center)
       }
    
    private func computeScaleFactor() -> CGSize {
        let baseScaleFactor: CGFloat
        
        switch sizeCategory {
        case .accessibilityExtraExtraExtraLarge:
            baseScaleFactor = 2.0
        case .accessibilityExtraExtraLarge:
            baseScaleFactor = 1.8
        case .accessibilityExtraLarge:
            baseScaleFactor = 1.6
        case .accessibilityLarge:
            baseScaleFactor = 1.4
        case .accessibilityMedium:
            baseScaleFactor = 1.3
        case .extraExtraExtraLarge:
            baseScaleFactor = 1.25
        case .extraExtraLarge:
            baseScaleFactor = 1.2
        case .extraLarge:
            baseScaleFactor = 1.15
        case .large:
            baseScaleFactor = 1.1
        case .medium:
            baseScaleFactor = 1.05
        default:
            baseScaleFactor = 1.0
        }
        
        // Apply width scaling factor (horizontal stretch)
        return CGSize(width: baseScaleFactor * widthScaleFactor, height: baseScaleFactor)
    }
}
