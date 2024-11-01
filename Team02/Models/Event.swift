import Foundation

struct Event: Identifiable {
    let id: UUID
    let invitedFriends: [User]
    let recipes: [Recipe]
    let date: Date
    let time: Date
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
        time: Date,
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
        self.time = time
        self.location = location
        self.eventName = eventName
        self.qrCode = qrCode
        self.costs = costs
        self.totalCost = totalCost
        self.assignedIngredientsList = assignedIngredientsList
    }
}
