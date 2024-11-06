import Foundation
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
        // Create a new event instance
        let newEvent = Event(
            invitedFriends: [],
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

        // Convert event ID to string for database compatibility
        let eventID = newEvent.id.uuidString
        // Save event to the "events" node
        databaseRef.child("events").child(eventID).setValue(newEvent.toDictionary()) { error, _ in
            if let error = error {
                print("Error saving event: \(error.localizedDescription)")
            } else {
                print("Event saved successfully!")

                // After saving the event, add the event ID to each invited user's list
                self.addEventToInvitedUsers(eventID: eventID)
            }
        }
    }

    private func addEventToInvitedUsers(eventID: String) {
        for (friendID, isInvited) in invitedFriends where isInvited {
            let friendIDString = friendID.uuidString
            // Append the event ID to each invited user's "events" list in the "users" node
            databaseRef.child("users").child(friendIDString).child("events").observeSingleEvent(of: .value) { snapshot in
                var eventsArray = snapshot.value as? [String] ?? []
                eventsArray.append(eventID) // Add the new event ID

                // Update the user's "events" list with the new event ID
                self.databaseRef.child("users").child(friendIDString).child("events").setValue(eventsArray) { error, _ in
                    if let error = error {
                        print("Error updating user \(friendIDString)'s events: \(error.localizedDescription)")
                    } else {
                        print("Added event \(eventID) to user \(friendIDString)'s events list.")
                    }
                }
            }
        }
    }

    func toggleFriendInvitation(friendID: UUID) {
        invitedFriends[friendID] = !(invitedFriends[friendID] ?? false)
    }
}
