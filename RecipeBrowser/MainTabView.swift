//
//  MainTabView.swift
//  RecipeBrowser
//
//  Created by FredyCamas on 7/13/24.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.brown.opacity(0.1), .brown.opacity(0.2)]),
                           startPoint: .top,
                           endPoint: .bottom)
            .ignoresSafeArea()
            
            TabView {
                ContentView()
                    .tabItem {
                        Label("Main", systemImage: "house.fill")
                    }
                
                Favorite()
                    .tabItem {
                        Label("Favorite", systemImage: "heart")
                    }
            }
        }
    }
}

#Preview {
    MainTabView()
}
