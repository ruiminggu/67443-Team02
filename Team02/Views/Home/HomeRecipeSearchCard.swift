import SwiftUI

struct HomeRecipeSearchCard: View {
    let recipe: Recipe
    let userID: String
    @StateObject private var viewModel = RecipeSearchViewModel()
    @State private var showToast = false
    @State private var isAdding = false // To handle loading state for the like button

    var difficultyLevel: String {
        switch recipe.readyInMinutes {
        case ..<30:
            return "Easy"
        case 30..<60:
            return "Medium"
        default:
            return "Hard"
        }
    }
    
    var difficultyColor: Color {
        switch difficultyLevel {
        case "Easy":
            return .green
        case "Medium":
            return .orange
        default:
            return .red
        }
    }

    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                // Recipe Image
                AsyncImage(url: URL(string: recipe.image)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure(_):
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    case .empty:
                        ProgressView()
                    @unknown default:
                        Color.gray
                    }
                }
                .frame(width: 80, height: 80)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                
                // Recipe Details
                VStack(alignment: .leading, spacing: 4) {
                    Text(recipe.title)
                        .font(.headline)
                        .lineLimit(2)
                    
                    HStack {
                        // Cooking Time
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                                .foregroundColor(.orange)
                            Text("\(recipe.readyInMinutes) min")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        // Servings
                        HStack(spacing: 4) {
                            Image(systemName: "person.2")
                                .foregroundColor(.orange)
                            Text("\(recipe.servings) servings")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    HStack(spacing: 4) {
                        Circle()
                            .fill(difficultyColor)
                            .frame(width: 6, height: 6)
                        
                        Text(difficultyLevel)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 2)
                }
            }
            
            // Like Button
            Button(action: {
                isAdding = true
                viewModel.likeRecipe(recipe: recipe, userID: userID)
                showToast = true
                
                // Simulate loading state and reset after success
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    isAdding = false
                    showToast = false
                }
            }) {
                HStack {
                    if isAdding {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Image(systemName: recipe.isLiked ? "heart.fill" : "heart")
                        Text(recipe.isLiked ? "Liked" : "Like")
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(recipe.isLiked ? Color.red : Color.orange)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .disabled(isAdding)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .overlay(
            ToastView(message: "Recipe liked successfully!", isShowing: $showToast)
                .animation(.spring(), value: showToast)
        )
    }
}
