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

    func fetchUser(userID: String) {
        print("Fetching user with ID: \(userID)")

        databaseRef.child("users").child(userID).observeSingleEvent(of: .value) { snapshot, _ in
            if let userData = snapshot.value as? [String: Any],
               let user = User(dictionary: userData) {
                DispatchQueue.main.async {
                    self.user = user

                    // Update user event count for the profile page
                    self.userEventCount = user.events.count
                    
                    // Fetch full event details
                    let eventIDs = user.events
                    print("User event IDs: \(eventIDs)")
                    self.fetchUserEvents(eventIDs: eventIDs)
                }
            } else {
                print("Failed to fetch user data from Firebase")
            }
        }
    }

    private func fetchUserEvents(eventIDs: [String]) {
        var fetchedEvents: [Event] = []
        
        let dispatchGroup = DispatchGroup()
        
        for eventID in eventIDs {
            dispatchGroup.enter()
            
            databaseRef.child("events").child(eventID).observeSingleEvent(of: .value) { snapshot, _ in
                if let eventData = snapshot.value as? [String: Any],
                   let event = Event(dictionary: eventData) {
                    DispatchQueue.main.async {
                        fetchedEvents.append(event)
                    }
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            // Update upcoming events
            self.upcomingEvents = fetchedEvents.filter { $0.date > Date() }
            print("Updated upcomingEvents: \(self.upcomingEvents.count); Updated pastEvents: \((fetchedEvents.filter { $0.date <= Date() }).count)")
        }
    }
}
