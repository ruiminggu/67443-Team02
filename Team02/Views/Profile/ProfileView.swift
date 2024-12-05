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
                      Spacer()
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
              .buttonStyle(PlainButtonStyle())
          }
          .frame(maxWidth: .infinity, minHeight: 160)
          .padding(.horizontal)
          .sheet(isPresented: $showLikedRecipes) {
              LikedRecipesView(viewModel: viewModel) // Pass the viewModel
          }


            Spacer()
        }
        .padding()
        .background(Color(UIColor.systemBackground)) // Matches light/dark mode
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if viewModel.user == nil {
                // Fetch the user's UUID from UserDefaults
                if let userUUID = UserDefaults.standard.string(forKey: "currentUserUUID") {
                    viewModel.fetchUser(userID: userUUID) // Fetch user data using the UUID
                } else {
                    print("⚠️ No UUID found in UserDefaults")
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
