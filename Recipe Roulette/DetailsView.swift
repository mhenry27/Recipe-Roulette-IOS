//
//  DetailsView.swift
//  Recipe Roulette
//
//

import SwiftUI

struct DetailsView: View {
    @EnvironmentObject var viewModel: RecipeViewModel
    let recipe: Recipe
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: URL(string: recipe.strRecipeThumb ?? "")) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(maxWidth: .infinity, minHeight: 200)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity, minHeight: 220)
                            .clipped()
                    case .failure:
                        ZStack {
                            Color.gray.opacity(0.2)
                            Image(systemName: "photo")
                                .font(.largeTitle)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, minHeight: 200)
                    @unknown default:
                        EmptyView()
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Text(recipe.strRecipe)
                    .font(.title.bold())
                
                HStack(spacing: 12) {
                    if let category = recipe.strCategory {
                        TagChip(text: category, systemImage: "fork.knife")
                    }
                    if let area = recipe.strArea {
                        TagChip(text: area, systemImage: "globe")
                    }
                    TagChip(text: "\(recipe.ingredientCount) ingredients", systemImage: "list.bullet")
                }
                
                if !recipe.tagList.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(recipe.tagList, id: \.self) { tag in
                                TagChip(text: tag, systemImage: "tag")
                            }
                        }
                    }
                }
                
                if !recipe.ingredients.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Ingredients")
                            .font(.headline)
                        ForEach(recipe.ingredients, id: \.self) { ing in
                            HStack(alignment: .top) {
                                Text("•")
                                Text(ing)
                            }
                        }
                    }
                }
                
                if let instructions = recipe.strInstructions {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Instructions")
                            .font(.headline)
                        Text(instructions)
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                }
                
                if let source = recipe.strSource, let url = URL(string: source) {
                    Link(destination: url) {
                        Label("Open Original Recipe", systemImage: "safari")
                            .font(.headline)
                            .tint(.color)
                    }
                    .padding(.top, 8)
                }
                
                Button {
                    withAnimation(.spring()) {
                        viewModel.toggleFavorite(recipe)
                    }
                } label: {
                    HStack {
                        Image(systemName: viewModel.isFavorite(recipe) ? "heart.fill" : "heart")
                        Text(viewModel.isFavorite(recipe) ? "Remove from Favorites" : "Add to Favorites")
                    }
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("CardAccentColor"))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .padding(.top, 16)
            }
            .padding()
        }
        .background(Color("BackgroundColor").ignoresSafeArea())
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct TagChip: View {
    let text: String
    let systemImage: String
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: systemImage)
            Text(text)
        }
        .font(.caption)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color("ChipColor"))
        .cornerRadius(999)
    }
}

#Preview {
    let vm = RecipeViewModel()
    DetailsView(recipe: vm.currentRecipe ?? Recipe(
        idRecipe: "1",
        strRecipe: "Test Recipe",
        strCategory: "Category",
        strArea: "Area",
        strInstructions: "Some long instructions...",
        strRecipeThumb: nil,
        strTags: "Tag1,Tag2",
        strSource: "https://example.com",
        strIngredient1: "Flour", strIngredient2: "Eggs", strIngredient3: nil, strIngredient4: nil,
        strIngredient5: nil, strIngredient6: nil, strIngredient7: nil, strIngredient8: nil,
        strIngredient9: nil, strIngredient10: nil, strIngredient11: nil, strIngredient12: nil,
        strIngredient13: nil, strIngredient14: nil, strIngredient15: nil, strIngredient16: nil,
        strIngredient17: nil, strIngredient18: nil, strIngredient19: nil, strIngredient20: nil,
        strMeasure1: "200g", strMeasure2: "2", strMeasure3: nil, strMeasure4: nil,
        strMeasure5: nil, strMeasure6: nil, strMeasure7: nil, strMeasure8: nil,
        strMeasure9: nil, strMeasure10: nil, strMeasure11: nil, strMeasure12: nil,
        strMeasure13: nil, strMeasure14: nil, strMeasure15: nil, strMeasure16: nil,
        strMeasure17: nil, strMeasure18: nil, strMeasure19: nil, strMeasure20: nil
    ))
    .environmentObject(vm)
}
