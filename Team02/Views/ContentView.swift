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
    @StateObject private var homePageViewModel = HomePageViewModel(menuDatabase: MenuDatabase(
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
    ))

    var body: some View {
        TabView {
            // Home Tab
            if let user = homePageViewModel.user {
                HomeView(viewModel: homePageViewModel)
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                    .onAppear {
                        homePageViewModel.fetchUser(userID: user.id.uuidString) // Replace with your logic for fetching the user ID
                    }
            } else {
                Text("Loading...")
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
            }

            // Events Tab
            EventView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Events")
                }

            // Create Event Tab
            DateSelectionView(viewModel: EventViewModel())
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
        .onAppear {
            homePageViewModel.fetchUser(userID: "your-user-id-here") // Replace with your logic for user ID retrieval
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
