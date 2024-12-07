import XCTest
@testable import Team02

final class IngredientTests: XCTestCase {
    
    func testIngredientInitialization() {
        let ingredient = Ingredient(
            id: "12345",
            name: "Tomato",
            isChecked: false,
            userID: "user123",
            amount: "2 cups"
        )
        
        XCTAssertEqual(ingredient.id, "12345", "Ingredient ID is incorrect")
        XCTAssertEqual(ingredient.name, "Tomato", "Ingredient name is incorrect")
        XCTAssertEqual(ingredient.isChecked, false, "Ingredient isChecked is incorrect")
        XCTAssertEqual(ingredient.userID, "user123", "Ingredient userID is incorrect")
        XCTAssertEqual(ingredient.amount, "2 cups", "Ingredient amount is incorrect")
    }
    
    func testIngredientToDictionary() {
        let ingredient = Ingredient(
            id: "12345",
            name: "Tomato",
            isChecked: false,
            userID: "user123",
            amount: "2 cups"
        )
        
        let dictionary = ingredient.toDictionary()
        
        XCTAssertEqual(dictionary["id"] as? String, "12345", "Ingredient dictionary 'id' is incorrect")
        XCTAssertEqual(dictionary["name"] as? String, "Tomato", "Ingredient dictionary 'name' is incorrect")
        XCTAssertEqual(dictionary["isChecked"] as? Bool, false, "Ingredient dictionary 'isChecked' is incorrect")
        XCTAssertEqual(dictionary["userID"] as? String, "user123", "Ingredient dictionary 'userID' is incorrect")
        XCTAssertEqual(dictionary["amount"] as? String, "2 cups", "Ingredient dictionary 'amount' is incorrect")
    }
    
    func testIngredientEquality() {
        let ingredient1 = Ingredient(
            id: "12345",
            name: "Tomato",
            isChecked: false,
            userID: "user123",
            amount: "2 cups"
        )
        
        let ingredient2 = Ingredient(
            id: "67890",
            name: "Tomato",
            isChecked: false,
            userID: "user123",
            amount: "2 cups"
        )
        
        XCTAssertEqual(ingredient1, ingredient2, "Ingredients should be equal based on their properties")
    }
    
    func testIngredientInequality() {
        let ingredient1 = Ingredient(
            id: "12345",
            name: "Tomato",
            isChecked: false,
            userID: "user123",
            amount: "2 cups"
        )
        
        let ingredient2 = Ingredient(
            id: "12345",
            name: "Salt",
            isChecked: false,
            userID: "user123",
            amount: "2 cups"
        )
        
        XCTAssertNotEqual(ingredient1, ingredient2, "Ingredients with different names should not be equal")
    }
    
    func testIngredientCategoryEnum() {
        XCTAssertEqual(IngredientCategory.vegetablesAndGreens.title, "Vegetables & Greens", "IngredientCategory title is incorrect")
        XCTAssertEqual(IngredientCategory.meats.title, "Meats", "IngredientCategory title is incorrect")
        XCTAssertEqual(IngredientCategory.dairyAndEggs.title, "Dairy & Eggs", "IngredientCategory title is incorrect")
        XCTAssertEqual(IngredientCategory.ricesGrainsAndBeans.title, "Rices, Grains & Beans", "IngredientCategory title is incorrect")
    }
}
