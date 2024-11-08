//
//  RecipeSearchCard.swift
//  Team02
//
//  Created by Xinyi Chen on 11/4/24.
//

import SwiftUI

struct RecipeSearchCard: View {
    let recipe: Recipe
    let event: Event
    @StateObject private var viewModel = RecipeSearchViewModel()
    @State private var showingSuccessAlert = false
    @State private var isAdding = false // To show loading state
    @State private var showToast = false

    
    private var isRecipeInEvent: Bool {
          event.recipes.contains { $0.title == recipe.title }
      }
  
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
         VStack(spacing: 16) {
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
             
             // Add Button
             if isRecipeInEvent {
                 // Already added state
                 HStack {
                     Image(systemName: "checkmark.circle.fill")
                     Text("Added to Menu")
                 }
                 .frame(maxWidth: .infinity)
                 .padding(.vertical, 8)
                 .background(Color.gray.opacity(0.2))
                 .foregroundColor(.gray)
                 .cornerRadius(8)
             } else {
                 // Add button
                 Button(action: {
                     viewModel.addRecipeToEvent(recipe: recipe, eventID: event.id.uuidString)
                 }) {
                     HStack {
                         if viewModel.isLoading {
                             ProgressView()
                                 .tint(.white)
                         } else {
                             Image(systemName: "plus.circle.fill")
                             Text("Add to Menu")
                         }
                     }
                     .frame(maxWidth: .infinity)
                     .padding(.vertical, 8)
                     .background(Color.orange)
                     .foregroundColor(.white)
                     .cornerRadius(8)
                 }
                 .disabled(viewModel.isLoading)
             }
         }
         .padding()
         .background(Color.white)
         .cornerRadius(15)
         .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
         .overlay(
             ToastView(message: "Recipe added successfully!", isShowing: $showToast)
                 .animation(.spring(), value: showToast)
         )
         .onChange(of: viewModel.showSuccessAlert) { newValue in
             if newValue {
                 showToast = true
                 // Hide toast after 2 seconds
                 DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                     showToast = false
                     viewModel.showSuccessAlert = false
                 }
             }
         }
     }
 }

struct ToastView: View {
    let message: String
    @Binding var isShowing: Bool
    
    var body: some View {
        if isShowing {
            VStack {
                Spacer()
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text(message)
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color.black.opacity(0.8))
                .cornerRadius(20)
                .transition(.move(edge: .bottom))
                .padding(.bottom, 20)
            }
        }
    }
}
//struct RecipeSearchCard_Previews: PreviewProvider {
//    static var previews: some View {
//    RecipeSearchCard(recipe: Recipe(apiRecipe: APIRecipe(
//          id: 1,
//          event: event,
//          title: "Delicious Recipe",
//          image: "https://example.com/image.jpg",
//          imageType: "jpg",
//          readyInMinutes: 30,
//          servings: 4
//      )))
//      .previewLayout(.sizeThatFits)
//      .padding()
//  }
//}
