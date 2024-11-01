import SwiftUI

struct RecipeCard: View {
    let recipe: Recipe

    var body: some View {
        VStack {
            Image(recipe.image)
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 10))

            Text(recipe.title)
                .font(.subheadline)
                .multilineTextAlignment(.center)
        }
        .frame(width: 120)
    }
}
