import Foundation
import SwiftUI

class EventViewModel: ObservableObject {
    @Published var eventName = ""
    @Published var selectedDate = Date()
    @Published var selectedTime = Date()
    
    // Dictionary to store invitation status with UUID as key and Bool as value.
    @Published var invitedFriends: [UUID: Bool] = [:]
    
    // Toggle invitation status of a friend by their ID.
    func toggleFriendInvitation(friendID: UUID) {
        if invitedFriends[friendID] == true {
            invitedFriends[friendID] = false
        } else {
            invitedFriends[friendID] = true
        }
    }
    
    // Optional functions for adding and removing friends in a different context
    func addFriend(_ friend: User) {
        invitedFriends[friend.id] = true
    }
    
    func removeFriend(_ friend: User) {
        invitedFriends[friend.id] = false
    }
  
}
