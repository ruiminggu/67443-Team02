import Foundation

struct User: Identifiable, Equatable {
    let id: UUID
    let fullName: String
    let image: String
    let email: String
    let password: String
    let events: [String] // Array of event IDs
    var likedRecipes: [Recipe] // Array of liked `Recipe` objects

    init(
        id: UUID,
        fullName: String,
        image: String,
        email: String,
        password: String,
        events: [String],
        likedRecipes: [Recipe] = []
    ) {
        self.id = id
        self.fullName = fullName
        self.image = image
        self.email = email
        self.password = password
        self.events = events
        self.likedRecipes = likedRecipes
    }

    init?(dictionary: [String: Any]) {
        guard let idString = dictionary["id"] as? String,
              let id = UUID(uuidString: idString),
              let fullName = dictionary["fullName"] as? String,
              let email = dictionary["email"] as? String else {
            print("❌ Failed to parse User: Missing required fields. Data: \(dictionary)")
            return nil
        }

        self.id = id
        self.fullName = fullName
        self.image = dictionary["image"] as? String ?? "default_profile_pic"
        self.email = email
        self.password = dictionary["password"] as? String ?? ""
        self.events = dictionary["events"] as? [String] ?? []

        // Parse liked recipes
        if let likedRecipesData = dictionary["likedRecipes"] as? [[String: Any]] {
            self.likedRecipes = likedRecipesData.compactMap { recipeDict in
                guard let title = recipeDict["title"] as? String,
                      let description = recipeDict["description"] as? String,
                      let image = recipeDict["image"] as? String,
                      let instruction = recipeDict["instruction"] as? String,
                      let readyInMinutes = recipeDict["readyInMinutes"] as? Int,
                      let servings = recipeDict["servings"] as? Int else {
                    print("❌ Failed to parse liked recipe: \(recipeDict)")
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
            print("✅ Successfully parsed \(self.likedRecipes.count) liked recipes")
        } else {
            self.likedRecipes = []
            print("ℹ️ No liked recipes found for the user")
        }
    }

    func toDictionary() -> [String: Any] {
        return [
            "id": id.uuidString,
            "fullName": fullName,
            "image": image,
            "email": email,
            "password": password,
            "events": events,
            "likedRecipes": likedRecipes.map { recipe in
                [
                    "title": recipe.title,
                    "description": recipe.description,
                    "image": recipe.image,
                    "instruction": recipe.instruction,
                    "readyInMinutes": recipe.readyInMinutes,
                    "servings": recipe.servings,
                    "ingredients": recipe.ingredients.map { $0.toDictionary() }
                ]
            }
        ]
    }

    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}
