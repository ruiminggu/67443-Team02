import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @StateObject private var homePageViewModel = HomePageViewModel(menuDatabase: MenuDatabase(
        recipes: [],
        recommendedRecipes: [
            Recipe(
                title: "Grilled Cheese Sandwich",
                description: "A delicious grilled cheese.",
                image: "grilledcheese",
                instruction: "Cook on medium heat...",
                ingredients: [],
                readyInMinutes: 20,
                servings: 2,
                apiId: 0
            ),
            Recipe(
                title: "Sausage Fried Rice",
                description: "How to make sausage fried rice",
                image: "sausage",
                instruction: "Cook on medium heat...",
                ingredients: [],
                readyInMinutes: 20,
                servings: 3,
                apiId: 0
            ),
            Recipe(
                title: "French Toast",
                description: "How to make french toast",
                image: "frenchtoast",
                instruction: "Cook on medium heat...",
                ingredients: [],
                readyInMinutes: 15,
                servings: 2,
                apiId: 0
            ),
            Recipe(
                title: "Mac & Cheese",
                description: "How to make Mac & Cheese",
                image: "maccheese",
                instruction: "Cook on medium heat...",
                ingredients: [],
                readyInMinutes: 25,
                servings: 4,
                apiId: 0
            )
        ]
    ))
  
    @StateObject private var profileViewModel = ProfileViewModel()
    @StateObject private var costSplitViewModel = CostSplitViewModel()
    @State private var isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn") // Track login state

    // Add a @State variable to track the selected tab
    @State private var selectedTab = 0

    var body: some View {
        if !isLoggedIn {
            // Show the account creation view
            CreateAccountView {
                isLoggedIn = true
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
            }
        } else {
            // Show the main app interface
            TabView(selection: $selectedTab) { // Bind TabView to the selectedTab variable
                // Home Tab
                if let user = homePageViewModel.user {
                    HomeView(viewModel: homePageViewModel)
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("Home")
                        }
                        .tag(0) // Assign a tag for each tab
                } else {
                    Text("Loading...")
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("Home")
                        }
                        .tag(0)
                }

                // Events Tab
                MyEventsView()
                    .tabItem {
                        Image(systemName: "calendar")
                        Text("Events")
                    }
                    .tag(1)

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
                    .tag(2)

                // Costs Tab
                CostSplitView()
                    .environmentObject(costSplitViewModel)
                    .tabItem {
                        Image(systemName: "creditcard")
                        Text("Costs")
                    }
                    .tag(3)

                // Profile Tab
                ProfileView(viewModel: profileViewModel)
                    .tabItem {
                        Image(systemName: "person.circle")
                        Text("Profile")
                    }
                    .tag(4)
            }
            .accentColor(.orange)
            .onAppear {
                // Fetch the user's UUID from UserDefaults
                if let userUUID = UserDefaults.standard.string(forKey: "currentUserUUID") {
                    print("📱 Using current user's UUID: \(userUUID)")
                    homePageViewModel.fetchUser() // Fetch user data using UUID
                } else {
                    print("⚠️ No UUID found in UserDefaults")
                    
                }
            }
            // Listen for a notification to switch tabs
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("SwitchToMyEventsTab"))) { _ in
                selectedTab = 1 // Set the tab to Events Tab (MyEventsView)
            }
        }
    }
}
