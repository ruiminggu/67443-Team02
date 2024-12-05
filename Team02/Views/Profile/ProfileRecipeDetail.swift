//
//  ProfileRecipeDetail.swift
//  Team02
//
//  Created by 顾芮名 on 12/4/24.
//

import SwiftUI

struct ProfileRecipeDetail: View {
    let recipe: Recipe
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
                        Spacer()
                        Image(systemName: "clock")
                            .foregroundColor(.gray)
                        Text("\(recipe.readyInMinutes) Minutes")
                            .foregroundColor(.gray)
                    }
                    
                    // Ingredients
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Ingredients")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        ForEach(recipe.ingredients.prefix(5)) { ingredient in
                            HStack {
                                Text(ingredient.name)
                                    .foregroundColor(.primary)
                                Spacer()
                                Text(ingredient.amount)
                                    .foregroundColor(.black)
                                    .fontWeight(.medium)
                            }
                            Divider()
                        }
                    }
                    
                    // Instructions
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Instructions")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text(recipe.instruction)
                            .foregroundColor(.primary)
                    }
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
