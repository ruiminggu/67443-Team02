import Foundation
import FirebaseDatabase

class ProfileViewModel: ObservableObject {
    @Published var user: User?
    @Published var likedRecipes: [Recipe] = []
    @Published var errorMessage: String?

    private var databaseRef: DatabaseReference = Database.database().reference()

  func fetchUser(userID: String) {
      print("📱 Fetching user with UUID: \(userID)")
      
      databaseRef.child("users").child(userID).observe(.value) { [weak self] snapshot in
          guard let self = self else { return }

          guard let userData = snapshot.value as? [String: Any],
                let user = User(dictionary: userData) else {
              print("❌ Failed to fetch user data from Firebase for UUID: \(userID)")
              self.errorMessage = "Failed to load user data."
              return
          }

          DispatchQueue.main.async {
              self.user = user
              self.likedRecipes = user.likedRecipes

              print("✅ User data updated: \(user)")
              print("✅ Liked recipes count: \(self.likedRecipes.count)")
              for recipe in self.likedRecipes {
                  print("🍽 Liked Recipe: \(recipe.title)")
              }
          }
      }
  }


}
