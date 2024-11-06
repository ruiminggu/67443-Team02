//
//  RecipeSearchViewModel.swift
//  Team02
//
//  Created by Xinyi Chen on 11/4/24.
//

import SwiftUI

class RecipeSearchViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var isLoading = false
    @Published var searchText = ""
    @Published var error: String?
    
    private let apiKey = "efc5ce03c31944868cad1cf4fb972a26"
    
    func searchRecipes() async {
        guard !searchText.isEmpty else {
            await MainActor.run {
                recipes = []
            }
            return
        }
        
        let urlString = "https://api.spoonacular.com/recipes/complexSearch?apiKey=\(apiKey)&query=\(searchText)&number=10&addRecipeInformation=true"
        
        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
            print("Invalid URL")
            return
        }
        
        await MainActor.run {
            isLoading = true
            error = nil
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let recipeResponse = try decoder.decode(RecipeSearchResponse.self, from: data)
            
            await MainActor.run {
                self.recipes = recipeResponse.results.map { Recipe(apiRecipe: $0) }
                isLoading = false
            }
        } catch {
            print("Error fetching recipes: \(error)")
            await MainActor.run {
                self.error = "Failed to load recipes. Please try again."
                isLoading = false
                recipes = []
            }
        }
    }
}
