//
//  CustomRecipeTests.swift
//  Team02Tests
//
//  Created by 顾芮名 on 12/6/24.
//

import XCTest
@testable import Team02

final class CustomRecipeTests: XCTestCase {
    
    func testCustomRecipeInitialization() {
        // Arrange
        let ingredients = [
            CustomIngredient(id: UUID(), name: "Flour", amount: "2 cups"),
            CustomIngredient(id: UUID(), name: "Sugar", amount: "1 cup")
        ]
        
        // Act
        let recipe = CustomRecipe(
            title: "Cake",
            creatorId: "user123",
            image: "cake.jpg",
            instructions: "Mix ingredients and bake for 30 minutes.",
            ingredients: ingredients,
            sharedWithEvents: ["event1", "event2"],
            isPrivate: false
        )
        
        // Assert
        XCTAssertEqual(recipe.title, "Cake")
        XCTAssertEqual(recipe.creatorId, "user123")
        XCTAssertEqual(recipe.image, "cake.jpg")
        XCTAssertEqual(recipe.instructions, "Mix ingredients and bake for 30 minutes.")
        XCTAssertEqual(recipe.ingredients, ingredients)
        XCTAssertEqual(recipe.sharedWithEvents, ["event1", "event2"])
        XCTAssertEqual(recipe.isPrivate, false)
    }
    
    func testCustomRecipeEdgeCaseInitialization() {
        // Arrange
        let emptyIngredients: [CustomIngredient] = []
        
        // Act
        let recipe = CustomRecipe(
            title: "Empty Recipe",
            creatorId: "user456",
            instructions: "",
            ingredients: emptyIngredients,
            sharedWithEvents: []
        )
        
        // Assert
        XCTAssertEqual(recipe.title, "Empty Recipe")
        XCTAssertEqual(recipe.creatorId, "user456")
        XCTAssertEqual(recipe.instructions, "")
        XCTAssertTrue(recipe.ingredients.isEmpty)
        XCTAssertTrue(recipe.sharedWithEvents.isEmpty)
        XCTAssertTrue(recipe.isPrivate)
    }
    
    func testCustomRecipeEquality() {
        // Arrange
        let ingredients1 = [
            CustomIngredient(id: UUID(), name: "Flour", amount: "2 cups"),
            CustomIngredient(id: UUID(), name: "Sugar", amount: "1 cup")
        ]
        let recipe1 = CustomRecipe(
            title: "Cake",
            creatorId: "user123",
            image: "cake.jpg",
            instructions: "Bake for 30 minutes.",
            ingredients: ingredients1,
            sharedWithEvents: ["event1"],
            isPrivate: true
        )
        
        let recipe2 = recipe1
        let recipe3 = CustomRecipe(
            title: "Pie",
            creatorId: "user124",
            image: "pie.jpg",
            instructions: "Bake for 45 minutes.",
            ingredients: [],
            sharedWithEvents: ["event2"],
            isPrivate: false
        )
        
        // Assert
        XCTAssertEqual(recipe1, recipe2)
        XCTAssertNotEqual(recipe1, recipe3)
    }
    
    func testCustomIngredientEquality() {
        // Arrange
        let ingredient1 = CustomIngredient(id: UUID(), name: "Flour", amount: "2 cups")
        let ingredient2 = ingredient1
        let ingredient3 = CustomIngredient(id: UUID(), name: "Sugar", amount: "1 cup")
        
        // Assert
        XCTAssertEqual(ingredient1, ingredient2)
        XCTAssertNotEqual(ingredient1, ingredient3)
    }
    
    func testCustomRecipeToDictionary() {
        // Arrange
        let ingredients = [
            CustomIngredient(id: UUID(), name: "Eggs", amount: "2"),
            CustomIngredient(id: UUID(), name: "Milk", amount: "1 cup")
        ]
        let recipe = CustomRecipe(
            title: "Pancakes",
            creatorId: "user789",
            image: nil,
            instructions: "Mix ingredients and cook.",
            ingredients: ingredients,
            sharedWithEvents: ["event3"],
            isPrivate: false
        )
        
        // Act
        let dictionary = recipe.toDictionary()
        
        // Assert
        XCTAssertEqual(dictionary["title"] as? String, "Pancakes")
        XCTAssertEqual(dictionary["creatorId"] as? String, "user789")
        XCTAssertEqual(dictionary["image"] as? String, "")
        XCTAssertEqual(dictionary["instructions"] as? String, "Mix ingredients and cook.")
        XCTAssertEqual(dictionary["isPrivate"] as? Bool, false)
        
        // Check ingredients
        let ingredientsArray = dictionary["ingredients"] as? [[String: Any]]
        XCTAssertNotNil(ingredientsArray)
        XCTAssertEqual(ingredientsArray?.count, 2)
    }
    
    func testCustomIngredientToDictionary() {
        // Arrange
        let ingredient = CustomIngredient(id: UUID(), name: "Butter", amount: "100g")
        
        // Act
        let dictionary = ingredient.toDictionary()
        
        // Assert
        XCTAssertEqual(dictionary["name"] as? String, "Butter")
        XCTAssertEqual(dictionary["amount"] as? String, "100g")
    }
}
