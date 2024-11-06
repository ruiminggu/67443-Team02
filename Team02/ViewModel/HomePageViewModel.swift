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
        print("Fetching user with ID: \(userID)")

        databaseRef.child("users").child(userID).observeSingleEvent(of: .value) { snapshot, _ in
            if let userData = snapshot.value as? [String: Any],
               let user = User(dictionary: userData) {
                DispatchQueue.main.async {
                    self.user = user
                    
                    // Extract event IDs directly, as `events` is already an array of strings
                    let eventIDs = user.events
                    print("User event IDs: \(eventIDs)")

                    // Fetch full event details for each event ID
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
            // Filter for upcoming events and assign to upcomingEvents
            self.upcomingEvents = fetchedEvents.filter { $0.date > Date() }
            
            // Log to confirm upcoming events were updated
            print("Updated upcomingEvents: \(self.upcomingEvents.count)")
        }
    }

}
