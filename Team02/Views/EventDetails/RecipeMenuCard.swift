//
//  RecipeMenuCard.swift
//  Team02
//
//  Created by Xinyi Chen on 11/8/24.
//

import SwiftUI

struct RecipeMenuCard: View {
  let recipe: Recipe
  let event: Event
  
  var body: some View {
    NavigationLink(destination: RecipeDetailNavigationView(recipe: recipe, event: event)) {
      VStack(alignment: .leading, spacing: 8) {
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
        .frame(width: 200, height: 120)
        .clipped()
        .cornerRadius(10)
        
        Text(recipe.title)
          .font(.headline)
          .lineLimit(2)
        
        HStack {
          Image(systemName: "clock")
            .foregroundColor(.orange)
          Text("\(recipe.readyInMinutes) min")
            .font(.caption)
          
          Spacer()
          
          Image(systemName: "person.2")
            .foregroundColor(.orange)
          Text("\(recipe.servings)")
            .font(.caption)
        }
        .foregroundColor(.gray)
      }
      .frame(width: 200)
      .padding()
      .background(Color.white)
      .cornerRadius(15)
      .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
  }
}

//#Preview {
//    RecipeCard()
//}
