import XCTest
@testable import Team02

class TransactionTests: XCTestCase {

    func testTransactionInitialization() {
        // Arrange: Create mock data for the test
        let mockPayer = User(id: UUID(), fullName: "John Doe", image: "profile_pic1", email: "john@example.com", password: "password123", events: ["event1"])
        let mockPayee = User(id: UUID(), fullName: "Jane Doe", image: "profile_pic2", email: "jane@example.com", password: "password456", events: ["event2"])
        
        let mockEvent = Event(
            id: UUID(),
            invitedFriends: ["friend1", "friend2"],
            recipes: [],
            date: Date(),
            startTime: Date(),
            endTime: Date().addingTimeInterval(3600),
            location: "123 Event Place",
            eventName: "Birthday Party",
            qrCode: "sampleQRCode",
            costs: [],
            totalCost: 100.0,
            assignedIngredientsList: []
        )
        
        let item = "Gift"
        let amount: Float = 50.0
        
        // Act: Initialize the transaction
        let transaction = Transaction(payer: mockPayer, payee: mockPayee, item: item, amount: amount, event: mockEvent)
        
        // Assert: Verify that the properties are correctly set
        XCTAssertEqual(transaction.payer, mockPayer, "Payer should be set correctly")
        XCTAssertEqual(transaction.payee, mockPayee, "Payee should be set correctly")
        XCTAssertEqual(transaction.item, item, "Item should be set correctly")
        XCTAssertEqual(transaction.amount, amount, "Amount should be set correctly")
        XCTAssertEqual(transaction.event, mockEvent, "Event should be set correctly")
    }
    
    func testTransactionEquality() {
        // Arrange
        let id = UUID()
        let mockPayer = User(id: UUID(), fullName: "John Doe", image: "profile_pic1", email: "john@example.com", password: "password123", events: ["event1"])
        let mockPayee = User(id: UUID(), fullName: "Jane Doe", image: "profile_pic2", email: "jane@example.com", password: "password456", events: ["event2"])
        let mockEvent = Event(
            id: UUID(),
            invitedFriends: ["friend1", "friend2"],
            recipes: [],
            date: Date(),
            startTime: Date(),
            endTime: Date().addingTimeInterval(3600),
            location: "123 Event Place",
            eventName: "Birthday Party",
            qrCode: "sampleQRCode",
            costs: [],
            totalCost: 100.0,
            assignedIngredientsList: []
        )
        
        let item = "Gift"
        let amount: Float = 50.0

        // Act
        let transaction1 = Transaction(id: id, payer: mockPayer, payee: mockPayee, item: item, amount: amount, event: mockEvent)
        let transaction2 = Transaction(id: id, payer: mockPayer, payee: mockPayee, item: item, amount: amount, event: mockEvent)

        // Assert
        XCTAssertEqual(transaction1, transaction2, "Two transactions with the same data should be equal")
    }

}
