import SwiftUI

struct RecipeListView: View {
    let category: String
    let userID: String // Pass the userID from HomeView
    @StateObject private var viewModel = RecipeSearchViewModel()

    var body: some View {
        VStack {
            Text("\(category) Recommendations")
                .font(.largeTitle)
                .padding()

            if viewModel.isLoading {
                ProgressView()
            } else if viewModel.recipes.isEmpty {
                Text("No recipes found for \(category).")
                    .font(.headline)
                    .padding()
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.recipes, id: \.id) { recipe in
                            NavigationLink(destination: ProfileRecipeDetail(recipe: recipe)) {
                                HomeRecipeSearchCard(recipe: recipe, userID: userID)
                            }
                            .buttonStyle(PlainButtonStyle()) // Avoid unwanted styles
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.searchText = category
            Task {
                await viewModel.searchRecipes()
            }
        }
    }
}
