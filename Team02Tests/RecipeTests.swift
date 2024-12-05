import XCTest
@testable import Team02 // Replace with your module name

class RecipeTests: XCTestCase {

    func testRecipeInitializationFromAPIRecipe() {
        // Arrange
        let apiRecipe = APIRecipe(
            id: 101,
            title: "Spaghetti Carbonara",
            image: "carbonara.jpg",
            imageType: "jpg",
            readyInMinutes: 25,
            servings: 4
        )
        
        // Act
        let recipe = Recipe(apiRecipe: apiRecipe)
        
        // Assert
        XCTAssertEqual(recipe.apiId, 101)
        XCTAssertEqual(recipe.title, "Spaghetti Carbonara")
        XCTAssertEqual(recipe.image, "carbonara.jpg")
        XCTAssertEqual(recipe.readyInMinutes, 25)
        XCTAssertEqual(recipe.servings, 4)
        XCTAssertFalse(recipe.isLiked)
        XCTAssertGreaterThanOrEqual(recipe.rating, 4.0)
        XCTAssertLessThanOrEqual(recipe.rating, 5.0)
    }

    func testRecipeInitializationWithIngredientsAndInstructions() {
        // Arrange
        let apiRecipe = APIRecipe(
            id: 202,
            title: "Chicken Curry",
            image: "curry.jpg",
            imageType: "jpg",
            readyInMinutes: 40,
            servings: 6
        )
        let ingredients = [
            Ingredient(name: "Chicken", isChecked: false, userID: UUID(), amount: "500g"),
            Ingredient(name: "Curry Powder", isChecked: false, userID: UUID(), amount: "2 tbsp")
        ]
        let instructions = "Cook chicken, add curry powder, and simmer."

        // Act
        let recipe = Recipe(apiRecipe: apiRecipe, ingredients: ingredients, instructions: instructions)
        
        // Assert
        XCTAssertEqual(recipe.apiId, 202)
        XCTAssertEqual(recipe.title, "Chicken Curry")
        XCTAssertEqual(recipe.ingredients.count, 2)
        XCTAssertEqual(recipe.instruction, instructions)
        XCTAssertEqual(recipe.readyInMinutes, 40)
        XCTAssertEqual(recipe.servings, 6)
    }

    func testRecipeEquality() {
        // Arrange
        let recipe1 = Recipe(
            title: "Pancakes",
            description: "Fluffy pancakes",
            image: "pancakes.jpg",
            instruction: "Mix and cook",
            ingredients: [],
            readyInMinutes: 15,
            servings: 4
        )
        let recipe2 = Recipe(
            title: "Pancakes",
            description: "Fluffy pancakes",
            image: "pancakes.jpg",
            instruction: "Mix and cook",
            ingredients: [],
            readyInMinutes: 15,
            servings: 4
        )
        
        // Act & Assert
        XCTAssertEqual(recipe1, recipe2)
    }

    func testRecipeInequality() {
        // Arrange
        let recipe1 = Recipe(
            title: "French Toast",
            description: "Delicious French Toast",
            image: "french_toast.jpg",
            instruction: "Soak bread and cook",
            ingredients: [],
            readyInMinutes: 10,
            servings: 2
        )
        let recipe2 = Recipe(
            title: "Omelette",
            description: "Simple omelette",
            image: "omelette.jpg",
            instruction: "Beat eggs and cook",
            ingredients: [],
            readyInMinutes: 5,
            servings: 1
        )
        
        // Act & Assert
        XCTAssertNotEqual(recipe1, recipe2)
    }

    func testRecipeRatingRange() {
        // Arrange
        let apiRecipe = APIRecipe(
            id: 303,
            title: "Salad",
            image: "salad.jpg",
            imageType: "jpg",
            readyInMinutes: 10,
            servings: 2
        )
        
        // Act
        let recipe = Recipe(apiRecipe: apiRecipe)
        
        // Assert
        XCTAssertGreaterThanOrEqual(recipe.rating, 4.0)
        XCTAssertLessThanOrEqual(recipe.rating, 5.0)
    }
  
  func testRecipeInitializationFromAPIRecipeWithMissingFields() {
      // Arrange
      let apiRecipe = APIRecipe(
          id: 404,
          title: "Muffins",
          image: "muffins.jpg",
          imageType: nil, // Missing imageType
          readyInMinutes: nil, // Missing readyInMinutes
          servings: nil // Missing servings
      )
      
      // Act
      let recipe = Recipe(apiRecipe: apiRecipe)
      
      // Assert
      XCTAssertEqual(recipe.apiId, 404)
      XCTAssertEqual(recipe.title, "Muffins")
      XCTAssertEqual(recipe.image, "muffins.jpg")
      XCTAssertEqual(recipe.readyInMinutes, 30) // Default value
      XCTAssertEqual(recipe.servings, 4) // Default value
      XCTAssertFalse(recipe.isLiked)
      XCTAssertGreaterThanOrEqual(recipe.rating, 4.0)
      XCTAssertLessThanOrEqual(recipe.rating, 5.0)
  }
  
  func testRecipeInitializationWithEmptyIngredients() {
      // Arrange
      let apiRecipe = APIRecipe(
          id: 505,
          title: "Smoothie",
          image: "smoothie.jpg",
          imageType: "jpg",
          readyInMinutes: 5,
          servings: 2
      )
      let instructions = "Blend all ingredients."

      // Act
      let recipe = Recipe(apiRecipe: apiRecipe, ingredients: [], instructions: instructions)
      
      // Assert
      XCTAssertEqual(recipe.apiId, 505)
      XCTAssertEqual(recipe.title, "Smoothie")
      XCTAssertTrue(recipe.ingredients.isEmpty)
      XCTAssertEqual(recipe.instruction, instructions)
      XCTAssertEqual(recipe.readyInMinutes, 5)
      XCTAssertEqual(recipe.servings, 2)
  }

  func testRecipeEqualityWithPartialMismatch() {
      // Arrange
      let recipe1 = Recipe(
          title: "Pizza",
          description: "Cheesy goodness",
          image: "pizza.jpg",
          instruction: "Bake with toppings.",
          ingredients: [],
          readyInMinutes: 20,
          servings: 4
      )
      let recipe2 = Recipe(
          title: "Pizza",
          description: "Cheesy goodness",
          image: "pizza.jpg",
          instruction: "Bake with toppings.",
          ingredients: [],
          readyInMinutes: 30, // Different readyInMinutes
          servings: 4
      )
      
      // Act & Assert
      XCTAssertNotEqual(recipe1, recipe2)
  }


}
