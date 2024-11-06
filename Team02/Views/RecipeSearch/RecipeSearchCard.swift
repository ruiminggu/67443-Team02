//
//  RecipeSearchCard.swift
//  Team02
//
//  Created by Xinyi Chen on 11/4/24.
//

import SwiftUI

struct RecipeSearchCard: View {
  let recipe: Recipe
  
  var difficultyLevel: String {
      switch recipe.readyInMinutes {
      case ..<30:
          return "Easy"
      case 30..<60:
          return "Medium"
      default:
          return "Hard"
      }
  }
    
  // Computed property for difficulty color
  var difficultyColor: Color {
      switch difficultyLevel {
      case "Easy":
          return .green
      case "Medium":
          return .orange
      default:
          return .red
      }
  }

  var body: some View {
    HStack(spacing: 16) {
      // Recipe Image
      AsyncImage(url: URL(string: recipe.image)) { phase in
          switch phase {
          case .success(let image):
              image
                  .resizable()
                  .aspectRatio(contentMode: .fill)
          case .failure(_):
              Image(systemName: "photo")
                  .foregroundColor(.gray)
          case .empty:
              ProgressView()
          @unknown default:
              Color.gray
          }
      }
      .frame(width: 80, height: 80)
      .background(Color.gray.opacity(0.2))
      .cornerRadius(10)
      
      // Recipe Details
      VStack(alignment: .leading, spacing: 4) {
        Text(recipe.title)
            .font(.headline)
            .lineLimit(2)
        
      HStack {
          // Cooking Time
          HStack(spacing: 4) {
              Image(systemName: "clock")
                  .foregroundColor(.orange)
              Text("\(recipe.readyInMinutes) min")
                  .font(.caption)
                  .foregroundColor(.gray)
          }
          
          Spacer()
          
          // Servings
          HStack(spacing: 4) {
              Image(systemName: "person.2")
                  .foregroundColor(.orange)
              Text("\(recipe.servings) servings")
                  .font(.caption)
                  .foregroundColor(.gray)
          }
      }
          
      HStack(spacing: 4) {
              Circle()
                  .fill(difficultyColor)
                  .frame(width: 6, height: 6)
              
              Text(difficultyLevel)
                  .font(.caption)
                  .foregroundColor(.gray)
          }
          .padding(.top, 2)
      }
    }
    .padding()
    .background(Color.white)
    .cornerRadius(15)
    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
  }
}

struct RecipeSearchCard_Previews: PreviewProvider {
    static var previews: some View {
    RecipeSearchCard(recipe: Recipe(apiRecipe: APIRecipe(
          id: 1,
          title: "Delicious Recipe",
          image: "https://example.com/image.jpg",
          imageType: "jpg",
          readyInMinutes: 30,
          servings: 4
      )))
      .previewLayout(.sizeThatFits)
      .padding()
  }
}
