//
//  MenuSectionView.swift
//  Team02
//
//  Created by Xinyi Chen on 11/4/24.
//

import SwiftUI

struct MenuSectionView: View {
    @State private var showRecipeSearch = false
    let event: Event // Pass the event to access its recipes
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
          
        Text("Menu")
            .font(.system(size: 28, weight: .bold))
            .foregroundColor(.orange)
        
        HStack {
              Spacer()
              
              Button(action: {
                  showRecipeSearch = true
              }) {
                  ZStack {
                      Circle()
                          .fill(Color.orange.opacity(0.2))
                          .frame(width: 60, height: 60)
                      
                      Image(systemName: "plus")
                          .font(.system(size: 24, weight: .medium))
                          .foregroundColor(.orange)
                  }
              }
            Spacer()
          }
          
//          Text("Debug: \(event.recipes.count) recipes")
//                          .font(.caption)
//                          .foregroundColor(.gray)
          
          // Display event recipes
          if event.recipes.isEmpty {
                Text("No recipes added yet")
                    .foregroundColor(.gray)
                    .padding(.vertical)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 16) {
                        ForEach(event.recipes) { recipe in
                            RecipeMenuCard(recipe: recipe)
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
        .sheet(isPresented: $showRecipeSearch) {
            RecipeSearchView(event: event)
        }
        .onAppear {
            print("📱 MenuSectionView appeared")
            print("📱 Event has \(event.recipes.count) recipes")
            event.recipes.forEach { recipe in
                print("- Recipe: \(recipe.title)")
            }
        }
    }
}

//
//struct MenuSectionView_Previews: PreviewProvider {
//    static var previews: some View {
//      MenuSectionView(event: <#T##Event#>)
//    }
//}
