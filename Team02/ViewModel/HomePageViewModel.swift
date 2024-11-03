import Foundation
import FirebaseDatabase

class HomePageViewModel: ObservableObject {
    @Published var user: User?
    @Published var upcomingEvents: [Event] = []
    @Published var recommendedRecipes: [Recipe] = []

    private var databaseRef: DatabaseReference = Database.database().reference()

    init(menuDatabase: MenuDatabase) {
        self.recommendedRecipes = menuDatabase.recommendedRecipes
    }

    func fetchUser(userID: String) {
        databaseRef.child("users").child(userID).observeSingleEvent(of: .value) { snapshot in
            if let userData = snapshot.value as? [String: Any],
               let user = User(dictionary: userData) {
                DispatchQueue.main.async {
                    self.user = user
                    self.upcomingEvents = user.events.filter { $0.date > Date() }
                }
            } else {
                print("Failed to fetch user or parse data")
            }
        }
    }
}
