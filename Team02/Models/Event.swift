import Foundation

struct Event: Identifiable {
    let id: UUID
    let users: [User]
    let recipes: [Recipe]
    let date: Date
    let time: Date
    let location: String
    let eventName: String
    let qrCode: String
    let costs: [Transaction]
    var totalCost: Float
    var assignedIngredientsList: [Ingredient] // Make this mutable to allow toggling

    init(
        id: UUID = UUID(),
        users: [User],
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
        self.users = users
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
