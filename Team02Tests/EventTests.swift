import XCTest
@testable import Team02 // Replace with your module name

class EventTests: XCTestCase {

    func testEventInitialization() {
        // Arrange
        let eventID = UUID()
        let date = Date()
        let startTime = Date()
        let endTime = Date().addingTimeInterval(3600) // 1 hour later
        let location = "Central Park"
        let eventName = "Picnic Party"
        let qrCode = "QRCode123"
        let invitedFriends = ["Alice", "Bob"]
        let recipes: [Recipe] = [
            Recipe(
                title: "Pasta Salad",
                description: "A fresh pasta salad",
                image: "pasta.jpg",
                instruction: "Mix ingredients and chill",
                ingredients: [],
                readyInMinutes: 15,
                servings: 4
            )
        ]
        let costs: [Transaction] = []
        let totalCost: Float = 50.0
        let assignedIngredientsList: [Ingredient] = [
            Ingredient(name: "Pasta", isChecked: false, userID: UUID(), amount: "500g"),
            Ingredient(name: "Olive Oil", isChecked: true, userID: UUID(), amount: "2 tbsp")
        ]

        // Act
        let event = Event(
            id: eventID,
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
        XCTAssertEqual(event.id, eventID)
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

    func testEventEquality() {
        // Arrange
        let event1 = Event(
            recipes: [],
            date: Date(),
            startTime: Date(),
            endTime: Date().addingTimeInterval(3600),
            location: "Park",
            eventName: "Event 1",
            qrCode: "QR1",
            costs: [],
            totalCost: 0,
            assignedIngredientsList: []
        )

        let event2 = Event(
            id: event1.id, // Same ID to ensure equality
            recipes: [],
            date: event1.date,
            startTime: event1.startTime,
            endTime: event1.endTime,
            location: "Park",
            eventName: "Event 1",
            qrCode: "QR1",
            costs: [],
            totalCost: 0,
            assignedIngredientsList: []
        )

        // Act & Assert
        XCTAssertEqual(event1, event2)
    }

    func testEventInequality() {
        // Arrange
        let event1 = Event(
            recipes: [],
            date: Date(),
            startTime: Date(),
            endTime: Date().addingTimeInterval(3600),
            location: "Park",
            eventName: "Event 1",
            qrCode: "QR1",
            costs: [],
            totalCost: 0,
            assignedIngredientsList: []
        )

        let event2 = Event(
            recipes: [],
            date: Date().addingTimeInterval(86400), // Different date
            startTime: Date(),
            endTime: Date().addingTimeInterval(3600),
            location: "Park",
            eventName: "Event 2",
            qrCode: "QR2",
            costs: [],
            totalCost: 0,
            assignedIngredientsList: []
        )

        // Act & Assert
        XCTAssertNotEqual(event1, event2)
    }

    func testEventSerialization() {
        // Arrange
        let eventID = UUID()
        let date = Date()
        let startTime = Date()
        let endTime = Date().addingTimeInterval(3600) // 1 hour later
        let location = "Central Park"
        let eventName = "Picnic Party"
        let qrCode = "QRCode123"
        let invitedFriends = ["Alice", "Bob"]
        let recipes: [Recipe] = [
            Recipe(
                title: "Pasta Salad",
                description: "A fresh pasta salad",
                image: "pasta.jpg",
                instruction: "Mix ingredients and chill",
                ingredients: [],
                readyInMinutes: 15,
                servings: 4
            )
        ]
        let costs: [Transaction] = []
        let totalCost: Float = 50.0
        let assignedIngredientsList: [Ingredient] = [
            Ingredient(name: "Pasta", isChecked: false, userID: UUID(), amount: "500g"),
            Ingredient(name: "Olive Oil", isChecked: true, userID: UUID(), amount: "2 tbsp")
        ]

        let event = Event(
            id: eventID,
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
        let eventDictionary = event.toDictionary()
        let recreatedEvent = Event(dictionary: eventDictionary)

        // Assert
        XCTAssertNotNil(recreatedEvent)
        XCTAssertEqual(event, recreatedEvent)
    }
}
