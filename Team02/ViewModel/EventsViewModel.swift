//
//  EventsViewModel.swift
//  Team02
//
//  Created by Xinyi Chen on 11/7/24.
//

import Foundation
import FirebaseDatabase

class EventsViewModel: ObservableObject {
    @Published var user: User?
    @Published var upcomingEvents: [Event] = []
    @Published var pastEvents: [Event] = []
    
    private var databaseRef: DatabaseReference = Database.database().reference()
    
    init() {
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
            let now = Date()
            
            // Sort and categorize events
            self.upcomingEvents = fetchedEvents
                .filter { $0.date > now }
                .sorted { $0.date < $1.date }
            
            self.pastEvents = fetchedEvents
                .filter { $0.date <= now }
                .sorted { $0.date > $1.date }
            
            // Log to confirm events were updated
            print("Updated events - Upcoming: \(self.upcomingEvents.count), Past: \(self.pastEvents.count)")
        }
    }
}
