//
//  CreateCustomRecipeView.swift
//  Team02
//
//  Created by Xinyi Chen on 12/2/24.
//

import SwiftUI
import PhotosUI
import FirebaseDatabase

struct CreateCustomRecipeView: View {
  let event: Event
  @Environment(\.dismiss) private var dismiss
  @StateObject private var viewModel = CustomRecipeViewModel()
  
  @State private var title = ""
  @State private var instructions = ""
  @State private var ingredients: [(name: String, amount: String)] = [(name: "", amount: "")]
  @State private var servings: String = ""
  @State private var cookingTime: String = ""
  
  var body: some View {
    Form {
      Section(header: Text("Recipe Details")) {
        TextField("Recipe Name", text: $title)
        
        TextEditor(text: $instructions)
          .frame(height: 100)
          .placeholder(when: instructions.isEmpty) {
            Text("Instructions").foregroundColor(.gray)
          }
        
        HStack {
            Text("Servings")
            Spacer()
            TextField("4", text: $servings)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.trailing)
                .frame(width: 100)
        }
        
        HStack {
            Text("Cooking Time (minutes)")
            Spacer()
            TextField("30", text: $cookingTime)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.trailing)
                .frame(width: 100)
        }
      }
      
      Section(header: Text("Ingredients")) {
        ForEach(0..<ingredients.count, id: \.self) { index in
          HStack {
            TextField("Ingredient", text: $ingredients[index].name)
            TextField("Amount", text: $ingredients[index].amount)
          }
        }
        
        Button("Add Ingredient") {
          ingredients.append((name: "", amount: ""))
        }
      }
      
      Section {
        Button("Save Recipe") {
          saveRecipe()
        }
        .disabled(title.isEmpty)
      }
    }
    .navigationTitle("Create Recipe")
    .navigationBarItems(trailing: Button("Cancel") { dismiss() })
  }
  
  private func saveRecipe() {
    let customIngredients = ingredients
      .filter { !$0.name.isEmpty }
      .map { CustomIngredient(id: UUID(), name: $0.name, amount: $0.amount) }
    
    let defaultImageUrl = "https://i.ibb.co/NYwd9bN/customimg.jpg"
    
    let recipe = CustomRecipe(
      title: title,
      creatorId: UUID().uuidString,
      image: defaultImageUrl,
      instructions: instructions,
      ingredients: customIngredients,
      sharedWithEvents: [event.id.uuidString],
      isPrivate: false
    )
    
    // Save to customRecipes node
    viewModel.createCustomRecipe(recipe)
    
    // Update event data
    let databaseRef = Database.database().reference()
    databaseRef.child("events").child(event.id.uuidString).observeSingleEvent(of: .value) { snapshot in
      if var eventData = snapshot.value as? [String: Any] {
        // Create the recipe dictionary
        let recipeDict: [String: Any] = [
          "id": recipe.id.uuidString,
          "title": recipe.title,
          "description": "Custom Recipe",
          "image": defaultImageUrl,
          "instruction": recipe.instructions,
          "readyInMinutes": Int(cookingTime) ?? 30,
          "servings": Int(servings) ?? 4,
          "ingredients": customIngredients.map { ingredient in
            [
              "id": ingredient.id.uuidString,
              "name": ingredient.name,
              "amount": ingredient.amount,
              "isChecked": false,
              "userID": UUID().uuidString
            ]
          }
        ]
        
        // Update recipes array
        var existingRecipes = eventData["recipes"] as? [[String: Any]] ?? []
        existingRecipes.append(recipeDict)
        eventData["recipes"] = existingRecipes
        
        // Update ingredients list
        var existingIngredients = eventData["assignedIngredientsList"] as? [[String: Any]] ?? []
        let formattedIngredients = customIngredients.map { ingredient in
          [
            "id": ingredient.id.uuidString,
            "name": ingredient.name,
            "amount": ingredient.amount,
            "isChecked": false,
            "userID": UUID().uuidString
          ]
        }
        existingIngredients.append(contentsOf: formattedIngredients)
        eventData["assignedIngredientsList"] = existingIngredients
        
        // Update Firebase with both recipes and ingredients
        databaseRef.child("events").child(event.id.uuidString).updateChildValues(eventData) { error, _ in
          if let error = error {
            print("❌ Error saving custom recipe: \(error.localizedDescription)")
          } else {
            print("✅ Custom recipe saved successfully")
            NotificationCenter.default.post(name: NSNotification.Name("RefreshEventDetail"), object: nil)
          }
        }
      }
      
      DispatchQueue.main.async {
        self.dismiss()
      }
    }
  }
}

// Helper extension for placeholder text
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
