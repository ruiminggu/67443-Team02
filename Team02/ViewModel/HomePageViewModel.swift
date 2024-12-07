import Foundation
import FirebaseDatabase

class HomePageViewModel: ObservableObject {
    @Published var user: User? // Current user
    @Published var upcomingEvents: [Event] = []
    @Published var recommendedRecipes: [Recipe] = []
    @Published var userEventCount: Int = 0 // New: Event count for the profile page

    private var databaseRef: DatabaseReference = Database.database().reference()

    init(menuDatabase: MenuDatabase) {
        self.recommendedRecipes = menuDatabase.recommendedRecipes
    }
  
  func fetchUser() {
      guard let userUUID = UserDefaults.standard.string(forKey: "currentUserUUID") else {
          print("❌ No UUID found for the current user.")
          return
      }

      print("📱 Fetching user with UUID: \(userUUID)")

      databaseRef.child("users").child(userUUID).observe(.value) { snapshot in
          if let userData = snapshot.value as? [String: Any],
             let user = User(dictionary: userData) {
              DispatchQueue.main.async {
                  self.user = user
                  self.userEventCount = user.events.count // Update event count
                  print("✅ User fetched: \(user.fullName)")
                  self.fetchUserEvents(eventIDs: user.events) // Fetch associated events
              }
          } else {
              print("❌ Failed to fetch user data from Firebase for UUID: \(userUUID)")
          }
      }
  }


  private func fetchUserEvents(eventIDs: [String]) {
      var fetchedEvents: [Event] = []
      let dispatchGroup = DispatchGroup()
      
      for eventID in eventIDs {
          dispatchGroup.enter()
          
          databaseRef.child("events").child(eventID).observeSingleEvent(of: .value) { snapshot in
              defer { dispatchGroup.leave() }
              
              if let eventData = snapshot.value as? [String: Any],
                 let event = Event(dictionary: eventData) {
                  DispatchQueue.main.async {
                      if !fetchedEvents.contains(where: { $0.id == event.id }) {
                          fetchedEvents.append(event)
                      }
                  }
              }
          }
      }
      
      dispatchGroup.notify(queue: .main) {
          self.upcomingEvents = fetchedEvents.filter { $0.date > Date() }
          print("Updated upcomingEvents: \(self.upcomingEvents.count); Updated pastEvents: \((fetchedEvents.filter { $0.date <= Date() }).count)")
      }
  }

}
