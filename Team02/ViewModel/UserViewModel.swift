import Foundation
import FirebaseDatabase

class UserViewModel: ObservableObject {
    private var databaseRef: DatabaseReference = Database.database().reference()

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
              if let userData = childSnapshot.value as? [String: Any],
                 let user = User(dictionary: userData) { // Implement an init?(dictionary:) in User if needed
                  fetchedUsers.append(user)
              }
          }
          
          DispatchQueue.main.async {
              // Update your @Published array to use fetchedUsers if you have one
              print("Fetched users: \(fetchedUsers)")
          }
      }
  }

}
