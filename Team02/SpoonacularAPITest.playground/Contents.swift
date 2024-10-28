import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

// Structs for API data
struct RecipeSearchResponse: Codable {
    let offset: Int
    let number: Int
    let results: [Recipe]
    let totalResults: Int
}

struct Recipe: Codable {
    let id: Int
    let title: String
    let image: String
    let imageType: String
}

// Function to fetch recipes
func fetchRecipes() async {
    let apiKey = "efc5ce03c31944868cad1cf4fb972a26"
    let urlString = "https://api.spoonacular.com/recipes/complexSearch?apiKey=\(apiKey)&query=fried&maxFat=25&number=2"
    
    guard let url = URL(string: urlString) else {
        print("Invalid URL")
        return
    }
    
    do {
        let (data, response) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        let recipeResponse = try decoder.decode(RecipeSearchResponse.self, from: data)
      
        print("Total Results: \(recipeResponse.totalResults)")
        print("Number of recipes in this response: \(recipeResponse.results.count)")
        
        for recipe in recipeResponse.results {
            print("Recipe: \(recipe.title)")
            print("Image URL: \(recipe.image)")
            print("---")
        }
    } catch {
        print("Error fetching recipes: \(error)")
    }
    
    PlaygroundPage.current.finishExecution()
}

// Call the function
Task {
    await fetchRecipes()
}
