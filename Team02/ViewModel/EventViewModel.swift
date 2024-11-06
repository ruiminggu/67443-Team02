import Foundation
import SwiftUI
import FirebaseDatabase

class EventViewModel: ObservableObject {
    @Published var eventName = ""
    @Published var selectedDate = Date()
    @Published var selectedStartTime = Date()
    @Published var selectedEndTime = Date()
    @Published var invitedFriends: [UUID: Bool] = [:]
    @Published var events: [Event] = []
    @Published var eventLocation = ""
    @Published var currentEventID: UUID?

    private var databaseRef: DatabaseReference = Database.database().reference()

    init() {
        fetchEvents()
    }

    // Fetch events from the database
    func fetchEvents() {
        databaseRef.child("events").observeSingleEvent(of: .value) { snapshot in
            var fetchedEvents: [Event] = []

            // Ensure snapshot has children and iterate over them
            for child in snapshot.children.allObjects as? [DataSnapshot] ?? [] {
                if let eventData = child.value as? [String: Any],
                   let event = Event(dictionary: eventData) {
                    fetchedEvents.append(event)
                }
            }

            DispatchQueue.main.async {
                self.events = fetchedEvents
            }
        }
    }

  func saveEvent() {
      // Convert `invitedFriends` dictionary to an array of invited friend IDs
      let invitedFriendIDs = invitedFriends.compactMap { (friendID, isInvited) in
          isInvited ? friendID.uuidString : nil
      }

      let newEvent = Event(
          invitedFriends: invitedFriendIDs, // Pass the invited friend IDs here
          recipes: [],
          date: selectedDate,
          startTime: selectedStartTime,
          endTime: selectedEndTime,
          location: eventLocation,
          eventName: eventName,
          qrCode: "",
          costs: [],
          totalCost: 0.0,
          assignedIngredientsList: []
      )

      // Convert the event to a dictionary and save it to Firebase
      let eventID = newEvent.id.uuidString
      databaseRef.child("events").child(eventID).setValue(newEvent.toDictionary()) { error, _ in
          if let error = error {
              print("Error saving event: \(error.localizedDescription)")
          } else {
              print("Event saved successfully with invited friends!")
          }
      }
  }


    func toggleFriendInvitation(friendID: UUID) {
        invitedFriends[friendID] = !(invitedFriends[friendID] ?? false)
    }
}
