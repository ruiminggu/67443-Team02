import SwiftUI

struct EventView: View {
    var body: some View {
        Text("Events Screen")
            .font(.title)
    }
}

struct CostView: View {
    var body: some View {
        Text("Costs Screen")
            .font(.title)
    }
}

struct ProfileView: View {
    var body: some View {
        Text("Profile Screen")
            .font(.title)
    }
}

struct ContentView: View {
    @StateObject private var eventViewModel = EventViewModel() // Create an instance of EventViewModel

    var body: some View {
        TabView {
            // Home Tab
            HomeView(viewModel: HomePageViewModel(
                user: User(
                    id: UUID(), // Replace with actual user ID if needed
                    fullName: "Cindy Doe",
                    image: "profile_pic",
                    email: "cindy.d@gmail.com",
                    password: "password",
                    events: eventViewModel.events // Use events from EventViewModel
                ),
                menuDatabase: MenuDatabase(
                    recipes: [],
                    recommendedRecipes: [
                        Recipe(
                            title: "Grilled Cheese Sandwich",
                            description: "A delicious grilled cheese.",
                            image: "grilled_cheese",
                            instruction: "Cook on medium heat...",
                            ingredients: []
                        )
                    ]
                )
            ))
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            .onAppear {
                eventViewModel.fetchEvents() // Fetch events when HomeView appears
            }

            // Events Tab
            EventView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Events")
                }

            // Create Event Tab
            DateSelectionView(viewModel: eventViewModel) // Pass the eventViewModel
                .tabItem {
                    ZStack {
                        Circle()
                            .fill(Color.orange.opacity(0.4))
                            .frame(width: 50, height: 50)
                        Image(systemName: "plus")
                            .foregroundColor(.orange)
                    }
                }

            // Costs Tab
            CostView()
                .tabItem {
                    Image(systemName: "creditcard")
                    Text("Costs")
                }

            // Profile Tab
            ProfileView()
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("Profile")
                }
        }
        .accentColor(.orange)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
