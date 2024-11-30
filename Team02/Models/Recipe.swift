import Foundation

struct Recipe: Identifiable, Hashable, Equatable {
    let id: UUID
    let apiId: Int
    let title: String
    let description: String
    let image: String
    let instruction: String
    let ingredients: [Ingredient]
    let readyInMinutes: Int
    let servings: Int
    let rating: Double
    var isLiked: Bool = false // Indicates if the recipe is liked by the user

    // Initialize from API response
    init(apiRecipe: APIRecipe) {
        self.id = UUID()
        self.apiId = apiRecipe.id
        self.title = apiRecipe.title
        self.description = "Ready in \(apiRecipe.readyInMinutes ?? 30) minutes"
        self.image = apiRecipe.image
        self.instruction = ""
        self.ingredients = []
        self.readyInMinutes = apiRecipe.readyInMinutes ?? 30
        self.servings = apiRecipe.servings ?? 4
        self.rating = Double.random(in: 4.0...5.0) // Placeholder
        self.isLiked = false
    }

    // Initialize with individual parameters (for local data)
    init(apiRecipe: APIRecipe, ingredients: [Ingredient], instructions: String) {
        self.id = UUID()
        self.apiId = apiRecipe.id
        self.title = apiRecipe.title
        self.description = "Ready in \(apiRecipe.readyInMinutes ?? 30) minutes"
        self.image = apiRecipe.image
        self.instruction = instructions
        self.ingredients = ingredients
        self.readyInMinutes = apiRecipe.readyInMinutes ?? 30
        self.servings = apiRecipe.servings ?? 4
        self.rating = Double.random(in: 4.0...5.0)
        self.isLiked = false
    }

  init(title: String, description: String, image: String, instruction: String, ingredients: [Ingredient], readyInMinutes: Int, servings: Int) {
          self.id = UUID()
          self.apiId = 0 // Default value since we don't have API ID from dictionary
          self.title = title
          self.description = description
          self.image = image
          self.instruction = instruction
          self.ingredients = ingredients
          self.readyInMinutes = readyInMinutes
          self.servings = servings
          self.rating = 4.5 // Default rating
          self.isLiked = false
      }
  
    static func ==(lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.title == rhs.title &&
               lhs.description == rhs.description &&
               lhs.image == rhs.image &&
               lhs.instruction == rhs.instruction &&
               lhs.ingredients == rhs.ingredients &&
               lhs.readyInMinutes == rhs.readyInMinutes &&
               lhs.servings == rhs.servings &&
               lhs.rating == rhs.rating &&
               lhs.isLiked == rhs.isLiked
    }
}



// API Response Models
struct RecipeSearchResponse: Codable {
    let offset: Int
    let number: Int
    let results: [APIRecipe]
    let totalResults: Int
}

struct APIRecipe: Codable, Identifiable {
    let id: Int
    let title: String
    let image: String
    let imageType: String?
    let readyInMinutes: Int?
    let servings: Int?
}
