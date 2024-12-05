import SwiftUI

struct ProfileRecipeDetail: View {
    let recipe: Recipe
    @State private var currentImageIndex = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Recipe Image
                AsyncImage(url: URL(string: recipe.image)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 250)
                            .clipped()
                    case .failure:
                        Color.gray
                            .frame(height: 250)
                    case .empty:
                        ProgressView()
                            .frame(height: 250)
                    @unknown default:
                        Color.gray
                            .frame(height: 250)
                    }
                }
                
                VStack(alignment: .leading, spacing: 20) {
                    // Title and Rating
                    HStack {
                        Text(recipe.title)
                            .font(.title)
                            .fontWeight(.bold)
                        Spacer()
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.orange)
                            Text(String(format: "%.1f", recipe.rating))
                                .fontWeight(.semibold)
                        }
                    }
                    
                    // Cooking Time
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.gray)
                        Text("\(recipe.readyInMinutes) Minutes")
                            .foregroundColor(.gray)
                    }
                    
                    // Ingredients
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Ingredients")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        ForEach(recipe.ingredients) { ingredient in
                            HStack {
                                Text(ingredient.name)
                                Spacer()
                                Text(ingredient.amount)
                                    .foregroundColor(.gray)
                                    .fontWeight(.medium)
                            }
                            Divider()
                        }
                    }
                    
                    // Instructions
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Instructions")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text(recipe.instruction)
                            .foregroundColor(.primary)
                            .padding(.top, 8)
                    }
                }
                .padding()
            }
        }
        .navigationTitle(recipe.title)
        .navigationBarTitleDisplayMode(.inline) // Inline navigation bar for consistency
    }
}
