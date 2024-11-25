import SwiftUI

struct HomeRecipeSearchView: View {
    @StateObject private var viewModel = RecipeSearchViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            // Search Header
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "arrow.backward")
                            .foregroundColor(.orange)
                    }
                    .padding(.trailing, 8)

                    TextField("Search recipes...", text: $viewModel.searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onSubmit {
                            Task {
                                await viewModel.searchRecipes()
                            }
                        }
                        .padding(.vertical, 8)

                    Button(action: {}) {
                        Image(systemName: "slider.horizontal.3")
                            .foregroundColor(.orange)
                    }
                }
                .padding(.horizontal)
            }
            .padding()
            .background(Color.white)

            // Search Results
            ZStack {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color(.systemBackground))
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            if !viewModel.searchText.isEmpty {
                                if viewModel.recipes.isEmpty {
                                    Text("No recipes found")
                                        .foregroundColor(.gray)
                                        .padding(.top, 40)
                                } else {
                                    ForEach(viewModel.recipes) { recipe in
                                        HomeRecipeSearchCard(recipe: recipe)
                                    }
                                }
                            } else {
                                Text("Search for recipes by name or ingredients")
                                    .foregroundColor(.gray)
                                    .padding(.top, 40)
                            }
                        }
                        .padding()
                    }
                }

                if let error = viewModel.error {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(10)
                        .shadow(radius: 2)
                }
            }
        }
    }
}
