import FirebaseDatabase

class DatabaseViewModel: ObservableObject {
    @Published var data: [String: Any] = [:]
    private var ref: DatabaseReference = Database.database().reference()
    
    func fetchData() {
        ref.child("examplePath").observe(.value) { snapshot in
            if let value = snapshot.value as? [String: Any] {
                DispatchQueue.main.async {
                    self.data = value
                }
            }
        }
    }
}
