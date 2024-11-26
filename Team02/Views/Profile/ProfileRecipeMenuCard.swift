import SwiftUI

struct ProfileRecipeMenuCard: View {
    let recipe: Recipe

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Recipe Image
            AsyncImage(url: URL(string: recipe.image)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure(_):
                    Image(systemName: "photo")
                        .foregroundColor(.gray)
                case .empty:
                    ProgressView()
                @unknown default:
                    Color.gray
                }
            }
            .frame(width: 300, height: 120)
            .clipped()
            .cornerRadius(12)

            // Recipe Title
            Text(recipe.title)
                .font(.headline)
                .lineLimit(2)

            // Time and Servings
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .foregroundColor(.orange)
                    Text("\(recipe.readyInMinutes) min")
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                Spacer()

                HStack(spacing: 4) {
                    Image(systemName: "person.2")
                        .foregroundColor(.orange)
                    Text("\(recipe.servings) servings")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 4)
        .frame(width: 300) // Adjusted width for larger card
    }
}
