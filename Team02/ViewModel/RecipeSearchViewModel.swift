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
                  let urlString = "https://api.spoonacular.com/recipes/complexSearch?apiKey=\(apiKey)&query=\(encodedQuery)&number=10"
                  
                  guard let url = URL(string: urlString) else {
                      throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
                  }
                  
                  let (data, _) = try await URLSession.shared.data(from: url)
                  let searchResponse = try JSONDecoder().decode(RecipeSearchResponse.self, from: data)
                  
                  if Task.isCancelled { return }
                  
                  await MainActor.run {
                      self.recipes = searchResponse.results.map { Recipe(apiRecipe: $0) }
                      self.isLoading = false
                  }
                  
                  print("✅ Search completed for: \(searchText)")
              } catch {
                  if Task.isCancelled {
                      print("🚫 Search cancelled for: \(searchText)")
                      return
                  }
                  
                  await MainActor.run {
                      self.error = error.localizedDescription
                      self.isLoading = false
                      print("❌ Search failed: \(error.localizedDescription)")
                  }
              }
          }
      }
  
  func likeRecipe(recipe: Recipe) {
      guard let userID = Auth.auth().currentUser?.uid else {
          print("❌ User not logged in")
          return
      }
      
      // Fetch the user's liked recipes from Firebase
      databaseRef.child("users").child(userID).child("likedRecipes").observeSingleEvent(of: .value) { [weak self] snapshot, _ in
          guard let self = self else { return }
          
          var likedRecipes = snapshot.value as? [[String: Any]] ?? []

          // Check if recipe is already liked
          if likedRecipes.contains(where: { $0["id"] as? String == recipe.id.uuidString }) {
              print("🚫 Recipe already liked")
              return
          }

          // Add recipe to likedRecipes
          let recipeDict: [String: Any] = [
              "id": recipe.id.uuidString,
              "title": recipe.title,
              "image": recipe.image,
              "readyInMinutes": recipe.readyInMinutes,
              "servings": recipe.servings
          ]
          
          likedRecipes.append(recipeDict)
          
          self.databaseRef.child("users").child(userID).child("likedRecipes").setValue(likedRecipes) { error, _ in
              if let error = error {
                  print("❌ Error liking recipe: \(error.localizedDescription)")
              } else {
                  print("✅ Recipe liked successfully!")
              }
          }
      }
  }

  
  func addRecipeToEvent(recipe: Recipe, eventID: String) {
          print("📱 Adding recipe \(recipe.title) to event \(eventID)")
          isLoading = true
          
          databaseRef.child("events").child(eventID).observeSingleEvent(of: .value) { [weak self] snapshot, _ in
              guard let self = self else { return }
              
              if var eventData = snapshot.value as? [String: Any] {
                  // Get current recipes array
                  var recipes = eventData["recipes"] as? [[String: Any]] ?? []
                  
                  // Check if recipe already exists
                  let existingRecipe = recipes.first { recipeDict in
                      guard let title = recipeDict["title"] as? String else { return false }
                      return title == recipe.title
                  }
                  
                  if existingRecipe != nil {
                      DispatchQueue.main.async {
                          self.isLoading = false
                          self.error = "This recipe is already in your menu"
                      }
                      return
                  }
                  
                  let recipeDict: [String: Any] = [
                      "id": recipe.id.uuidString,
                      "title": recipe.title,
                      "description": recipe.description,
                      "image": recipe.image,
                      "instruction": recipe.instruction,
                      "readyInMinutes": recipe.readyInMinutes,
                      "servings": recipe.servings,
                      "ingredients": recipe.ingredients.map { ingredient in
                          [
                              "name": ingredient.name,
                              "amount": ingredient.amount,
                              "unit": ingredient.unit
                          ]
                      }
                  ]
                  
                  recipes.append(recipeDict)
                  eventData["recipes"] = recipes
                  
                  self.databaseRef.child("events").child(eventID).updateChildValues(eventData) { error, _ in
                      DispatchQueue.main.async {
                          self.isLoading = false
                          
                          if let error = error {
                              print("❌ Error adding recipe: \(error.localizedDescription)")
                              self.error = "Failed to add recipe: \(error.localizedDescription)"
                          } else {
                              print("✅ Recipe added successfully!")
                              self.showSuccessAlert = true
                              // Notify that the event needs to be refreshed
                              NotificationCenter.default.post(name: NSNotification.Name("RefreshEventDetail"), object: nil)
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
