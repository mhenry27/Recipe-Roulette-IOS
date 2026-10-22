// RecipeAPI.swift
import Foundation

struct RecipeAPI {
    static let shared = RecipeAPI()
    private init() {}
    
    private let baseURL = "https://www.themealdb.com/api/json/v1/1"
    
    struct RecipeResponse: Decodable {
        let meals: [Recipe]?
    }
    
    func fetchRandomRecipe() async throws -> Recipe {
        let url = URL(string: "\(baseURL)/random.php")!
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let http = response as? HTTPURLResponse, http.statusCode != 200 {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(RecipeResponse.self, from: data)
        guard let recipe = decoded.meals?.first else {
            throw URLError(.cannotParseResponse)
        }
        return recipe
    }
}
