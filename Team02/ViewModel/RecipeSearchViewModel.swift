//
//  RecipeSearchViewModel.swift
//  Team02
//
//  Created by Xinyi Chen on 11/4/24.
//

import SwiftUI
import Foundation
import Firebase
import FirebaseAuth

class RecipeSearchViewModel: ObservableObject {
  @Published var recipes: [Recipe] = []
  @Published var isLoading = false
  @Published var searchText = ""
  @Published var error: String?
  @Published var showSuccessAlert = false
  
  private var databaseRef: DatabaseReference = Database.database().reference()
  private var searchTask: Task<Void, Never>?
  private let apiKey = "efc5ce03c31944868cad1cf4fb972a26"
  
  
  struct RecipeDetailResponse: Codable {
    let instructions: String?
    let extendedIngredients: [APIIngredient]
  }
  
  struct APIIngredient: Codable {
    let name: String
    let measures: Measures
  }
  
  struct Measures: Codable {
    let us: UnitMeasure
  }
  
  struct UnitMeasure: Codable {
    let amount: Double
    let unitShort: String
  }
  
  
  func searchRecipes() async {
    // Cancel any existing search task
    searchTask?.cancel()
    
    guard !searchText.isEmpty else {
      await MainActor.run {
        self.recipes = []
      }
      return
    }
    
    searchTask = Task {
      await MainActor.run {
        self.isLoading = true
        self.error = nil
      }
      
      do {
        let encodedQuery = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let searchUrl = "https://api.spoonacular.com/recipes/complexSearch?apiKey=\(apiKey)&query=\(encodedQuery)&number=10"
        
        guard let url = URL(string: searchUrl) else { throw NSError(domain: "", code: -1) }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let searchResponse = try JSONDecoder().decode(RecipeSearchResponse.self, from: data)
        
        let recipes = try await withThrowingTaskGroup(of: Recipe.self) { group in
          var results: [Recipe] = []
          
          for apiRecipe in searchResponse.results {
            group.addTask {
              let detailUrl = "https://api.spoonacular.com/recipes/\(apiRecipe.id)/information?apiKey=\(self.apiKey)"
              guard let url = URL(string: detailUrl) else { throw NSError(domain: "", code: -1) }
              
              let (detailData, _) = try await URLSession.shared.data(from: url)
              let recipeDetail = try JSONDecoder().decode(RecipeDetailResponse.self, from: detailData)
              
              let ingredients = recipeDetail.extendedIngredients.map { ingredient in
                Ingredient(
                  name: ingredient.name,
                  isChecked: false,
                  userID: UUID(),
                  amount: "\(ingredient.measures.us.amount) \(ingredient.measures.us.unitShort)"
                )
              }
              
              return Recipe(
                apiRecipe: apiRecipe,
                ingredients: ingredients,
                instructions: recipeDetail.instructions ?? ""
              )
            }
          }
          
          for try await recipe in group {
            results.append(recipe)
          }
          
          return results
        }
        
        await MainActor.run {
          self.recipes = recipes
          self.isLoading = false
        }
        
      } catch {
        await MainActor.run {
          self.error = error.localizedDescription
          self.isLoading = false
          print("❌ Search failed: \(error.localizedDescription)")
        }
      }
    }
  }
  
  func likeRecipe(recipe: Recipe, userID: String) {
    print("📱 Adding recipe \(recipe.title) to liked recipes for user \(userID)")
    isLoading = true
    
    // Reference to the user's likedRecipes node
    let likedRecipesRef = databaseRef.child("users").child(userID).child("likedRecipes")
    
    likedRecipesRef.observeSingleEvent(of: .value) { [weak self] snapshot in
      guard let self = self else { return }
      
      var likedRecipes = snapshot.value as? [[String: Any]] ?? []
      
      // Check if the recipe is already liked
      if likedRecipes.contains(where: { $0["id"] as? String == recipe.id.uuidString }) {
        DispatchQueue.main.async {
          self.isLoading = false
          self.error = "This recipe is already liked"
          print("❌ Recipe is already liked.")
        }
        return
      }
      
      // Add the new recipe
      let recipeDict: [String: Any] = [
        "id": recipe.id.uuidString,
        "title": recipe.title,
        "description": recipe.description,
        "image": recipe.image,
        "instruction": recipe.instruction,
        "readyInMinutes": recipe.readyInMinutes,
        "servings": recipe.servings
      ]
      
      likedRecipes.append(recipeDict)
      
      // Update Firebase with the modified likedRecipes
      likedRecipesRef.setValue(likedRecipes) { error, _ in
        DispatchQueue.main.async {
          self.isLoading = false
          
          if let error = error {
            print("❌ Error liking recipe: \(error.localizedDescription)")
            self.error = "Failed to like recipe: \(error.localizedDescription)"
          } else {
            print("✅ Recipe liked successfully!")
            self.showSuccessAlert = true
          }
        }
      }
    }
  }
  
  
  
