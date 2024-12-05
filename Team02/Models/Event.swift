import Foundation

struct Event: Identifiable, Equatable, Hashable {
    let id: UUID
    var invitedFriends: [String]
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
        invitedFriends: [String] = [],
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
              let totalCost = dictionary["totalCost"] as? Float else {
            print("❌ Failed to parse event basic data")
            return nil
        }

        self.id = id
        self.eventName = eventName
        self.date = Date(timeIntervalSince1970: date)
        self.startTime = Date(timeIntervalSince1970: startTime)
        self.endTime = Date(timeIntervalSince1970: endTime)
        self.location = location
        self.qrCode = qrCode
        self.totalCost = totalCost
        
        // Parse invited friends
        self.invitedFriends = dictionary["invitedFriends"] as? [String] ?? []
        
        // Parse recipes
        if let recipesData = dictionary["recipes"] as? [[String: Any]] {
            print("📱 Found \(recipesData.count) recipes in event data")
            self.recipes = recipesData.compactMap { recipeDict in
                guard let title = recipeDict["title"] as? String,
                      let description = recipeDict["description"] as? String,
                      let image = recipeDict["image"] as? String,
                      let instruction = recipeDict["instruction"] as? String,
                      let readyInMinutes = recipeDict["readyInMinutes"] as? Int,
                      let servings = recipeDict["servings"] as? Int else {
                    print("❌ Failed to parse recipe: \(recipeDict)")
                    return nil
                }
                
                return Recipe(
                    title: title,
                    description: description,
                    image: image,
                    instruction: instruction,
                    ingredients: [], // You can parse ingredients if needed
                    readyInMinutes: readyInMinutes,
                    servings: servings
                )
            }
            print("✅ Successfully parsed \(self.recipes.count) recipes")
        } else {
            self.recipes = []
            print("ℹ️ No recipes found in event data")
        }
        
        // Parse costs (placeholder for now)
        self.costs = []
        
        // Parse assigned ingredients list
        if let ingredientsData = dictionary["assignedIngredientsList"] as? [[String: Any]] {
            self.assignedIngredientsList = ingredientsData.compactMap { ingredientDict in
                guard let name = ingredientDict["name"] as? String,
                      let amount = ingredientDict["amount"] as? String,
                      let isChecked = ingredientDict["isChecked"] as? Bool,
                      let userIDString = ingredientDict["userID"] as? String,
                      let userID = UUID(uuidString: userIDString) else {
                        return Ingredient(
                            name: "Unknown",
                            isChecked: false,
                            userID: UUID(),
                            amount: "0"
                        )
                      }
                
              return Ingredient(
                  name: name,
                  isChecked: isChecked,
                  userID: userID,
                  amount: amount
              )
            }
        } else {
            self.assignedIngredientsList = []
        }
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
            "totalCost": totalCost,
            "invitedFriends": invitedFriends,
            // Add recipes array
            "recipes": recipes.map { recipe in
                [
                    "title": recipe.title,
                    "description": recipe.description,
                    "image": recipe.image,
                    "instruction": recipe.instruction,
                    "readyInMinutes": recipe.readyInMinutes,
                    "servings": recipe.servings,
                    "ingredients": recipe.ingredients.map { $0.toDictionary() }
                ]
            },
            // Add assigned ingredients list
            "assignedIngredientsList": assignedIngredientsList.map { ingredient in
                [
                    "name": ingredient.name,
                    "amount": ingredient.amount,
                    "isChecked": ingredient.isChecked,
                    "userID": ingredient.userID.uuidString
                ]
            }
        ]
    }
    
    static func ==(lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id
    }
}
