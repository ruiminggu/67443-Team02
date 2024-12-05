import XCTest
@testable import Team02 // Replace with the actual name of your module

class IngredientTests: XCTestCase {

    func testIngredientInitialization() {
        // Arrange
        let ingredientName = "Carrot"
        let ingredientAmount = "2 pieces"
        let isChecked = false
        let userID = UUID()
        
        // Act
        let ingredient = Ingredient(name: ingredientName, isChecked: isChecked, userID: userID, amount: ingredientAmount)
        
        // Assert
        XCTAssertEqual(ingredient.name, ingredientName)
        XCTAssertEqual(ingredient.amount, ingredientAmount)
        XCTAssertEqual(ingredient.isChecked, isChecked)
        XCTAssertEqual(ingredient.userID, userID)
    }
    
    func testIngredientEquality() {
        // Arrange
        let userID = UUID()
        let ingredient1 = Ingredient(name: "Carrot", isChecked: false, userID: userID, amount: "2 pieces")
        let ingredient2 = Ingredient(name: "Carrot", isChecked: false, userID: userID, amount: "2 pieces")
        
        // Act & Assert
        XCTAssertEqual(ingredient1, ingredient2)
    }
    
    func testIngredientInequality() {
        // Arrange
        let userID1 = UUID()
        let userID2 = UUID()
        let ingredient1 = Ingredient(name: "Carrot", isChecked: false, userID: userID1, amount: "2 pieces")
        let ingredient2 = Ingredient(name: "Potato", isChecked: true, userID: userID2, amount: "1 kg")
        
        // Act & Assert
        XCTAssertNotEqual(ingredient1, ingredient2)
    }
    
    func testToDictionary() {
        // Arrange
        let ingredientName = "Carrot"
        let ingredientAmount = "2 pieces"
        let isChecked = true
        let userID = UUID()
        let ingredient = Ingredient(name: ingredientName, isChecked: isChecked, userID: userID, amount: ingredientAmount)
        
        // Act
        let ingredientDict = ingredient.toDictionary()
        
        // Assert
        XCTAssertEqual(ingredientDict["name"] as? String, ingredientName)
        XCTAssertEqual(ingredientDict["amount"] as? String, ingredientAmount)
        XCTAssertEqual(ingredientDict["isChecked"] as? Bool, isChecked)
        XCTAssertEqual(ingredientDict["userID"] as? String, userID.uuidString)
        XCTAssertNotNil(ingredientDict["id"] as? String) // Check that the UUID is set
    }
    
    func testIngredientCategoryTitles() {
        // Arrange
        let expectedTitles = [
            "Vegetables & Greens",
            "Meats",
            "Dairy & Eggs",
            "Rices, Grains & Beans"
        ]
        
        // Act
        let titles = IngredientCategory.allCases.map { $0.title }
        
        // Assert
        XCTAssertEqual(titles, expectedTitles)
    }
}
