//
//  EventDetailViewModel.swift
//  Team02
//
//  Created by Xinyi Chen on 11/8/24.
//

import Foundation
import FirebaseDatabase

class EventDetailViewModel: ObservableObject {
    @Published var event: Event?
    @Published var attendees: [User] = []
    @Published var isLoading = false
    @Published var error: String?
    
    private var databaseRef: DatabaseReference = Database.database().reference()
      
    init() {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(refreshEventDetails),
                name: NSNotification.Name("RefreshEventDetail"),
                object: nil
            )
    }
  
    @objc private func refreshEventDetails() {
          if let currentEvent = event {
              fetchEventDetails(eventID: currentEvent.id.uuidString)
          }
      }
  
//    func fetchEventDetails(eventID: String) {
//        print("📱 Starting to fetch event details for ID: \(eventID)")
//        isLoading = true
//        
//        // Use observeSingleEvent instead of observe to prevent multiple callbacks
//        databaseRef.child("events").child(eventID).observeSingleEvent(of: .value) { [weak self] snapshot, _ in
//            guard let self = self else { return }
//            
//            DispatchQueue.main.async {
//                self.isLoading = false
//                
//                guard let eventData = snapshot.value as? [String: Any] else {
//                    print("❌ No event data found for ID: \(eventID)")
//                    self.error = "Failed to load event data"
//                    return
//                }
//                
//                guard let event = Event(dictionary: eventData) else {
//                    print("❌ Failed to parse event data")
//                    self.error = "Failed to parse event data"
//                    return
//                }
//                
//                print("✅ Successfully fetched event: \(event.eventName)")
//                print("📱 Event details:")
//                print("- Date: \(event.date)")
//                print("- Location: \(event.location)")
//                print("- Recipes count: \(event.recipes.count)")
//                print("- Invited friends count: \(event.invitedFriends.count)")
//                
//                self.event = event
//                self.fetchAttendees(invitedFriends: event.invitedFriends)
//            }
//        }
//    }
    func fetchEventDetails(eventID: String) {
            isLoading = true
            databaseRef.child("events").child(eventID).observe(.value) { [weak self] snapshot in
                guard let self = self,
                      let eventData = snapshot.value as? [String: Any],
                      let event = Event(dictionary: eventData) else {
                    self?.error = "Failed to fetch event details"
                    self?.isLoading = false
                    return
                }
                
                DispatchQueue.main.async {
                    self.event = event
                    self.isLoading = false
                }
            }
        }

    private func fetchAttendees(invitedFriends: [String]) {
        guard !invitedFriends.isEmpty else {
            print("ℹ️ No invited friends to fetch")
            return
        }
        
        print("📱 Fetching \(invitedFriends.count) attendees")
        let dispatchGroup = DispatchGroup()
        var fetchedAttendees: [User] = []
        
        for friendID in invitedFriends {
            dispatchGroup.enter()
            
            databaseRef.child("users").child(friendID).observeSingleEvent(of: .value) { snapshot, _ in
                defer { dispatchGroup.leave() }
                
                if let userData = snapshot.value as? [String: Any],
                   let user = User(dictionary: userData) {
                    fetchedAttendees.append(user)
                    print("✅ Fetched attendee: \(user.fullName)")
                } else {
                    print("❌ Failed to fetch attendee with ID: \(friendID)")
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.attendees = fetchedAttendees
            print("✅ Finished fetching all attendees. Count: \(fetchedAttendees.count)")
        }
    }
  
    deinit {
          NotificationCenter.default.removeObserver(self)
    }
}
