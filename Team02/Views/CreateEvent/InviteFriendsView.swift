import SwiftUI

struct InviteFriendsView: View {
    @ObservedObject var viewModel: EventViewModel
    @State private var searchText = ""
    
    // Hardcoded list of friends for testing
    let friends = [
        User(id: UUID(), fullName: "Kevin", image: "kevin_image", email: "kevin@example.com", password: "password", events: []),
        User(id: UUID(), fullName: "Amy", image: "amy_image", email: "amy@example.com", password: "password", events: []),
        User(id: UUID(), fullName: "Betty", image: "betty_image", email: "betty@example.com", password: "password", events: [])
    ]
    
    var filteredFriends: [User] {
        if searchText.isEmpty {
            return friends
        } else {
            return friends.filter { $0.fullName.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
      VStack(spacing: 20) {
            // Event Name Section
            VStack(spacing: 20) {
              Text("Event Name")
                  .font(.title)
                  .fontWeight(.bold)
                  .foregroundColor(.orange)
                  .padding(.top)
                
                TextField("Enter event name", text: $viewModel.eventName)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            .padding(.top)
            
            // Invite Friends Section
            Text("Invite friends!")
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(.orange)
            .padding(.top)
            
            // Search Bar
            TextField("Search by names or contact", text: $searchText)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
            
            // Friends List
            List(filteredFriends, id: \.id) { friend in
                HStack {
                    VStack(alignment: .leading) {
                        Text(friend.fullName)
                            .font(.headline)
                        Text(friend.email) // Assuming email as the secondary detail
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Button(action: {
                        viewModel.toggleFriendInvitation(friendID: friend.id)
                    }) {
                        Image(systemName: viewModel.invitedFriends[friend.id, default: false] ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(.orange)
                            .font(.title2)
                    }
                }
                .padding(.vertical, 5)
            }
            .listStyle(PlainListStyle())
            
            // Invite and Create QR Code Buttons
            VStack(spacing: 8) {
                Button(action: {
                    // Action for inviting friends
                }) {
                    Text("Invite")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(10)
                }
                
                NavigationLink(destination: QRCodeView(viewModel: viewModel)) {
                    Text("Create QR Code")
                        .foregroundColor(.orange)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.clear)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.orange, lineWidth: 2)
                        )
                }
                Button(action: {viewModel.saveEvent()}) {
                    Text("Save Event")
                       .foregroundColor(.white)
                       .frame(maxWidth: .infinity)
                       .padding()
                       .background(Color.orange)
                       .cornerRadius(10)
                    }
                  
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top)
            
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct InviteFriendsView_Previews: PreviewProvider {
    static var previews: some View {
        InviteFriendsView(viewModel: EventViewModel())
    }
}
