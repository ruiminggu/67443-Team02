import XCTest
@testable import Team02

final class RecipeTests: XCTestCase {
    
    func testRecipeInitializationFromAPIRecipe() {
        let apiRecipe = APIRecipe(
            id: 101,
            title: "Spaghetti Bolognese",
            image: "https://example.com/spaghetti.jpg",
            imageType: "jpg",
            readyInMinutes: 45,
            servings: 4
        )
        
        let recipe = Recipe(apiRecipe: apiRecipe)
        
        XCTAssertEqual(recipe.apiId, apiRecipe.id, "API ID should match")
        XCTAssertEqual(recipe.title, apiRecipe.title, "Title should match")
        XCTAssertEqual(recipe.description, "Ready in 45 minutes", "Description should match")
        XCTAssertEqual(recipe.image, apiRecipe.image, "Image URL should match")
        XCTAssertEqual(recipe.readyInMinutes, 45, "ReadyInMinutes should match")
        XCTAssertEqual(recipe.servings, 4, "Servings should match")
        XCTAssertFalse(recipe.isLiked, "Recipe should not be liked by default")
    }
    
    func testRecipeInitializationWithCustomData() {
        let ingredients = [
            Ingredient(id: "1", name: "Tomatoes", isChecked: false, userID: "user1", amount: "2 cups"),
            Ingredient(id: "2", name: "Onion", isChecked: false, userID: "user1", amount: "1 cup")
        ]
        
        let recipe = Recipe(
            title: "Salad",
            description: "A fresh salad",
            image: "https://example.com/salad.jpg",
            instruction: "Mix all ingredients together.",
            ingredients: ingredients,
            readyInMinutes: 10,
            servings: 2
        )
        
        XCTAssertEqual(recipe.title, "Salad", "Title should match")
        XCTAssertEqual(recipe.description, "A fresh salad", "Description should match")
        XCTAssertEqual(recipe.image, "https://example.com/salad.jpg", "Image URL should match")
        XCTAssertEqual(recipe.instruction, "Mix all ingredients together.", "Instruction should match")
        XCTAssertEqual(recipe.ingredients, ingredients, "Ingredients should match")
        XCTAssertEqual(recipe.readyInMinutes, 10, "ReadyInMinutes should match")
        XCTAssertEqual(recipe.servings, 2, "Servings should match")
        XCTAssertEqual(recipe.rating, 4.5, "Default rating should be 4.5")
        XCTAssertFalse(recipe.isLiked, "Recipe should not be liked by default")
    }
    
    func testRecipeEquality() {
        let recipe1 = Recipe(
            title: "Pancakes",
            description: "Fluffy pancakes",
            image: "https://example.com/pancakes.jpg",
            instruction: "Cook on a hot pan.",
            ingredients: [],
            readyInMinutes: 15,
            servings: 4
        )
        
        let recipe2 = Recipe(
            title: "Pancakes",
            description: "Fluffy pancakes",
            image: "https://example.com/pancakes.jpg",
            instruction: "Cook on a hot pan.",
            ingredients: [],
            readyInMinutes: 15,
            servings: 4
        )
        
        XCTAssertEqual(recipe1, recipe2, "Recipes with identical properties should be equal")
    }
    
    func testRecipeInequality() {
        let recipe1 = Recipe(
            title: "Pancakes",
            description: "Fluffy pancakes",
            image: "https://example.com/pancakes.jpg",
            instruction: "Cook on a hot pan.",
            ingredients: [],
            readyInMinutes: 15,
            servings: 4
        )
        
        let recipe2 = Recipe(
            title: "Waffles",
            description: "Crispy waffles",
            image: "https://example.com/waffles.jpg",
            instruction: "Cook in a waffle iron.",
            ingredients: [],
            readyInMinutes: 20,
            servings: 2
        )
        
        XCTAssertNotEqual(recipe1, recipe2, "Recipes with different properties should not be equal")
    }
    
