import XCTest
@testable import Team02

final class EventTests: XCTestCase {
    
    func testEventInitialization() {
        // Arrange
        let id = UUID()
        let invitedFriends = ["Friend1", "Friend2"]
        let recipes = [
            Recipe(title: "Recipe1", description: "Description1", image: "Image1", instruction: "Instruction1", ingredients: [], readyInMinutes: 30, servings: 2),
            Recipe(title: "Recipe2", description: "Description2", image: "Image2", instruction: "Instruction2", ingredients: [], readyInMinutes: 45, servings: 4)
        ]
        let date = Date()
        let startTime = Date()
        let endTime = Date()
        let location = "Party Location"
        let eventName = "Birthday Party"
        let qrCode = "QRCodeString"
        let costs = [Transaction]()
        let totalCost: Float = 100.50
        let assignedIngredientsList = [
            Ingredient(id: UUID().uuidString, name: "Ingredient1", isChecked: false, userID: "User1", amount: "1kg"),
            Ingredient(id: UUID().uuidString, name: "Ingredient2", isChecked: true, userID: "User2", amount: "500g")
        ]
        
        // Act
        let event = Event(
            id: id,
            invitedFriends: invitedFriends,
            recipes: recipes,
            date: date,
            startTime: startTime,
            endTime: endTime,
            location: location,
            eventName: eventName,
            qrCode: qrCode,
            costs: costs,
            totalCost: totalCost,
            assignedIngredientsList: assignedIngredientsList
        )
        
        // Assert
        XCTAssertEqual(event.id, id)
        XCTAssertEqual(event.invitedFriends, invitedFriends)
        XCTAssertEqual(event.recipes, recipes)
        XCTAssertEqual(event.date, date)
        XCTAssertEqual(event.startTime, startTime)
        XCTAssertEqual(event.endTime, endTime)
        XCTAssertEqual(event.location, location)
        XCTAssertEqual(event.eventName, eventName)
        XCTAssertEqual(event.qrCode, qrCode)
        XCTAssertEqual(event.totalCost, totalCost)
        XCTAssertEqual(event.assignedIngredientsList, assignedIngredientsList)
    }
    
    func testToDictionary() {
        // Arrange
        let id = UUID()
        let invitedFriends = ["Friend1", "Friend2"]
        let recipes = [
            Recipe(title: "Recipe1", description: "Description1", image: "Image1", instruction: "Instruction1", ingredients: [], readyInMinutes: 30, servings: 2)
        ]
        let date = Date()
        let startTime = Date()
        let endTime = Date()
        let location = "Party Location"
        let eventName = "Birthday Party"
        let qrCode = "QRCodeString"
        let costs = [Transaction]()
        let totalCost: Float = 100.50
        let assignedIngredientsList = [
            Ingredient(id: UUID().uuidString, name: "Ingredient1", isChecked: false, userID: "User1", amount: "1kg")
        ]
        
        let event = Event(
            id: id,
            invitedFriends: invitedFriends,
            recipes: recipes,
            date: date,
            startTime: startTime,
            endTime: endTime,
            location: location,
            eventName: eventName,
            qrCode: qrCode,
            costs: costs,
            totalCost: totalCost,
            assignedIngredientsList: assignedIngredientsList
        )
        
        // Act
        let dictionary = event.toDictionary()
        
        // Assert
        XCTAssertEqual(dictionary["id"] as? String, id.uuidString)
        XCTAssertEqual(dictionary["eventName"] as? String, eventName)
        XCTAssertEqual(dictionary["location"] as? String, location)
        XCTAssertEqual(dictionary["qrCode"] as? String, qrCode)
        XCTAssertEqual(dictionary["totalCost"] as? Float, totalCost)
        XCTAssertNotNil(dictionary["assignedIngredientsList"] as? [[String: Any]])
        XCTAssertNotNil(dictionary["recipes"] as? [[String: Any]])
    }
    
    func testInitFromDictionary() {
        // Arrange
        let id = UUID().uuidString
        let invitedFriends = ["Friend1", "Friend2"]
        let recipes: [[String: Any]] = [
            ["title": "Recipe1", "description": "Description1", "image": "Image1", "instruction": "Instruction1", "readyInMinutes": 30, "servings": 2]
        ]
        let date = Date().timeIntervalSince1970
        let startTime = Date().timeIntervalSince1970
        let endTime = Date().timeIntervalSince1970
        let location = "Party Location"
        let eventName = "Birthday Party"
        let qrCode = "QRCodeString"
        let totalCost: Float = 100.50
        let assignedIngredientsList: [[String: Any]] = [
            ["id": UUID().uuidString, "name": "Ingredient1", "amount": "1kg", "isChecked": false, "userID": "User1"]
        ]
        
        let dictionary: [String: Any] = [
            "id": id,
            "invitedFriends": invitedFriends,
            "recipes": recipes,
            "date": date,
            "startTime": startTime,
            "endTime": endTime,
            "location": location,
            "eventName": eventName,
            "qrCode": qrCode,
            "totalCost": totalCost,
            "assignedIngredientsList": assignedIngredientsList
        ]
        
        // Act
        let event = Event(dictionary: dictionary)
        
        // Assert
        XCTAssertNotNil(event)
        XCTAssertEqual(event?.id.uuidString, id)
        XCTAssertEqual(event?.eventName, eventName)
        XCTAssertEqual(event?.location, location)
        XCTAssertEqual(event?.qrCode, qrCode)
        XCTAssertEqual(event?.totalCost, totalCost)
        XCTAssertEqual(event?.invitedFriends, invitedFriends)
        XCTAssertEqual(event?.assignedIngredientsList.count, 1)
        XCTAssertEqual(event?.recipes.count, 1)
    }
}
