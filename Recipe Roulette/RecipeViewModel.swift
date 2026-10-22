//
//  RecipeViewModel.swift
//  Recipe Roulette
//
//

import Foundation
import SwiftUI

@MainActor
class RecipeViewModel: ObservableObject {
    @Published var currentRecipe: Recipe?
    @Published var isLoading: Bool = false
    @Published var favorites: [Recipe] = []
    
    @Published var showErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    
    // For action sheet / confirmationDialog
    @Published var showFilterSheet: Bool = false
    @Published var filterOption: RouletteFilterOption = .any
    
    init() {
        Task {
            await fetchRandomRecipe()
        }
    }
    
    func fetchRandomRecipe() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let recipe = try await RecipeAPI.shared.fetchRandomRecipe()
            
            if shouldAccept(recipe: recipe) {
                withAnimation(.spring()) {
                    self.currentRecipe = recipe
                }
            } else {
                try await Task.sleep(nanoseconds: 300_000_000)
                await fetchRandomRecipe()
            }
        } catch {
            // 👇 show the actual underlying error
            let nsError = error as NSError
            errorMessage = "Error: \(nsError.domain) (\(nsError.code))\n\(error.localizedDescription)"
            print("DEBUG fetchRandomRecipe error:", error)
            showErrorAlert = true
        }
    } 
    
    func toggleFavorite(_ recipe: Recipe) {
        if let idx = favorites.firstIndex(of: recipe) {
            favorites.remove(at: idx)
        } else {
            favorites.append(recipe)
        }
    }
    
    func isFavorite(_ recipe: Recipe?) -> Bool {
        guard let recipe else { return false }
        return favorites.contains(recipe)
    }
    
    func clearFavorites() {
        favorites.removeAll()
    }
    
    private func shouldAccept(recipe: Recipe) -> Bool {
        switch filterOption {
        case .any:
            return true
        case .matchSettingsCategory:
            let preferred = UserDefaults.standard.string(forKey: SettingsKeys.preferredCuisine) ?? "Any"
            if preferred == "Any" { return true }
            let category = recipe.strCategory ?? ""
            return category.localizedCaseInsensitiveContains(preferred)
        case .onlyTagged:
            return !recipe.tagList.isEmpty
        case .shortInstructions:
            return recipe.shortInstructions.count <= 200
        }
    }
}

enum RouletteFilterOption: String, CaseIterable {
    case any = "Any Recipe"
    case matchSettingsCategory = "Match Preferred Cuisine"
    case onlyTagged = "Only Tagged Recipes"
    case shortInstructions = "Short Instructions Only"
}

struct SettingsKeys {
    static let preferredCuisine = "preferredCuisine"
    static let maxCookTime = "maxCookTime"          // not used by API, but kept for SettingsView
    static let vegetarianOnly = "vegetarianOnly"    // likewise
    static let notificationHour = "notificationHour"
}