    func testRecipeInitializationFromAPIRecipeWithOptionalData() {
        let apiRecipe = APIRecipe(
            id: 102,
            title: "Soup",
            image: "https://example.com/soup.jpg",
            imageType: nil,
            readyInMinutes: nil,
            servings: nil
        )
        
        let recipe = Recipe(apiRecipe: apiRecipe)
        
        XCTAssertEqual(recipe.apiId, apiRecipe.id, "API ID should match")
        XCTAssertEqual(recipe.title, apiRecipe.title, "Title should match")
        XCTAssertEqual(recipe.description, "Ready in 30 minutes", "Default description should match")
        XCTAssertEqual(recipe.image, apiRecipe.image, "Image URL should match")
        XCTAssertEqual(recipe.readyInMinutes, 30, "Default ReadyInMinutes should match")
        XCTAssertEqual(recipe.servings, 4, "Default Servings should match")
    }
  
  func testRecipeInitializationWithIngredientsAndInstructions() {
      // Arrange
      let apiRecipe = APIRecipe(
          id: 124,
          title: "Pancakes",
          image: "pancakes.jpg",
          imageType: "jpg",
          readyInMinutes: 20,
          servings: 3
      )
      let ingredients = [
          Ingredient(id: "1", name: "Flour", isChecked: false, userID: "user1", amount: "2 cups"),
          Ingredient(id: "2", name: "Milk", isChecked: false, userID: "user2", amount: "1 cup")
      ]
      let instructions = "Mix ingredients and cook on a skillet."
      
      // Act
      let recipe = Recipe(apiRecipe: apiRecipe, ingredients: ingredients, instructions: instructions)
      
      // Assert
      XCTAssertEqual(recipe.title, "Pancakes")
      XCTAssertEqual(recipe.ingredients.count, 2)
      XCTAssertEqual(recipe.instruction, "Mix ingredients and cook on a skillet.")
  }
  
  func testRecipeInitializationWithManualParameters() {
      // Arrange
      let ingredients = [
          Ingredient(id: "1", name: "Eggs", isChecked: false, userID: "user1", amount: "2"),
          Ingredient(id: "2", name: "Cheese", isChecked: false, userID: "user2", amount: "1 cup")
      ]
      
      // Act
      let recipe = Recipe(
          title: "Omelette",
          description: "A quick breakfast recipe.",
          image: "omelette.jpg",
          instruction: "Whisk eggs and cook with cheese.",
          ingredients: ingredients,
          readyInMinutes: 10,
          servings: 2
      )
      
      // Assert
      XCTAssertEqual(recipe.title, "Omelette")
      XCTAssertEqual(recipe.description, "A quick breakfast recipe.")
      XCTAssertEqual(recipe.image, "omelette.jpg")
      XCTAssertEqual(recipe.instruction, "Whisk eggs and cook with cheese.")
      XCTAssertEqual(recipe.ingredients.count, 2)
      XCTAssertEqual(recipe.readyInMinutes, 10)
      XCTAssertEqual(recipe.servings, 2)
      XCTAssertFalse(recipe.isLiked)
  }
  
  func testRecipeHashable() {
      // Arrange
      let recipe = Recipe(
          title: "Pasta",
          description: "Italian classic.",
          image: "pasta.jpg",
          instruction: "Boil pasta and add sauce.",
          ingredients: [],
          readyInMinutes: 20,
          servings: 3
      )
      
      // Act
      let hashValue = recipe.hashValue
      
      // Assert
      XCTAssertNotNil(hashValue)
  }
  
  func testRecipeModification() {
      // Arrange
      var recipe = Recipe(
          title: "Smoothie",
          description: "Refreshing drink.",
          image: "smoothie.jpg",
          instruction: "Blend fruits and serve.",
          ingredients: [],
          readyInMinutes: 5,
          servings: 1
      )
      
      // Act
      recipe.isLiked = true
      
      // Assert
      XCTAssertTrue(recipe.isLiked)
  }
}

