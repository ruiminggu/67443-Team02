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
    @State private var currentImageIndex = 0
    
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
                    
                    // Pagination Dots
//                    HStack {
//                        ForEach(0..<3) { index in
//                            Circle()
//                                .fill(index == currentImageIndex ? Color.orange : Color.white)
//                                .frame(width: 8, height: 8)
//                        }
//                    }
//                    .padding()
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
                        Text("21 May 2024")
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
                          ForEach(recipe.ingredients.prefix(5)) { ingredient in
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
                              
                              Divider()
                                  .padding(.horizontal)
                          }
                          
                          if recipe.ingredients.count > 5 {
                              Button(action: {
                                  // Action to show more ingredients
                              }) {
                                  Text("See More")
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
                              Text("1. Preparation (5 Minutes)")
                                  .fontWeight(.medium)
                              Text(recipe.instruction)
                                  .foregroundColor(.primary)
                          }
                          .padding(.vertical, 16)
                          .padding(.horizontal)
                          .background(Color.white)
                          
                          Divider()
                              .padding(.horizontal)
                          
                          Button(action: {
                              // Action to show more steps
                          }) {
                              Text("See More")
                                  .foregroundColor(.orange)
                          }
                          .padding()
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
            VStack {
                Spacer()
                Button(action: {
                    // Add recipe to menu action
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
