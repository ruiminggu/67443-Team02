//import XCTest
//@testable import Team02
//
//class IngredientTests: XCTestCase {
//
//    func testIngredientInitialization() {
//        // Arrange
//        let id = UUID()
//        let name = "Tomato"
//        let unit: Float = 1.5
//        let isChecked = false
//        let userID = UUID()
//
//        // Act
//        let ingredient = Ingredient(name: name, unit: unit, isChecked: isChecked, userID: userID)
//
//        // Assert
//        XCTAssertEqual(ingredient.name, name, "The ingredient name should be \(name)")
//        XCTAssertEqual(ingredient.unit, unit, "The ingredient unit should be \(unit)")
//        XCTAssertEqual(ingredient.isChecked, isChecked, "The ingredient isChecked should be \(isChecked)")
//        XCTAssertEqual(ingredient.userID, userID, "The ingredient userID should be \(userID)")
//    }
//
//    func testIngredientEquality() {
//        // Arrange
//        let id = UUID()
//        let userID = UUID()
//        
//        let ingredient1 = Ingredient(name: "Carrot", unit: 2.0, isChecked: false, userID: userID)
//        let ingredient2 = Ingredient(name: "Carrot", unit: 2.0, isChecked: false, userID: userID)
//
//        // Act & Assert
//        XCTAssertEqual(ingredient1, ingredient2, "Two ingredients with the same properties should be equal")
//    }
//
//    func testIngredientInequality() {
//        // Arrange
//        let userID = UUID()
//
//        let ingredient1 = Ingredient(name: "Carrot", unit: 2.0, isChecked: false, userID: userID)
//        let ingredient2 = Ingredient(name: "Tomato", unit: 1.0, isChecked: true, userID: UUID())
//
//        // Act & Assert
//        XCTAssertNotEqual(ingredient1, ingredient2, "Ingredients with different properties should not be equal")
//    }
//  
//  func testIngredientCategoryTitle() {
//          // Arrange & Act
//          let vegetablesAndGreensTitle = IngredientCategory.vegetablesAndGreens.title
//          let meatsTitle = IngredientCategory.meats.title
//          let dairyAndEggsTitle = IngredientCategory.dairyAndEggs.title
//          let ricesGrainsAndBeansTitle = IngredientCategory.ricesGrainsAndBeans.title
//          
//          // Assert
//          XCTAssertEqual(vegetablesAndGreensTitle, "Vegetables & Greens")
//          XCTAssertEqual(meatsTitle, "Meats")
//          XCTAssertEqual(dairyAndEggsTitle, "Dairy & Eggs")
//          XCTAssertEqual(ricesGrainsAndBeansTitle, "Rices, Grains & Beans")
//      }
//}
