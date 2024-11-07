import XCTest
@testable import Team02

final class UserTests: XCTestCase {
    
    func testUserInitializationFromValidDictionary() {
        let validUserData: [String: Any] = [
            "id": "8E23D734-2FBE-4D1E-99F7-00279E19585B",
            "fullName": "Charlie Brown",
            "image": "profile_pic",
            "email": "charlie@example.com",
            "password": "password789",
            "events": ["eventID1", "eventID2"]
        ]
        
        let user = User(dictionary: validUserData)
        
        XCTAssertNotNil(user)
        XCTAssertEqual(user?.id.uuidString, "8E23D734-2FBE-4D1E-99F7-00279E19585B")
        XCTAssertEqual(user?.fullName, "Charlie Brown")
        XCTAssertEqual(user?.email, "charlie@example.com")
        XCTAssertEqual(user?.events, ["eventID1", "eventID2"])
    }
    
    func testUserInitializationFromInvalidDictionary() {
        let invalidUserData: [String: Any] = [
            "id": "InvalidUUID",
            "fullName": "Charlie Brown"
            // Missing other required fields
        ]
        
        let user = User(dictionary: invalidUserData)
        
        XCTAssertNil(user)
    }
  
  func testToDictionary() {
      // Arrange
      let userID = UUID()
      let fullName = "John Doe"
      let image = "profile_pic"
      let email = "john@example.com"
      let password = "password123"
      let events = ["event1", "event2"]
      
      let user = User(id: userID, fullName: fullName, image: image, email: email, password: password, events: events)
      
      // Act
      let dictionary = user.toDictionary()
      
      // Assert
      XCTAssertEqual(dictionary["fullName"] as? String, fullName)
      XCTAssertEqual(dictionary["image"] as? String, image)
      XCTAssertEqual(dictionary["email"] as? String, email)
      XCTAssertEqual(dictionary["password"] as? String, password)
      XCTAssertEqual(dictionary["events"] as? [String], events)
  }
}
