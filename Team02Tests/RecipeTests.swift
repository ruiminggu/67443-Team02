import XCTest
@testable import Team02

class RecipeTests: XCTestCase {
    
    func testRecipeInitialization() {
        // Arrange
        let ingredients = [
            Ingredient(name: "Tomato", unit: 1.0, isChecked: false, userID: UUID()),
            Ingredient(name: "Cheese", unit: 0.5, isChecked: false, userID: UUID())
        ]
        
        let recipe = Recipe(
            title: "Pasta",
            description: "Delicious pasta with tomato and cheese",
            image: "pasta.jpg",
            instruction: "Boil water, cook pasta, add sauce",
            ingredients: ingredients,
            readyInMinutes: 20,
            servings: 2
        )
        
        // Assert
        XCTAssertEqual(recipe.title, "Pasta")
        XCTAssertEqual(recipe.description, "Delicious pasta with tomato and cheese")
        XCTAssertEqual(recipe.image, "pasta.jpg")
        XCTAssertEqual(recipe.instruction, "Boil water, cook pasta, add sauce")
        XCTAssertEqual(recipe.ingredients, ingredients)
        XCTAssertEqual(recipe.readyInMinutes, 20)
        XCTAssertEqual(recipe.servings, 2)
    }
    
  func testRecipeEqualityExcludingID() {
      // Arrange
      let ingredients1 = [
          Ingredient(name: "Tomato", unit: 1.0, isChecked: false, userID: UUID()),
          Ingredient(name: "Cheese", unit: 0.5, isChecked: false, userID: UUID())
      ]
      
      let ingredients2 = ingredients1  // Use the same list to ensure equality

      let recipe1 = Recipe(
          title: "Pasta",
          description: "Delicious pasta with tomato and cheese",
          image: "pasta.jpg",
          instruction: "Boil water, cook pasta, add sauce",
          ingredients: ingredients1,
          readyInMinutes: 20,
          servings: 2
      )
      
      let recipe2 = Recipe(
          title: "Pasta",
          description: "Delicious pasta with tomato and cheese",
          image: "pasta.jpg",
          instruction: "Boil water, cook pasta, add sauce",
          ingredients: ingredients2,
          readyInMinutes: 20,
          servings: 2
      )
      
      // Act & Assert - Manually compare relevant properties
      XCTAssertEqual(recipe1.title, recipe2.title)
      XCTAssertEqual(recipe1.description, recipe2.description)
      XCTAssertEqual(recipe1.image, recipe2.image)
      XCTAssertEqual(recipe1.instruction, recipe2.instruction)
      XCTAssertEqual(recipe1.ingredients, recipe2.ingredients)
      XCTAssertEqual(recipe1.readyInMinutes, recipe2.readyInMinutes)
      XCTAssertEqual(recipe1.servings, recipe2.servings)
  }

    
}
