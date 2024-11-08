import SwiftUI

struct RecipeCard: View {
    let recipe: Recipe

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Image(recipe.image)
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 10))

            Text(recipe.title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .lineLimit(1)
                .frame(width: 120, alignment: .leading)

            HStack(spacing: 3) {
                Image(systemName: "star.fill")
                    .font(.footnote)
                    .foregroundColor(.yellow)

                Text(String(format: "%.1f", recipe.rating)) // Display rating, e.g., 4.9
                    .font(.footnote)
            }
            .frame(width: 120, alignment: .leading)
        }
        .frame(width: 120)
        .padding(.vertical, 5)
    }
}
