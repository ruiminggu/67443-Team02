//
//  CustomRecipeViewModel.swift
//  Team02
//
//  Created by Xinyi Chen on 12/2/24.
//
import Foundation
import FirebaseFirestore
import FirebaseDatabase

class CustomRecipeViewModel: ObservableObject {
    @Published var customRecipes: [CustomRecipe] = []
    @Published var isLoading = false
    @Published var error: String?
    private var databaseRef = Database.database().reference()
    
    func createCustomRecipe(_ recipe: CustomRecipe) {
        isLoading = true
        let recipeRef = databaseRef.child("customRecipes").child(recipe.id.uuidString)
        
        recipeRef.setValue(recipe.toDictionary()) { error, _ in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    self.error = error.localizedDescription
                }
            }
        }
    }
    
    func fetchCustomRecipes(for eventId: String) {
        isLoading = true
        
        databaseRef.child("customRecipes")
            .queryOrdered(byChild: "sharedWithEvents")
            .queryEqual(toValue: eventId)
            .observeSingleEvent(of: .value) { [weak self] snapshot in
                guard let self = self,
                      let recipesData = snapshot.value as? [String: [String: Any]] else {
                    self?.isLoading = false
                    return
                }
                
                self.customRecipes = recipesData.compactMap { (_, data) in
                    guard let title = data["title"] as? String,
                          let creatorId = data["creatorId"] as? String,
                          let instructions = data["instructions"] as? String,
                          let ingredientsData = data["ingredients"] as? [[String: Any]],
                          let sharedWithEvents = data["sharedWithEvents"] as? [String],
                          let isPrivate = data["isPrivate"] as? Bool else {
                        return nil
                    }
                    
                    let ingredients = ingredientsData.compactMap { ingredientData -> CustomIngredient? in
                        guard let name = ingredientData["name"] as? String,
                              let amount = ingredientData["amount"] as? String else {
                            return nil
                        }
                        return CustomIngredient(id: UUID(), name: name, amount: amount)
                    }
                    
                    return CustomRecipe(
                        title: title,
                        creatorId: creatorId,
                        image: data["image"] as? String,
                        instructions: instructions,
                        ingredients: ingredients,
                        sharedWithEvents: sharedWithEvents,
                        isPrivate: isPrivate
                    )
                }
                
                self.isLoading = false
            }
    }
}
