import Foundation

struct User: Identifiable, Equatable {
    let id: UUID
    let fullName: String
    let image: String
    let email: String
    let password: String
    let events: [String] // Array of event IDs

    init(id: UUID, fullName: String, image: String, email: String, password: String, events: [String]) {
        self.id = id
        self.fullName = fullName
        self.image = image
        self.email = email
        self.password = password
        self.events = events
    }

    init?(dictionary: [String: Any]) {
        // Validate and parse the required fields
        guard let idString = dictionary["id"] as? String,
              let id = UUID(uuidString: idString),
              let fullName = dictionary["fullName"] as? String,
              let email = dictionary["email"] as? String else {
            print("Failed to parse User: Missing required fields. Data: \(dictionary)") // Debugging
            return nil
        }

        // Handle optional fields with default values
        let image = dictionary["image"] as? String ?? "default_profile_pic" // Default image if missing
        let password = dictionary["password"] as? String ?? "" // Empty password if missing
        let events = dictionary["events"] as? [String] ?? [] // Empty array for events if missing

        // Assign parsed values
        self.id = id
        self.fullName = fullName
        self.image = image
        self.email = email
        self.password = password
        self.events = events
    }

    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id &&
            lhs.fullName == rhs.fullName &&
            lhs.image == rhs.image &&
            lhs.email == rhs.email &&
            lhs.password == rhs.password &&
            lhs.events == rhs.events
    }

    func toDictionary() -> [String: Any] {
        return [
            "id": id.uuidString,
            "fullName": fullName,
            "image": image,
            "email": email,
            "password": password,
            "events": events
        ]
    }
}
