import SwiftUI

struct InviteFriendsView: View {
    @ObservedObject var viewModel: EventViewModel
    @ObservedObject var userViewModel = UserViewModel() // Add UserViewModel to fetch users
    @State private var searchText = ""
    
    // Filtered list of friends based on search text
    var filteredFriends: [User] {
        if searchText.isEmpty {
            return userViewModel.users // Use fetched users from UserViewModel
        } else {
            return userViewModel.users.filter { $0.fullName.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            
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
                        Text(friend.email)
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
            VStack(spacing: 15) {
                
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
                
                // Save Event Button - triggers saving to the database
                Button(action: {
                    viewModel.saveEvent() // Save the event to the database
                }) {
                    Text("Save Event")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(10)
                }
              
            }
            .padding(.horizontal)

            Spacer()
        }
        .onAppear {
            userViewModel.fetchUsers() // Fetch users when view appears
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct InviteFriendsView_Previews: PreviewProvider {
    static var previews: some View {
        InviteFriendsView(viewModel: EventViewModel())
    }
}