  func addRecipeToEvent(recipe: Recipe, eventID: String) {
    print("📱 Adding recipe \(recipe.title) to event \(eventID)")
    isLoading = true
        
    databaseRef.child("events").child(eventID).child("recipes").observeSingleEvent(of: .value) { [weak self] snapshot in
      guard let self = self else { return }
      
      let recipes = snapshot.value as? [[String: Any]] ?? []
      if recipes.contains(where: { ($0["title"] as? String) == recipe.title }) {
        DispatchQueue.main.async {
          self.isLoading = false
          self.error = "This recipe is already in your menu"
        }
        return
      }
      
      // Continue with fetching recipe details and adding
      let urlString = "https://api.spoonacular.com/recipes/\(recipe.apiId)/information?apiKey=\(self.apiKey)"
      guard let url = URL(string: urlString) else {
        self.error = "Invalid URL"
        return
      }
      
      guard let url = URL(string: urlString) else {
        self.error = "Invalid URL"
        return
      }
      
      URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
        guard let self = self,
              let data = data,
              let recipeDetails = try? JSONDecoder().decode(RecipeDetailResponse.self, from: data) else {
          DispatchQueue.main.async {
            self?.error = error?.localizedDescription ?? "Failed to fetch recipe details"
            self?.isLoading = false
          }
          return
        }
        
        print("📱 Fetched ingredients for \(recipe.title):")
        let ingredients = recipeDetails.extendedIngredients.map { apiIngredient in
          print("- \(apiIngredient.name): \(apiIngredient.measures.us.amount) \(apiIngredient.measures.us.unitShort)")
          return Ingredient(
            name: apiIngredient.name,
            isChecked: false,
            userID: UUID(),
            amount: "\(apiIngredient.measures.us.amount) \(apiIngredient.measures.us.unitShort)"
          )
        }
        
        self.databaseRef.child("events").child(eventID).observeSingleEvent(of: .value) { snapshot, _ in
          if var eventData = snapshot.value as? [String: Any] {
            var recipes = eventData["recipes"] as? [[String: Any]] ?? []
            let recipeDict: [String: Any] = [
              "id": recipe.id.uuidString,
              "title": recipe.title,
              "description": recipe.description,
              "image": recipe.image,
              "instruction": recipeDetails.instructions ?? "",
              "readyInMinutes": recipe.readyInMinutes,
              "servings": recipe.servings,
              "ingredients": ingredients.map { $0.toDictionary() }
            ]
            
            recipes.append(recipeDict)
            
            // Update ingredients list
            var existingIngredients = eventData["assignedIngredientsList"] as? [[String: Any]] ?? []
            existingIngredients.append(contentsOf: ingredients.map { $0.toDictionary() })
            
            eventData["recipes"] = recipes
            eventData["assignedIngredientsList"] = existingIngredients
            
            self.databaseRef.child("events").child(eventID).updateChildValues(eventData) { error, _ in
              DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                  self.error = error.localizedDescription
                } else {
                  self.showSuccessAlert = true
                  NotificationCenter.default.post(name: NSNotification.Name("RefreshEventDetail"), object: nil)
                }
              }
            }
          }
        }
  }.resume()
      
//      databaseRef.child("events").child(eventID).observeSingleEvent(of: .value) { [weak self] snapshot, _ in
//        guard let self = self else { return }
//        
//        if var eventData = snapshot.value as? [String: Any] {
//          // Get current recipes array
//          var recipes = eventData["recipes"] as? [[String: Any]] ?? []
//          
//          // Check if recipe already exists
//          let existingRecipe = recipes.first { recipeDict in
//            guard let title = recipeDict["title"] as? String else { return false }
//            return title == recipe.title
//          }
//          
//          if existingRecipe != nil {
//            DispatchQueue.main.async {
//              self.isLoading = false
//              self.error = "This recipe is already in your menu"
//            }
//            return
//          }
//          
//          let recipeDict: [String: Any] = [
//            "id": recipe.id.uuidString,
//            "title": recipe.title,
//            "description": recipe.description,
//            "image": recipe.image,
//            "instruction": recipe.instruction,
//            "readyInMinutes": recipe.readyInMinutes,
//            "servings": recipe.servings,
//            "ingredients": recipe.ingredients.map { ingredient in
//              [
//                "name": ingredient.name,
//                "amount": ingredient.amount,
//                "unit": ingredient.unit
//              ]
//            }
//          ]
//          
//          recipes.append(recipeDict)
//          eventData["recipes"] = recipes
//          
//          self.databaseRef.child("events").child(eventID).updateChildValues(eventData) { error, _ in
//            DispatchQueue.main.async {
//              self.isLoading = false
//              
//              if let error = error {
//                print("❌ Error adding recipe: \(error.localizedDescription)")
//                self.error = "Failed to add recipe: \(error.localizedDescription)"
//              } else {
//                print("✅ Recipe added successfully!")
//                self.showSuccessAlert = true
//                // Notify that the event needs to be refreshed
//                NotificationCenter.default.post(name: NSNotification.Name("RefreshEventDetail"), object: nil)
//              }
//            }
//          }
//        } else {
//          DispatchQueue.main.async {
//            self.isLoading = false
//            self.error = "Failed to fetch event data"
//          }
//        }
//      }
    }
  }
}
