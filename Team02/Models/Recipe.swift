import Foundation

struct Recipe: Identifiable, Equatable {
    let id: UUID
    let title: String
    let description: String
    let image: String
    let instruction: String
    let ingredients: [Ingredient]
    let readyInMinutes: Int
    let servings: Int
    
    // Initialize from API response
    init(apiRecipe: APIRecipe) {
        self.id = UUID()
        self.title = apiRecipe.title
        self.description = "Ready in \(apiRecipe.readyInMinutes ?? 30) minutes"
        self.image = apiRecipe.image
        self.instruction = ""
        self.ingredients = []
        self.readyInMinutes = apiRecipe.readyInMinutes ?? 30
        self.servings = apiRecipe.servings ?? 4
    }
    
    // Initialize with individual parameters (for local data)
    init(title: String, description: String, image: String, instruction: String, ingredients: [Ingredient], readyInMinutes: Int = 30, servings: Int = 4) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.image = image
        self.instruction = instruction
        self.ingredients = ingredients
        self.readyInMinutes = readyInMinutes
        self.servings = servings
    }
  
    static func ==(lhs: Recipe, rhs: Recipe) -> Bool {
          return lhs.id == rhs.id &&
                 lhs.title == rhs.title &&
                 lhs.description == rhs.description &&
                 lhs.image == rhs.image &&
                 lhs.instruction == rhs.instruction &&
                 lhs.ingredients == rhs.ingredients &&
                 lhs.readyInMinutes == rhs.readyInMinutes &&
                 lhs.servings == rhs.servings
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
