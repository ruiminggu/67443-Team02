import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: HomePageViewModel

    var body: some View {
        VStack(spacing: 20) {
            // Profile Heading
            Text("Profile")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 20)

            // Profile Picture
          Image("profile_pic") // Use the exact name of your asset here
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
            Text("Hosted \(viewModel.userEventCount) Events")
                .font(.headline)
                .foregroundColor(.orange)

            // Enlarged Liked Recipes Section
            VStack(alignment: .leading, spacing: 12) {
                Text("Liked Recipes")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.orange)

                Text("Placeholder for liked recipes... Bacon, Ramen, Cake, and more.")
                    .font(.body)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
            }
            .padding()
            .background(Color.orange.opacity(0.1))
            .cornerRadius(12)
            .frame(maxWidth: .infinity, minHeight: 120, alignment: .leading)
            .padding(.horizontal)

            Spacer()
        }
        .padding()
        .background(Color(UIColor.systemBackground)) // Matches light/dark mode
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // Fetch user profile if necessary
            if viewModel.user == nil {
                viewModel.fetchUser(userID: "your_user_id_here") // Replace with actual user ID
            }
        }
    }
}
