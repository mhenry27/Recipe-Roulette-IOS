//
//  Recipe_RouletteApp.swift
//  Recipe Roulette
//
//

import SwiftUI

@main
struct Recipe_RouletteApp: App {
    @StateObject private var recipeViewModel = RecipeViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(recipeViewModel)
        }
    }
}
