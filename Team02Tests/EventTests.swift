//import XCTest
//@testable import Team02
//
//class EventTests: XCTestCase {
//
//    func testEventInitialization() {
//        // Arrange
//        let id = UUID()
//        let invitedFriends = ["friend1", "friend2"]
//        
//        let mockIngredients = [
//            Ingredient(name: "Tomato", unit: 2.0, isChecked: false, userID: UUID(), amount: 5.0),
//            Ingredient(name: "Cheese", unit: 1.0, isChecked: false, userID: UUID(), amount: 2.0)
//        ]
//        
//        let recipes = [
//            Recipe(title: "Pasta", description: "Delicious pasta recipe", image: "pasta.jpg", instruction: "Boil pasta", ingredients: mockIngredients, readyInMinutes: 30, servings: 2)
//        ]
//        
//        let date = Date()
//        let startTime = Date().addingTimeInterval(3600) // 1 hour later
//        let endTime = Date().addingTimeInterval(7200) // 2 hours later
//        let location = "123 Event Place"
//        let eventName = "Birthday Party"
//        let qrCode = "SampleQRCode"
//        
//        let mockUser1 = User(id: UUID(), fullName: "John Doe", image: "profile.jpg", email: "john@example.com", password: "password123", events: [])
//        let mockUser2 = User(id: UUID(), fullName: "Jane Doe", image: "profile.jpg", email: "jane@example.com", password: "password123", events: [])
//        
//        let placeholderEvent = Event(
//            id: UUID(),
//            invitedFriends: [],
//            recipes: [],
//            date: Date(),
//            startTime: Date(),
//            endTime: Date(),
//            location: "Test Location",
//            eventName: "Test Event",
//            qrCode: "TestQRCode",
//            costs: [],
//            totalCost: 0,
//            assignedIngredientsList: []
//        )
//        
//        let costs = [Transaction(payer: mockUser1, payee: mockUser2, item: "Gift", amount: 50.0, event: placeholderEvent)]
//        let totalCost: Float = 100.0
//        let assignedIngredientsList = [Ingredient(name: "Tomato", unit: 2.0, isChecked: false, userID: UUID()),]
//
//        // Act
//        let event = Event(
//            id: id,
//            invitedFriends: invitedFriends,
//            recipes: recipes,
//            date: date,
//            startTime: startTime,
//            endTime: endTime,
//            location: location,
//            eventName: eventName,
//            qrCode: qrCode,
//            costs: costs,
//            totalCost: totalCost,
//            assignedIngredientsList: assignedIngredientsList
//        )
//
//        // Assert
//        XCTAssertEqual(event.id, id)
//        XCTAssertEqual(event.invitedFriends, invitedFriends)
//        XCTAssertEqual(event.recipes, recipes)
//        XCTAssertEqual(event.date, date)
//        XCTAssertEqual(event.startTime, startTime)
//        XCTAssertEqual(event.endTime, endTime)
//        XCTAssertEqual(event.location, location)
//        XCTAssertEqual(event.eventName, eventName)
//        XCTAssertEqual(event.qrCode, qrCode)
//        XCTAssertEqual(event.costs, costs)
//        XCTAssertEqual(event.totalCost, totalCost)
//        XCTAssertEqual(event.assignedIngredientsList, assignedIngredientsList)
//    }
//    
//    func testEventToDictionary() {
//        // Arrange
//        let id = UUID()
//        let invitedFriends = ["friend1", "friend2"]
//        
//        let date = Date()
//        let startTime = Date().addingTimeInterval(3600)
//        let endTime = Date().addingTimeInterval(7200)
//        
//        let event = Event(
//            id: id,
//            invitedFriends: invitedFriends,
//            recipes: [],
//            date: date,
//            startTime: startTime,
//            endTime: endTime,
//            location: "123 Event Place",
//            eventName: "Sample Event",
//            qrCode: "QRCodeSample",
//            costs: [],
//            totalCost: 150.0,
//            assignedIngredientsList: []
//        )
//
//        // Act
//        let dictionary = event.toDictionary()
//
//        // Assert
//        XCTAssertEqual(dictionary["id"] as? String, id.uuidString)
//        XCTAssertEqual(dictionary["eventName"] as? String, "Sample Event")
//        XCTAssertEqual(dictionary["date"] as? TimeInterval, date.timeIntervalSince1970)
//        XCTAssertEqual(dictionary["startTime"] as? TimeInterval, startTime.timeIntervalSince1970)
//        XCTAssertEqual(dictionary["endTime"] as? TimeInterval, endTime.timeIntervalSince1970)
//        XCTAssertEqual(dictionary["location"] as? String, "123 Event Place")
//        XCTAssertEqual(dictionary["qrCode"] as? String, "QRCodeSample")
//        XCTAssertEqual(dictionary["totalCost"] as? Float, 150.0)
//        XCTAssertEqual(dictionary["invitedFriends"] as? [String], invitedFriends)
//    }
//    
//}
