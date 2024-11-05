//
//  RecipeSearchView.swift
//  Team02
//
//  Created by Xinyi Chen on 11/4/24.
//

import SwiftUI

struct RecipeSearchView: View {
    @StateObject private var viewModel = RecipeSearchViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            // Custom Navigation Bar
            VStack(alignment: .leading, spacing: 16) {
                Text("Find Dishes")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
                
                HStack {
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search dishes or by ingredients", text: $viewModel.searchText)
                            .onChange(of: viewModel.searchText) { newValue in
                                Task {
                                    await viewModel.searchRecipes()
                                }
                            }
                    }
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    
                    // Filter Button
                    Button(action: {}) {
                        Image(systemName: "slider.horizontal.3")
                            .foregroundColor(.orange)
                    }
                    
                    // Add Button
                    Button(action: {}) {
                        Image(systemName: "plus")
                            .foregroundColor(.orange)
                    }
                }
            }
            .padding()
            .background(Color.white)
            
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        if !viewModel.searchText.isEmpty {
                            if viewModel.recipes.isEmpty {
                                Text("No recipes found")
                                    .foregroundColor(.gray)
                                    .padding()
                            } else {
                                ForEach(viewModel.recipes) { recipe in
                                    RecipeSearchCard(recipe: recipe)
                                }
                            }
                        } else {
                            // You might want to show recent searches or featured recipes here
                            Text("Start searching for recipes!")
                                .foregroundColor(.gray)
                                .padding()
                        }
                    }
                    .padding()
                }
            }
            
            if let error = viewModel.error {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            }
        }
    }
}

struct RecipeSearchView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeSearchView()
    }
}
