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
    private var eventListener: DatabaseHandle?
      
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
  
    func fetchEventDetails(eventID: String) {
            isLoading = true
      
            if let handle = eventListener {
                databaseRef.child("events").child(eventID).removeObserver(withHandle: handle)
            }
//            databaseRef.child("events").child(eventID).observe(.value) { [weak self] snapshot in
//                guard let self = self,
//                      let eventData = snapshot.value as? [String: Any],
//                      let event = Event(dictionary: eventData) else {
//                    self?.error = "Failed to fetch event details"
//                    self?.isLoading = false
//                    return
//                }
//                
//                DispatchQueue.main.async {
//                    self.event = event
//                    self.isLoading = false
//                }
//            }
            eventListener = databaseRef.child("events").child(eventID).observe(.value) { [weak self] snapshot in
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
//          NotificationCenter.default.removeObserver(self)
            if let eventID = event?.id.uuidString,
                 let handle = eventListener {
                  databaseRef.child("events").child(eventID).removeObserver(withHandle: handle)
            }
    }
}
