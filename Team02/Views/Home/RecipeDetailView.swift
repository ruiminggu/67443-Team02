import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Image(recipe.image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                Text(recipe.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.horizontal)

                Text("Ingredients")
                    .font(.headline)
                    .padding(.horizontal)
                
                ForEach(recipe.ingredients, id: \.self) { ingredient in
                    Text(ingredient.name) // Display the name of each ingredient
                        .padding(.horizontal)
                }

                Text("Instructions")
                    .font(.headline)
                    .padding(.horizontal)
                
                Text(recipe.instruction)
                    .padding(.horizontal)
            }
        }
        .navigationTitle(recipe.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
