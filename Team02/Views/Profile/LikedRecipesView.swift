import SwiftUI

struct LikedRecipesView: View {
    @ObservedObject var viewModel: ProfileViewModel // Observe the ProfileViewModel

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                if viewModel.likedRecipes.isEmpty {
                    Text("You have no liked recipes.")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.likedRecipes) { recipe in
                              NavigationLink(destination: ProfileRecipeDetail(recipe: recipe)) {
                                  ProfileRecipeMenuCard(recipe: recipe)
                              }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationBarTitle("Liked Recipes", displayMode: .inline)
        }
        .onAppear {
            if let userID = viewModel.user?.id.uuidString {
                viewModel.fetchUser(userID: userID) // Fetch updated user data
            }
        }
    }
}
