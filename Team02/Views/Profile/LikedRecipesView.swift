import SwiftUI

struct LikedRecipesView: View {
    let recipes: [Recipe]

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                if recipes.isEmpty {
                    Text("You have no liked recipes.")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(recipes) { recipe in
                                ProfileRecipeMenuCard(recipe: recipe)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationBarTitle("Liked Recipes", displayMode: .inline)
        }
    }
}
