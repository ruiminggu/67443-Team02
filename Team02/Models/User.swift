import Foundation

struct User: Identifiable {
    let id: UUID
    let fullName: String
    let image: String
    let email: String
    let password: String
    let events: [String] // Change this to be an array of event IDs (String)

    init(id: UUID, fullName: String, image: String, email: String, password: String, events: [String]) {
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
              let password = dictionary["password"] as? String,
              let eventsArray = dictionary["events"] as? [String] else { // Parse events as [String]
            return nil
        }

        self.id = id
        self.fullName = fullName
        self.image = image
        self.email = email
        self.password = password
        self.events = eventsArray // Assign the parsed event IDs
    }
  
  func toDictionary() -> [String: Any] {
          return [
              "id": id.uuidString,
              "fullName": fullName,
              "image": image,
              "email": email,
              "password": password,
              // Convert events to dictionary if needed
              "events": events
          ]
      }
}
