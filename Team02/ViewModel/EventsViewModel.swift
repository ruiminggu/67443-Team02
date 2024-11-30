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
    @Published var isLoading = false
    @Published var error: String?
    
    private var databaseRef: DatabaseReference = Database.database().reference()
    
    init() {
    }
    
    func fetchUser(userID: String) {
        isLoading = true
      
        print("Fetching user with ID: \(userID)")
        
      databaseRef.child("users").child(userID).child("events").observeSingleEvent(of: .value) { [weak self] snapshot, _ in
                  guard let self = self,
                        let eventIDs = snapshot.value as? [String] else {
                      self?.isLoading = false
                      return
                  }
                  
                  let dispatchGroup = DispatchGroup()
                  var fetchedEvents: [Event] = []
                  
                  for eventID in eventIDs {
                      dispatchGroup.enter()
                      self.databaseRef.child("events").child(eventID).observeSingleEvent(of: .value) { snapshot in
                          if let eventData = snapshot.value as? [String: Any],
                             let event = Event(dictionary: eventData) {
                              fetchedEvents.append(event)
                          }
                          dispatchGroup.leave()
                      }
                  }
                  
                  dispatchGroup.notify(queue: .main) {
                      let now = Date()
                      self.upcomingEvents = fetchedEvents.filter { $0.date > now }
                      self.pastEvents = fetchedEvents.filter { $0.date <= now }
                      self.isLoading = false
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
