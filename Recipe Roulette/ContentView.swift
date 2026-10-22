//
//  ContentView.swift
//  Recipe Roulette
//
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            RecipeView()
                .tabItem {
                    Label("Roulette", systemImage: "die.face.5")
                }
            
            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
            
            InfoView()
                .tabItem {
                    Label("Info", systemImage: "info.circle")
            }
            
            
        }
        .tint(Color.accentColor1)
    }
}

#Preview {
    ContentView()
        .environmentObject(RecipeViewModel())
}
