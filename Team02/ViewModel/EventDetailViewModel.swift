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
    @Published var events: [Event] = []
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
            guard let currentUserID = UserDefaults.standard.string(forKey: "currentUserUUID") else {
                self.error = "User not logged in"
                return
            }
    
            isLoading = true
      
            if let handle = eventListener {
                databaseRef.child("events").child(eventID).removeObserver(withHandle: handle)
            }
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
  
    func fetchUserEvents() {
          guard let userID = UserDefaults.standard.string(forKey: "currentUserUUID") else {
              self.error = "User not logged in"
              return
          }
          
          isLoading = true
          
          databaseRef.child("users").child(userID).child("events").observeSingleEvent(of: .value) { [weak self] snapshot, _ in
              guard let self = self,
                    let eventIDs = snapshot.value as? [String] else {
                  self?.isLoading = false
                  return
              }
              
              // Fetch each event's details
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
                  self.events = fetchedEvents
                  self.isLoading = false
              }
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
