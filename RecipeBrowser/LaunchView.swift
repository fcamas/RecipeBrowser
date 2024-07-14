//
//  LaunchView.swift
//  RecipeBrowser
//
//  Created by FredyCamas on 7/13/24.
//

import SwiftUI

struct LaunchView: View {
    @State private var maxFontSize: CGFloat = 40
    @State private var fontSize: CGFloat = 3
    @State private var showMainTabView = false
    
    let colors: [Color] = [
        .materialRed, .materialPink, .materialPurple, .materialDeepPurple,
        .materialIndigo, .materialBlue, .materialLightBlue, .materialCyan,
        .materialTeal, .materialGreen, .materialLightGreen, .materialLime,
        .materialYellow, .materialAmber, .materialOrange, .materialDeepOrange,
        .materialBrown, .materialGray, .materialBlueGray,
        .red, .green, .blue, .orange, .purple, .pink, .yellow, .brown
    ]
    
    var body: some View {
        ZStack {
            Rectangle()
                .ignoresSafeArea()
                .foregroundStyle(Gradient(colors: [.brown.opacity(0.1), .brown.opacity(0.2)]))
            
            // Texts forming "Recipe Browser" with animation
            HStack {
                ForEach(Array("Recipe Browser"), id: \.self) { character in
                    let color = colors.randomElement() ?? .black
                    Text(String(character))
                        .foregroundStyle(color)
                        .font(.system(size: fontSize))
                        .offset(
                            x: fontSize == maxFontSize ? CGFloat(Int.random(in: -300...300)) : 0,
                            y: fontSize == maxFontSize ? CGFloat(Int.random(in: -400...400)) : 0
                        )
                        .opacity(fontSize == maxFontSize ? 0 : 1)
                }
            }
            .onAppear {
                fontSize = 2
                
                // Timer to animate the font size incrementally
                Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                    withAnimation {
                        fontSize += 1
                        // When maximum font size is reached, stop the timer and navigate
                        if fontSize == maxFontSize {
                            timer.invalidate()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                showMainTabView = true
                            }
                        }
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showMainTabView) {
            MainTabView()
        }
    }
}

#Preview {
    LaunchView()
}

extension Color {
    static let materialRed = Color(red: 244/255, green: 67/255, blue: 54/255)
    static let materialPink = Color(red: 233/255, green: 30/255, blue: 99/255)
    static let materialPurple = Color(red: 156/255, green: 39/255, blue: 176/255)
    static let materialDeepPurple = Color(red: 103/255, green: 58/255, blue: 183/255)
    static let materialIndigo = Color(red: 63/255, green: 81/255, blue: 181/255)
    static let materialBlue = Color(red: 33/255, green: 150/255, blue: 243/255)
    static let materialLightBlue = Color(red: 3/255, green: 169/255, blue: 244/255)
    static let materialCyan = Color(red: 0/255, green: 188/255, blue: 212/255)
    static let materialTeal = Color(red: 0/255, green: 150/255, blue: 136/255)
    static let materialGreen = Color(red: 76/255, green: 175/255, blue: 80/255)
    static let materialLightGreen = Color(red: 139/255, green: 195/255, blue: 74/255)
    static let materialLime = Color(red: 205/255, green: 220/255, blue: 57/255)
    static let materialYellow = Color(red: 255/255, green: 235/255, blue: 59/255)
    static let materialAmber = Color(red: 255/255, green: 193/255, blue: 7/255)
    static let materialOrange = Color(red: 255/255, green: 152/255, blue: 0/255)
    static let materialDeepOrange = Color(red: 255/255, green: 87/255, blue: 34/255)
    static let materialBrown = Color(red: 121/255, green: 85/255, blue: 72/255)
    static let materialGray = Color(red: 158/255, green: 158/255, blue: 158/255)
    static let materialBlueGray = Color(red: 96/255, green: 125/255, blue: 139/255)
}
