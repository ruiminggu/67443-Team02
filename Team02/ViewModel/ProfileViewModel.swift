import Foundation
import FirebaseDatabase

class ProfileViewModel: ObservableObject {
    @Published var user: User?
    @Published var likedRecipes: [Recipe] = []
    @Published var errorMessage: String?

    private var databaseRef: DatabaseReference = Database.database().reference()

    func fetchUser(userID: String) {
        databaseRef.child("users").child(userID).observeSingleEvent(of: .value) { [weak self] snapshot, _ in
            guard let self = self else { return }

            guard let userData = snapshot.value as? [String: Any],
                  let user = User(dictionary: userData) else {
                self.errorMessage = "Failed to load user data."
                return
            }

            DispatchQueue.main.async {
                self.user = user
                self.likedRecipes = user.likedRecipes
                print("✅ Fetched \(self.likedRecipes.count) liked recipes.")
            }
        }
    }
}
