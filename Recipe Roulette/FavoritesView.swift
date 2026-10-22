//
//  FavoritesView.swift
//  Recipe Roulette
//
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var viewModel: RecipeViewModel
    
    var body: some View {
        NavigationStack {
            List {
                if viewModel.favorites.isEmpty {
                    Text("No favorites yet. Tap the heart on a recipe to save it.")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(viewModel.favorites) { recipe in
                        NavigationLink {
                            DetailsView(recipe: recipe)
                        } label: {
                            HStack {
                                AsyncImage(url: URL(string: recipe.strRecipeThumb ?? "")) { phase in
                                    switch phase {
                                    case .empty:
                                        Color.gray.opacity(0.2)
                                    case .success(let image):
                                        image.resizable().scaledToFill()
                                    case .failure:
                                        Color.gray.opacity(0.2)
                                    @unknown default:
                                        Color.gray.opacity(0.2)
                                    }
                                }
                                .frame(width: 60, height: 60)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                
                                VStack(alignment: .leading) {
                                    Text(recipe.strRecipe)
                                        .font(.headline)
                                    HStack {
                                        if let cat = recipe.strCategory {
                                            Text(cat)
                                        }
                                        if let area = recipe.strArea {
                                            Text("• \(area)")
                                        }
                                    }
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                    .onDelete { indexSet in
                        viewModel.favorites.remove(atOffsets: indexSet)
                    }
                }
            }
            .navigationTitle("Favorites")
        }
    }
}

#Preview {
    FavoritesView()
        .environmentObject(RecipeViewModel())
}
