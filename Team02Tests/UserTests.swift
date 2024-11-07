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
}
