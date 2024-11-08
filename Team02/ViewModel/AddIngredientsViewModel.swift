//
//  AddIngredientsViewModel.swift
//  Team02
//
//  Created by Xinyi Chen on 11/8/24.
//

import Foundation
import SwiftUI
import Firebase

class AddIngredientsViewModel: ObservableObject {
    @Published var ingredientName = ""
    @Published var amount: String = ""
    @Published var isLoading = false
    @Published var error: String?
    @Published var showSuccessAlert = false
    
    private var databaseRef: DatabaseReference = Database.database().reference()
    
    func addIngredientToEvent(eventID: String, userID: UUID) {
        guard !ingredientName.isEmpty else {
            error = "Please enter ingredient name"
            return
        }
        
        guard let amountFloat = Float(amount) else {
            error = "Please enter a valid amount"
            return
        }
        
        isLoading = true
        
        // Create new ingredient
        let ingredient = Ingredient(
            name: ingredientName,
            unit: 1.0, // Default unit
            isChecked: false,
            userID: userID,
            amount: amountFloat
        )
        
        // Convert to dictionary for Firebase
        let ingredientDict: [String: Any] = [
            "id": ingredient.id.uuidString,
            "name": ingredient.name,
            "unit": ingredient.unit,
            "isChecked": ingredient.isChecked,
            "userID": ingredient.userID.uuidString,
            "amount": ingredient.amount
        ]
        
        // Update event in Firebase
        databaseRef.child("events").child(eventID).observeSingleEvent(of: .value) { [weak self] snapshot, _ in
            guard let self = self else { return }
            
            if var eventData = snapshot.value as? [String: Any] {
                // Get current ingredients array or create new one
                var ingredients = eventData["assignedIngredientsList"] as? [[String: Any]] ?? []
                
                // Check for duplicate
                let isDuplicate = ingredients.contains { dict in
                    guard let name = dict["name"] as? String else { return false }
                    return name.lowercased() == ingredient.name.lowercased()
                }
                
                if isDuplicate {
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.error = "This ingredient is already in the list"
                    }
                    return
                }
                
                // Add new ingredient
                ingredients.append(ingredientDict)
                eventData["assignedIngredientsList"] = ingredients
                
                // Save to Firebase
                self.databaseRef.child("events").child(eventID).updateChildValues(eventData) { error, _ in
                    DispatchQueue.main.async {
                        self.isLoading = false
                        
                        if let error = error {
                            self.error = "Failed to save ingredient: \(error.localizedDescription)"
                        } else {
                            self.showSuccessAlert = true
                            // Reset form
                            self.ingredientName = ""
                            self.amount = ""
                            
                            // Notify that event needs to be refreshed
                            NotificationCenter.default.post(
                                name: NSNotification.Name("RefreshEventDetail"),
                                object: nil
                            )
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.error = "Failed to fetch event data"
                }
            }
        }
    }
}
