import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @State private var showLikedRecipes = false

    var body: some View {
        VStack(spacing: 20) {
            // Profile Heading
            Text("Profile")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 20)

            // Profile Picture
            Image(viewModel.user?.image ?? "profile_pic") // Use the user's profile image
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 4)
                )
                .frame(width: 120, height: 120)
                .shadow(radius: 10)

            // User Name
            Text(viewModel.user?.fullName ?? "Your Name")
                .font(.title3)
                .fontWeight(.semibold)

            // Event Count
            Text("Hosted \(viewModel.user?.events.count ?? 0) Events")
                .font(.headline)
                .foregroundColor(.orange)

            // Liked Recipes Section
            VStack {
                Button(action: {
                    showLikedRecipes = true
                }) {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Liked Recipes")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.orange)

                            Text("View your liked recipes here.")
                                .font(.body)
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.leading)
                        }
                        Spacer() // Push the chevron to the right
                        Image(systemName: "chevron.right")
                            .font(.title2)
                            .foregroundColor(.orange)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.orange.opacity(0.1))
                    )
                }
                .buttonStyle(PlainButtonStyle()) // To remove button styling
            }
            .frame(maxWidth: .infinity, minHeight: 160)
            .padding(.horizontal)
            .sheet(isPresented: $showLikedRecipes) {
                LikedRecipesView(recipes: viewModel.likedRecipes)
            }

            Spacer()
        }
        .padding()
        .background(Color(UIColor.systemBackground)) // Matches light/dark mode
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if viewModel.user == nil {
                // Use Firebase Auth to get the current user's ID
                if let currentUser = Auth.auth().currentUser {
                    viewModel.fetchUser(userID: currentUser.uid)
                } else {
                    print("⚠️ No user is logged in")
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(viewModel: ProfileViewModel())
    }
}
