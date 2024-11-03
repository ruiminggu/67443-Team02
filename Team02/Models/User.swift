import Foundation

struct User: Identifiable {
    let id: UUID
    let fullName: String
    let image: String
    let email: String
    let password: String
    let events: [Event]

    init(id: UUID, fullName: String, image: String, email: String, password: String, events: [Event]) {
        self.id = id
        self.fullName = fullName
        self.image = image
        self.email = email
        self.password = password
        self.events = events
    }

    init?(dictionary: [String: Any]) {
        guard let idString = dictionary["id"] as? String,
              let id = UUID(uuidString: idString),
              let fullName = dictionary["fullName"] as? String,
              let image = dictionary["image"] as? String,
              let email = dictionary["email"] as? String,
              let password = dictionary["password"] as? String else { return nil }

        // Parsing events if present
        let eventsData = dictionary["events"] as? [[String: Any]] ?? []
        let events = eventsData.compactMap { Event(dictionary: $0) }

        self.id = id
        self.fullName = fullName
        self.image = image
        self.email = email
        self.password = password
        self.events = events
    }
}
