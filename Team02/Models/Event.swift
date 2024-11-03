import Foundation

struct Event: Identifiable, Equatable {
    let id: UUID
    let invitedFriends: [User]
    let recipes: [Recipe]
    let date: Date
    let startTime: Date
    let endTime: Date
    let location: String
    let eventName: String
    let qrCode: String
    let costs: [Transaction]
    var totalCost: Float
    var assignedIngredientsList: [Ingredient]

    init(
        id: UUID = UUID(),
        invitedFriends: [User],
        recipes: [Recipe],
        date: Date,
        startTime: Date,
        endTime: Date,
        location: String,
        eventName: String,
        qrCode: String,
        costs: [Transaction],
        totalCost: Float,
        assignedIngredientsList: [Ingredient]
    ) {
        self.id = id
        self.invitedFriends = invitedFriends
        self.recipes = recipes
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
        self.location = location
        self.eventName = eventName
        self.qrCode = qrCode
        self.costs = costs
        self.totalCost = totalCost
        self.assignedIngredientsList = assignedIngredientsList
    }

    init?(dictionary: [String: Any]) {
        guard let idString = dictionary["id"] as? String,
              let id = UUID(uuidString: idString),
              let eventName = dictionary["eventName"] as? String,
              let date = dictionary["date"] as? TimeInterval,
              let startTime = dictionary["startTime"] as? TimeInterval,
              let endTime = dictionary["endTime"] as? TimeInterval,
              let location = dictionary["location"] as? String,
              let qrCode = dictionary["qrCode"] as? String,
              let totalCost = dictionary["totalCost"] as? Float else { return nil }

        self.id = id
        self.eventName = eventName
        self.date = Date(timeIntervalSince1970: date)
        self.startTime = Date(timeIntervalSince1970: startTime)
        self.endTime = Date(timeIntervalSince1970: endTime)
        self.location = location
        self.qrCode = qrCode
        self.totalCost = totalCost
        self.invitedFriends = [] // Placeholder, modify as needed
        self.recipes = [] // Placeholder, modify as needed
        self.costs = [] // Placeholder, modify as needed
        self.assignedIngredientsList = [] // Placeholder, modify as needed
    }

    func toDictionary() -> [String: Any] {
        return [
            "id": id.uuidString,
            "eventName": eventName,
            "date": date.timeIntervalSince1970,
            "startTime": startTime.timeIntervalSince1970,
            "endTime": endTime.timeIntervalSince1970,
            "location": location,
            "qrCode": qrCode,
            "totalCost": totalCost
        ]
    }
  
    static func ==(lhs: Event, rhs: Event) -> Bool {
          return lhs.id == rhs.id
    }
}
