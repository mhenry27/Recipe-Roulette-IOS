//
//  RecipeView.swift
//  Recipe Roulette
//
//  Created by Mimi Henry on 12/3/25.
//

import SwiftUI

struct RecipeView: View {
    @EnvironmentObject var viewModel: RecipeViewModel
    @State private var showClearAlert = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackgroundColor")
                    .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    if let recipe = viewModel.currentRecipe {
                        RecipeCardView(recipe: recipe)
                            .padding(.horizontal)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                        
                        HStack(spacing: 16) {
                            Button {
                                Task {
                                    await viewModel.fetchRandomRecipe()
                                }
                            } label: {
                                Text("Roll Again")
                                    .font(.headline)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(.color)
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                                    .shadow(radius: 3)
                            }
                            .scaleEffect(viewModel.isLoading ? 0.95 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: viewModel.isLoading)
                            .disabled(viewModel.isLoading)
                            
                            Button {
                                if let recipe = viewModel.currentRecipe {
                                    withAnimation(.spring()) {
                                        viewModel.toggleFavorite(recipe)
                                    }
                                }
                            } label: {
                                Image(systemName: viewModel.isFavorite(viewModel.currentRecipe) ? "heart.fill" : "heart")
                                    .font(.title2)
                                    .padding()
                                    .frame(width: 56, height: 56)
                                    .tint(.color)
                                    .background(Color("CardColor"))
                                    .cornerRadius(16)
                                    .shadow(radius: 3)
                            }
                            .scaleEffect(viewModel.isFavorite(viewModel.currentRecipe) ? 1.2 : 1.0)
                            .animation(.spring(response: 0.2, dampingFraction: 0.5), value: viewModel.isFavorite(viewModel.currentRecipe))
                        }
                        .padding(.horizontal)
                    } else if viewModel.isLoading {
                        ProgressView("Loading recipe…")
                            .padding()
                    } else {
                        Text("Tap Roll Again to spin for a recipe!")
                            .foregroundColor(.secondary)
                        Button {
                            Task { await viewModel.fetchRandomRecipe() }
                        } label: {
                            Text("Roll Again")
                                .font(.headline)
                                .padding()
                                .background(Color.accentColor)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                    }
                    
                    Spacer()
                }
            }
            .navigationTitle("Recipe Roulette")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        viewModel.showFilterSheet = true
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .tint(.color)
                    }
                    .accessibilityLabel("Filter Options")
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(role: .destructive) {
                        showClearAlert = true
                    } label: {
                        Image(systemName: "trash")
                            .tint(.color)
                    }
                    .accessibilityLabel("Clear Favorites")
                }
            }
            .alert("Error", isPresented: $viewModel.showErrorAlert, actions: {
                Button("OK", role: .cancel) { }
            }, message: {
                Text(viewModel.errorMessage)
            })
            .alert("Clear all favorites?", isPresented: $showClearAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Clear", role: .destructive) {
                    withAnimation {
                        viewModel.clearFavorites()
                    }
                }
            } message: {
                Text("This will remove all saved recipes. You cannot undo this.")
            }
            .confirmationDialog("Filter Recipes", isPresented: $viewModel.showFilterSheet) {
                Button("Any Recipe") {
                    viewModel.filterOption = .any
                }
                Button("Match Preferred Cuisine") {
                    viewModel.filterOption = .matchSettingsCategory
                }
                Button("Only Tagged Recipes") {
                    viewModel.filterOption = .onlyTagged
                }
                Button("Short Instructions Only") {
                    viewModel.filterOption = .shortInstructions
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Choose how Recipe Roulette should filter your results.")
            }
        }
    }
}

struct RecipeCardView: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            AsyncImage(url: URL(string: recipe.strRecipeThumb ?? "")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(maxWidth: .infinity, minHeight: 180)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity, minHeight: 180, maxHeight: 220)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                case .failure:
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.gray.opacity(0.2))
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, minHeight: 180, maxHeight: 220)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(maxWidth: .infinity)
            
            Text(recipe.strRecipe)
                .font(.title2.weight(.semibold))
            
            HStack {
                if let category = recipe.strCategory {
                    Label(category, systemImage: "fork.knife")
                }
                if let area = recipe.strArea {
                    Label(area, systemImage: "globe.europe.africa.fill")
                }
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
            
            HStack {
                Label("\(recipe.ingredientCount) ingredients", systemImage: "list.bullet")
                if !recipe.tagList.isEmpty {
                    Label("\(recipe.tagList.count) tags", systemImage: "tag.fill")
                }
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
            
            Text(recipe.shortInstructions)
                .font(.body)
                .foregroundColor(.primary)
                .lineLimit(5)
            
            NavigationLink {
                DetailsView(recipe: recipe)
            } label: {
                Text("View Details")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.accentColor1)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.top, 4)
        }
        .padding()
        .background(Color("CardColor"))
        .cornerRadius(20)
        .shadow(radius: 5)
    }
}

#Preview {
    RecipeView()
        .environmentObject(RecipeViewModel())
}
