//
//  RecipeDetailView.swift
//  Team02
//
//  Created by Xinyi Chen on 12/1/24.
//

import SwiftUI

struct RecipeDetailNavigationView: View {
    let recipe: Recipe
    let event: Event
    @StateObject private var viewModel = RecipeSearchViewModel()
    @State private var currentImageIndex = 0
    @State private var showAllIngredients = false
    @State private var showAllInstructions = false
    private let maxInitialIngredients = 5
    private let maxInstructionLength = 150
  
    private var isRecipeInEvent: Bool {
        event.recipes.contains(where: { $0.title == recipe.title })
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Image Gallery
                ZStack(alignment: .bottomLeading) {
                    AsyncImage(url: URL(string: recipe.image)) { phase in
                        switch phase {
                        case .success(let image):
                          image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 250)
                            .clipped()
                        case .failure:
                            Color.gray
                        case .empty:
                            ProgressView()
                        @unknown default:
                            Color.gray
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 20) {
                    // Title and Rating
                    HStack {
                        Text(recipe.title)
                            .font(.title)
                            .fontWeight(.bold)
                        Spacer()
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.orange)
                            Text(String(format: "%.1f", recipe.rating))
                                .fontWeight(.semibold)
                        }
                    }
                    
                    // Date and Time
                    HStack {
                        Text("13 December 2024")
                            .foregroundColor(.gray)
                        Spacer()
                        Image(systemName: "clock")
                            .foregroundColor(.gray)
                        Text("\(recipe.readyInMinutes) Minutes")
                            .foregroundColor(.gray)
                    }
                    
                    // Tags
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(["Asian", "Indonesian", "Rice", "Oriental"], id: \.self) { tag in
                                Text(tag)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.orange.opacity(0.1))
                                    .foregroundColor(.orange)
                                    .cornerRadius(15)
                            }
                        }
                    }
                    
                    // Ingredients
                  VStack(alignment: .leading, spacing: 16) {
                      Text("Ingredients")
                          .font(.title2)
                          .fontWeight(.bold)
                          .padding(.horizontal)
                      
                      VStack(spacing: 0) {
                        let displayedIngredients = showAllIngredients
                                    ? recipe.ingredients
                                    : Array(recipe.ingredients.prefix(maxInitialIngredients))
                        
                        VStack(spacing: 0) {  // Added a VStack to manage the ingredients list
                            ForEach(displayedIngredients) { ingredient in
                                HStack {
                                    Text(ingredient.name)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Text(ingredient.amount)
                                        .foregroundColor(.black)
                                        .fontWeight(.medium)
                                }
                                .padding(.vertical, 16)
                                .padding(.horizontal)
                                .background(Color.white)
                                
                                if ingredient.id != displayedIngredients.last?.id {  // Only show divider if not last item
                                    Divider()
                                        .padding(.horizontal)
                                }
                            }
                        }
                        .animation(.default, value: displayedIngredients)
                          
                        if recipe.ingredients.count > maxInitialIngredients {
                            Button(action: {
                                withAnimation {
                                    showAllIngredients.toggle()
//                                    print("Show all ingredients: \(showAllIngredients)")
//                                    print("Total ingredients: \(recipe.ingredients.count)")
//                                    print("Currently showing: \(displayedIngredients.count) ingredients")
                                }
                            }) {
                                Text(showAllIngredients ? "Show Less" : "See More")
                                    .foregroundColor(.orange)
                            }
                            .padding()
                        }
                      }
                      .background(Color(.systemBackground))
                      .cornerRadius(15)
                      .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                      .padding(.bottom, 24)

                      Text("How-to")
                          .font(.title2)
                          .fontWeight(.bold)
                          .padding(.horizontal)
                      
                      VStack(spacing: 0) {
                          VStack(alignment: .leading, spacing: 16) {
                              if !recipe.instruction.isEmpty {
                                  if showAllInstructions || recipe.instruction.count <= maxInstructionLength {
                                      Text(recipe.instruction)
                                          .foregroundColor(.primary)
                                  } else {
                                      Text(recipe.instruction.prefix(maxInstructionLength) + "...")
                                          .foregroundColor(.primary)
                                  }
                              } else {
                                  Text("No instructions available")
                                      .foregroundColor(.gray)
                              }
                          }
                          .padding(.vertical, 16)
                          .padding(.horizontal)
                          .background(Color.white)
                          
                          Divider()
                              .padding(.horizontal)
                          
                          if recipe.instruction.count > maxInstructionLength {
                            Button(action: {
                                withAnimation {
                                    showAllInstructions.toggle()
                                }
                            }) {
                                Text(showAllInstructions ? "Show Less" : "See More")
                                    .foregroundColor(.orange)
                            }
                            .padding()
                        }
                      }
                      .background(Color(.systemBackground))
                      .cornerRadius(15)
                      .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                  }
                  .padding()
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .overlay(
          Group {
              if !isRecipeInEvent {
                VStack {
                  Spacer()
                  Button(action: {
                    viewModel.addRecipeToEvent(recipe: recipe, eventID: event.id.uuidString)
                  }) {
                    HStack {
                      Image(systemName: "plus")
                      Text("Add to Menu")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(25)
                    .padding()
                  }
                }
              }
            }
        )
        .alert("Success", isPresented: $viewModel.showSuccessAlert) {
              Button("OK") { }
          } message: {
              Text("Recipe has been added to your menu!")
          }
          .alert("Error", isPresented: .init(
              get: { viewModel.error != nil },
              set: { if !$0 { viewModel.error = nil } }
          )) {
              Button("OK") { }
          } message: {
              if let error = viewModel.error {
                  Text(error)
              }
          }
          // Show loading indicator
          .overlay(
              Group {
                  if viewModel.isLoading {
                      ProgressView()
                          .scaleEffect(1.5)
                          .frame(maxWidth: .infinity, maxHeight: .infinity)
                          .background(Color.black.opacity(0.2))
                  }
              }
          )
    }
}

//struct RecipeDetailNavigationView_Previews: PreviewProvider {
//    static var sampleRecipe = Recipe(
//        apiRecipe: APIRecipe(
//            id: 1,
//            title: "Sausage Fried Rice",
//            image: "https://example.com/image.jpg",
//            imageType: "jpg",
//            readyInMinutes: 30,
//            servings: 4
//        ),
//        ingredients: [
//            Ingredient(
//                name: "Cooked rice",
//                isChecked: false,
//                userID: UUID(),
//                amount: "2 cups"
//            ),
//            Ingredient(
//                name: "Sausage, sliced",
//                isChecked: false,
//                userID: UUID(),
//                amount: "2 pcs"
//            ),
//            Ingredient(
//                name: "Garlic, minced",
//                isChecked: false,
//                userID: UUID(),
//                amount: "2 cloves"
//            )
//        ],
//        instructions: "1. Cook the rice if not using leftover rice.\n2. Slice the sausages, mince the garlic.\n3. Heat oil in a pan and fry the ingredients."
//    )
//    
//    static var sampleEvent = Event(
//        recipes: [],
//        date: Date(),
//        startTime: Date(),
//        endTime: Date(),
//        location: "Home",
//        eventName: "Test Event",
//        qrCode: "",
//        costs: [],
//        totalCost: 0,
//        assignedIngredientsList: []
//    )
//    
//    static var previews: some View {
//        NavigationView {
//            RecipeDetailNavigationView(recipe: sampleRecipe, event: sampleEvent)
//        }
//    }
//}
