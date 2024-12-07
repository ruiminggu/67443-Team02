//
//  RecipeSearchView.swift
//  Team02
//
//  Created by Xinyi Chen on 11/4/24.
//

import SwiftUI
import Foundation


struct RecipeSearchView: View {
    @StateObject private var viewModel = RecipeSearchViewModel()
    @Environment(\.dismiss) private var dismiss
    let event: Event
  
    var body: some View {
      NavigationView {
        VStack(spacing: 0) {
          VStack(alignment: .leading, spacing: 16) {
            Text("Find Dishes")
              .font(.title)
              .fontWeight(.bold)
              .foregroundColor(.orange)
            
//            HStack {
//              HStack {
//                Image(systemName: "magnifyingglass")
//                  .foregroundColor(.gray)
//                TextField("Search dishes or by ingredients", text: $viewModel.searchText)
//                  .onChange(of: viewModel.searchText) { newValue in
//                    Task {
//                      await viewModel.searchRecipes()
//                    }
//                  }
//              }
//              .padding(10)
//              .background(Color(.systemGray6))
//              .cornerRadius(10)
//              
//            }
            SearchBarWithAddButton(text: $viewModel.searchText, event: event)
          }
          .padding()
          .background(Color.white)
          .zIndex(1)
          
          ZStack {
            if viewModel.isLoading {
              // Loading indicator
              ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemBackground))
            } else {
              ScrollView {
                LazyVStack(spacing: 16) {
                  if !viewModel.searchText.isEmpty {
                    if viewModel.recipes.isEmpty {
                      VStack(spacing: 10) {
                        Text("No recipes found")
                          .foregroundColor(.gray)
                          .padding()
                        Text("Try different keywords")
                          .font(.subheadline)
                          .foregroundColor(.gray)
                      }
                      .frame(maxWidth: .infinity)
                      .padding(.top, 40)
                    } else {
                      ForEach(viewModel.recipes) { recipe in
                        RecipeSearchCard(recipe: recipe, event: event)
                        //                                          .swipeActions(edge: .trailing) {
                        //                                              Button {
                        //                                                  viewModel.addRecipeToEvent(recipe: recipe, eventID: event.id.uuidString)
                        //                                              } label: {
                        //                                                  Label("Add", systemImage: "plus.circle")
                        //                                              }
                        //                                              .tint(.green)
                        //                                          }
                      }
                    }
                  } else {
                    VStack(alignment: .leading, spacing: 10) {
                      Text("Recent")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                      
                      Text("No recent searches")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                        .padding()
                    }
                    .padding(.top, 0)
                  }
                }
                .padding()
              }
            }
            
            // Error message overlay
            if let error = viewModel.error {
              Text(error)
                .foregroundColor(.red)
                .padding()
                .background(Color.white.opacity(0.9))
                .cornerRadius(10)
                .shadow(radius: 2)
            }
          }
          //            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
      }
    }
}

struct SearchBarWithAddButton: View {
    @Binding var text: String
    @State private var showingAddRecipe = false
    let event: Event
    @StateObject private var viewModel = RecipeSearchViewModel()
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search dishes or by ingredients", text: $text)
                    .onChange(of: text) { newValue in
                        Task {
                            await viewModel.searchRecipes()
                        }
                    }
            }
            .padding(10)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            
            Button(action: { showingAddRecipe = true }) {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.orange)
                    .font(.title2)
            }
        }
        .sheet(isPresented: $showingAddRecipe) {
            NavigationView {
                CreateCustomRecipeView(event: event)
            }
        }
    }
}
//struct RecipeSearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        RecipeSearchView()
//    }
//}
