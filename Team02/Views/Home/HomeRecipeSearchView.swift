import SwiftUI
import FirebaseAuth

struct HomeRecipeSearchView: View {
    @StateObject private var viewModel = RecipeSearchViewModel()
    @Environment(\.dismiss) private var dismiss

    // Optional: If you want to pass a hardcoded userID
    let userID: String?

    var body: some View {
        NavigationView {
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
                                            NavigationLink(destination: ProfileRecipeDetail(recipe: recipe)) {
                                                HomeRecipeSearchCard(recipe: recipe, userID: resolvedUserID())
                                            }
                                            .buttonStyle(PlainButtonStyle()) // Ensures clickable areas don't interfere
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
        .navigationViewStyle(StackNavigationViewStyle()) // Fixes layout for navigation links in modals
    }

    // Helper method to resolve userID
    private func resolvedUserID() -> String {
        // If a userID is explicitly passed, use it
        if let userID = userID {
            return userID
        }

        // Otherwise, try to get the current logged-in user from Firebase Auth
        if let currentUserID = Auth.auth().currentUser?.uid {
            return currentUserID
        }

        // If no userID is available, return a fallback (use carefully in production)
        print("⚠️ No valid userID found. Using fallback.")
        return "fallback_user_id" // Replace with appropriate fallback if needed
    }
}
