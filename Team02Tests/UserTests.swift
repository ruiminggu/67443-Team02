import XCTest
@testable import Team02 // Replace with your module name

class UserTests: XCTestCase {

    func testUserInitialization() {
        // Arrange
        let userID = UUID()
        let fullName = "John Doe"
        let image = "profile_pic"
        let email = "john.doe@example.com"
        let password = "securepassword"
        let events = ["event1", "event2"]
        let likedRecipes: [Recipe] = [
            Recipe(
                title: "Pasta",
                description: "Delicious pasta recipe",
                image: "pasta.jpg",
                instruction: "Cook pasta and mix sauce",
                ingredients: [],
                readyInMinutes: 30,
                servings: 4
            )
        ]

        // Act
        let user = User(
            id: userID,
            fullName: fullName,
            image: image,
            email: email,
            password: password,
            events: events,
            likedRecipes: likedRecipes
        )

        // Assert
        XCTAssertEqual(user.id, userID)
        XCTAssertEqual(user.fullName, fullName)
        XCTAssertEqual(user.image, image)
        XCTAssertEqual(user.email, email)
        XCTAssertEqual(user.password, password)
        XCTAssertEqual(user.events, events)
        XCTAssertEqual(user.likedRecipes, likedRecipes)
    }

    func testUserEquality() {
        // Arrange
        let userID = UUID()
        let user1 = User(
            id: userID,
            fullName: "John Doe",
            image: "profile_pic",
            email: "john.doe@example.com",
            password: "password",
            events: [],
            likedRecipes: []
        )
        let user2 = User(
            id: userID, // Same ID for equality
            fullName: "John Doe",
            image: "profile_pic",
            email: "john.doe@example.com",
            password: "password",
            events: [],
            likedRecipes: []
        )

        // Act & Assert
        XCTAssertEqual(user1, user2)
    }

    func testUserInequality() {
        // Arrange
        let user1 = User(
            id: UUID(),
            fullName: "John Doe",
            image: "profile_pic",
            email: "john.doe@example.com",
            password: "password",
            events: [],
            likedRecipes: []
        )
        let user2 = User(
            id: UUID(), // Different ID
            fullName: "Jane Doe",
            image: "profile_pic",
            email: "jane.doe@example.com",
            password: "password123",
            events: [],
            likedRecipes: []
        )

        // Act & Assert
        XCTAssertNotEqual(user1, user2)
    }

    func testUserSerialization() {
        // Arrange
        let userID = UUID()
        let fullName = "John Doe"
        let image = "profile_pic"
        let email = "john.doe@example.com"
        let password = "securepassword"
        let events = ["event1", "event2"]
        let likedRecipes: [Recipe] = [
            Recipe(
                title: "Pasta",
                description: "Delicious pasta recipe",
                image: "pasta.jpg",
                instruction: "Cook pasta and mix sauce",
                ingredients: [],
                readyInMinutes: 30,
                servings: 4
            )
        ]

        let user = User(
            id: userID,
            fullName: fullName,
            image: image,
            email: email,
            password: password,
            events: events,
            likedRecipes: likedRecipes
        )

        // Act
        let userDictionary = user.toDictionary()
        let recreatedUser = User(dictionary: userDictionary)

        // Assert
        XCTAssertNotNil(recreatedUser)
        XCTAssertEqual(user, recreatedUser)
    }

    func testUserInitializationFromInvalidDictionary() {
        // Arrange
        let invalidDictionary: [String: Any] = [
            "id": "invalid-uuid", // Invalid UUID format
            "fullName": "John Doe",
            "email": "john.doe@example.com"
        ]

        // Act
        let user = User(dictionary: invalidDictionary)

        // Assert
        XCTAssertNil(user)
    }

    func testUserInitializationFromValidDictionary() {
        // Arrange
        let validDictionary: [String: Any] = [
            "id": UUID().uuidString,
            "fullName": "John Doe",
            "email": "john.doe@example.com",
            "image": "profile_pic",
            "password": "securepassword",
            "events": ["event1", "event2"],
            "likedRecipes": [
                [
                    "title": "Pasta",
                    "description": "Delicious pasta recipe",
                    "image": "pasta.jpg",
                    "instruction": "Cook pasta and mix sauce",
                    "readyInMinutes": 30,
                    "servings": 4
                ]
            ]
        ]

        // Act
        let user = User(dictionary: validDictionary)

        // Assert
        XCTAssertNotNil(user)
        XCTAssertEqual(user?.fullName, "John Doe")
        XCTAssertEqual(user?.email, "john.doe@example.com")
        XCTAssertEqual(user?.likedRecipes.count, 1)
        XCTAssertEqual(user?.likedRecipes.first?.title, "Pasta")
    }
}
