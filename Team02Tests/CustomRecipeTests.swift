//
//  CustomRecipeTests.swift
//  Team02Tests
//
//  Created by 顾芮名 on 12/6/24.
//

import XCTest
@testable import Team02

final class CustomRecipeTests: XCTestCase {

    func testCustomIngredientInitialization() {
        let ingredientID = UUID()
        let ingredient = CustomIngredient(id: ingredientID, name: "Tomato", amount: "2 cups")
        
        XCTAssertEqual(ingredient.id, ingredientID, "Ingredient ID should match the initialized value")
        XCTAssertEqual(ingredient.name, "Tomato", "Ingredient name should match the initialized value")
        XCTAssertEqual(ingredient.amount, "2 cups", "Ingredient amount should match the initialized value")
    }

    func testCustomIngredientEquality() {
        let ingredientID = UUID()
        let ingredient1 = CustomIngredient(id: ingredientID, name: "Salt", amount: "1 tsp")
        let ingredient2 = CustomIngredient(id: ingredientID, name: "Salt", amount: "1 tsp")

        XCTAssertEqual(ingredient1, ingredient2, "Two ingredients with the same values should be equal")
    }

    func testCustomIngredientToDictionary() {
        let ingredientID = UUID()
        let ingredient = CustomIngredient(id: ingredientID, name: "Pepper", amount: "1 tbsp")
        let dict = ingredient.toDictionary()
        
        XCTAssertEqual(dict["id"] as? String, ingredientID.uuidString, "Ingredient dictionary 'id' should match")
        XCTAssertEqual(dict["name"] as? String, "Pepper", "Ingredient dictionary 'name' should match")
        XCTAssertEqual(dict["amount"] as? String, "1 tbsp", "Ingredient dictionary 'amount' should match")
    }

    func testCustomRecipeInitialization() {
        let recipeID = UUID()
        let ingredient1 = CustomIngredient(id: UUID(), name: "Flour", amount: "2 cups")
        let ingredient2 = CustomIngredient(id: UUID(), name: "Eggs", amount: "3")
        
        let recipe = CustomRecipe(
            id: recipeID,
            title: "Pancakes",
            creatorId: "user123",
            image: "pancake.png",
            instructions: "Mix and fry",
            ingredients: [ingredient1, ingredient2],
            sharedWithEvents: ["event1", "event2"],
            isPrivate: false
        )
        
        XCTAssertEqual(recipe.id, recipeID, "Recipe ID should match the initialized value")
        XCTAssertEqual(recipe.title, "Pancakes", "Recipe title should match the initialized value")
        XCTAssertEqual(recipe.creatorId, "user123", "Recipe creatorId should match the initialized value")
        XCTAssertEqual(recipe.image, "pancake.png", "Recipe image should match the initialized value")
        XCTAssertEqual(recipe.instructions, "Mix and fry", "Recipe instructions should match the initialized value")
        XCTAssertEqual(recipe.ingredients.count, 2, "Recipe should contain two ingredients")
        XCTAssertEqual(recipe.sharedWithEvents, ["event1", "event2"], "Recipe sharedWithEvents should match the initialized value")
        XCTAssertFalse(recipe.isPrivate, "Recipe isPrivate should match the initialized value")
    }

    func testCustomRecipeEquality() {
        let recipeID = UUID()
        let ingredient1 = CustomIngredient(id: UUID(), name: "Sugar", amount: "1 cup")
        let ingredient2 = CustomIngredient(id: UUID(), name: "Butter", amount: "100g")

        let recipe1 = CustomRecipe(
            id: recipeID,
            title: "Cake",
            creatorId: "userABC",
            image: nil,
            instructions: "Bake at 350F for 30 min",
            ingredients: [ingredient1, ingredient2],
            sharedWithEvents: ["eventX"],
            isPrivate: true
        )

        let recipe2 = CustomRecipe(
            id: recipeID,
            title: "Cake",
            creatorId: "userABC",
            image: nil,
            instructions: "Bake at 350F for 30 min",
            ingredients: [ingredient1, ingredient2],
            sharedWithEvents: ["eventX"],
            isPrivate: true
        )

        XCTAssertEqual(recipe1, recipe2, "Two identical recipes should be considered equal")
    }

    func testCustomRecipeToDictionary() {
        let recipeID = UUID()
        let ingredient1 = CustomIngredient(id: UUID(), name: "Milk", amount: "1 cup")

        let recipe = CustomRecipe(
            id: recipeID,
            title: "Hot Chocolate",
            creatorId: "userXYZ",
            image: "hotchocolate.png",
            instructions: "Heat milk and mix cocoa",
            ingredients: [ingredient1],
            sharedWithEvents: ["winterParty"],
            isPrivate: false
        )

        let dict = recipe.toDictionary()

        XCTAssertEqual(dict["id"] as? String, recipeID.uuidString, "Dictionary 'id' should match the recipe ID")
        XCTAssertEqual(dict["title"] as? String, "Hot Chocolate", "Dictionary 'title' should match")
        XCTAssertEqual(dict["creatorId"] as? String, "userXYZ", "Dictionary 'creatorId' should match")
        XCTAssertEqual(dict["image"] as? String, "hotchocolate.png", "Dictionary 'image' should match")
        XCTAssertEqual(dict["instructions"] as? String, "Heat milk and mix cocoa", "Dictionary 'instructions' should match")
        XCTAssertEqual(dict["sharedWithEvents"] as? [String], ["winterParty"], "Dictionary 'sharedWithEvents' should match")
        XCTAssertEqual(dict["isPrivate"] as? Bool, false, "Dictionary 'isPrivate' should match")

        // Check ingredients dictionary
        if let ingredientsArray = dict["ingredients"] as? [[String: Any]] {
            XCTAssertEqual(ingredientsArray.count, 1, "Dictionary should contain one ingredient dictionary")
            if let ingredientDict = ingredientsArray.first {
                XCTAssertNotNil(ingredientDict["id"], "Ingredient dictionary should have 'id'")
                XCTAssertEqual(ingredientDict["name"] as? String, "Milk", "Ingredient dictionary 'name' should match")
                XCTAssertEqual(ingredientDict["amount"] as? String, "1 cup", "Ingredient dictionary 'amount' should match")
            } else {
                XCTFail("First ingredient dictionary is missing or invalid")
            }
        } else {
            XCTFail("Ingredients not found in dictionary or incorrect format")
        }
    }
}
