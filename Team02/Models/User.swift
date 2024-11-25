import Foundation

struct User: Identifiable, Equatable {
    let id: UUID
    let fullName: String
    let image: String
    let email: String
    let password: String
    let events: [String] // Array of event IDs
    var likedRecipes: [UUID] // Array of liked recipe IDs

    init(id: UUID, fullName: String, image: String, email: String, password: String, events: [String], likedRecipes: [UUID] = []) {
        self.id = id
        self.fullName = fullName
        self.image = image
        self.email = email
        self.password = password
        self.events = events
        self.likedRecipes = likedRecipes
    }

    init?(dictionary: [String: Any]) {
        // Validate and parse the required fields
        guard let idString = dictionary["id"] as? String,
              let id = UUID(uuidString: idString),
              let fullName = dictionary["fullName"] as? String,
              let email = dictionary["email"] as? String else {
            print("Failed to parse User: Missing required fields. Data: \(dictionary)")
            return nil
        }

        // Handle optional fields with default values
        let image = dictionary["image"] as? String ?? "default_profile_pic"
        let password = dictionary["password"] as? String ?? ""
        let events = dictionary["events"] as? [String] ?? []
        let likedRecipes = (dictionary["likedRecipes"] as? [String])?.compactMap { UUID(uuidString: $0) } ?? []

        // Assign parsed values
        self.id = id
        self.fullName = fullName
        self.image = image
        self.email = email
        self.password = password
        self.events = events
        self.likedRecipes = likedRecipes
    }

    func toDictionary() -> [String: Any] {
        return [
            "id": id.uuidString,
            "fullName": fullName,
            "image": image,
            "email": email,
            "password": password,
            "events": events,
            "likedRecipes": likedRecipes.map { $0.uuidString }
        ]
    }

    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id &&
            lhs.fullName == rhs.fullName &&
            lhs.image == rhs.image &&
            lhs.email == rhs.email &&
            lhs.password == rhs.password &&
            lhs.events == rhs.events &&
            lhs.likedRecipes == rhs.likedRecipes
    }
}

