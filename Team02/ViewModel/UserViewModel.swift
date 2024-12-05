import Foundation
import FirebaseDatabase

class UserViewModel: ObservableObject {
    @Published var users: [User] = [] // Published property to hold fetched users
    private var databaseRef: DatabaseReference = Database.database().reference()

    init() {
        if !UserDefaults.standard.bool(forKey: "sampleUsersAddedSuccessfully") {
//            addSampleUsers() // Only add sample users if they haven’t been added before
            UserDefaults.standard.set(true, forKey: "sampleUsersAddedSuccessfully")
        }
        fetchUsers() // Fetch users from the database
    }

    func saveUser(user: User) {
        let userID = user.id.uuidString
        databaseRef.child("users").child(userID).setValue(user.toDictionary()) { error, _ in
            if let error = error {
                print("Error saving user: \(error.localizedDescription)")
            } else {
                print("User saved successfully!")
            }
        }
    }

    func fetchUsers() {
        databaseRef.child("users").observe(.value) { snapshot in
            var fetchedUsers: [User] = []

            for case let childSnapshot as DataSnapshot in snapshot.children {
                print("Snapshot key: \(childSnapshot.key)") // Debugging: Print each user key
                if let userData = childSnapshot.value as? [String: Any],
                   let user = User(dictionary: userData) {
                    fetchedUsers.append(user)
                } else {
                    print("Failed to parse user for snapshot: \(childSnapshot.key)") // Debugging
                }
            }

            DispatchQueue.main.async {
                self.users = fetchedUsers
                print("Fetched users count: \(self.users.count)") // Debugging: Check user count
            }
        }
    }
}
