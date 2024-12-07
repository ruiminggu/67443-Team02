//
//  MenuDatabaseTests.swift
//  Team02Tests
//
//  Created by 顾芮名 on 12/6/24.
//

import XCTest
@testable import Team02

final class MenuDatabaseTests: XCTestCase {
    
    func testMenuDatabaseInitialization() {
        // Arrange
        let recipe1 = Recipe(
            title: "Grilled Cheese",
            description: "A delicious grilled cheese sandwich.",
            image: "grilled_cheese.jpg",
            instruction: "Butter bread, add cheese, grill until golden.",
            ingredients: [],
            readyInMinutes: 10,
            servings: 1
        )
        let recipe2 = Recipe(
            title: "Sausage Fried Rice",
            description: "A quick and easy sausage fried rice recipe.",
            image: "fried_rice.jpg",
            instruction: "Fry sausage, add rice and vegetables, season, and serve.",
            ingredients: [],
            readyInMinutes: 15,
            servings: 2
        )
        let recipes = [recipe1, recipe2]
        let recommendedRecipes = [recipe1]
        
        // Act
        let menuDatabase = MenuDatabase(recipes: recipes, recommendedRecipes: recommendedRecipes)
        
        // Assert
        XCTAssertEqual(menuDatabase.recipes, recipes)
        XCTAssertEqual(menuDatabase.recommendedRecipes, recommendedRecipes)
    }
    
    func testEmptyMenuDatabase() {
        // Act
        let menuDatabase = MenuDatabase(recipes: [], recommendedRecipes: [])
        
        // Assert
        XCTAssertTrue(menuDatabase.recipes.isEmpty, "Recipes should be empty")
        XCTAssertTrue(menuDatabase.recommendedRecipes.isEmpty, "Recommended recipes should be empty")
    }
}
