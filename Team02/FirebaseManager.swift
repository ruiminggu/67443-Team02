import FirebaseDatabase

class FirebaseManager {
    static let shared = FirebaseManager()
    private init() {}

    let databaseRef = Database.database().reference()
    let usersRef = Database.database().reference().child("users")
    let eventsRef = Database.database().reference().child("events")
    let recipesRef = Database.database().reference().child("recipes")
    let transactionsRef = Database.database().reference().child("transactions")
}
