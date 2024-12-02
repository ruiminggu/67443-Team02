import SwiftUI
import FirebaseAuth

struct CostView: View {
    var body: some View {
        Text("Costs Screen")
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
                image: "grilledcheese",
                instruction: "Cook on medium heat...",
                ingredients: [],
                readyInMinutes: 20,
                servings: 2
            ),
            Recipe(
                title: "Sausage Fried Rice",
                description: "How to make sausage fried rice",
                image: "sausage",
                instruction: "Cook on medium heat...",
                ingredients: [],
                readyInMinutes: 20,
                servings: 3
            ),
            Recipe(
                title: "French Toast",
                description: "How to make french toast",
                image: "frenchtoast",
                instruction: "Cook on medium heat...",
                ingredients: [],
                readyInMinutes: 15,
                servings: 2
            ),
            Recipe(
                title: "Mac & Cheese",
                description: "How to make Mac & Cheese",
                image: "maccheese",
                instruction: "Cook on medium heat...",
                ingredients: [],
                readyInMinutes: 25,
                servings: 4
            )
        ]
    ))
  
      @StateObject private var profileViewModel = ProfileViewModel()
      @StateObject private var costSplitViewModel = CostSplitViewModel()
      @State private var isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn") // Track login state

      var body: some View {
          if !isLoggedIn {
              // Show the account creation view
              CreateAccountView {
                  isLoggedIn = true
                  UserDefaults.standard.set(true, forKey: "isLoggedIn")
              }
          } else {
            // Show the main app interface
            TabView {
                // Home Tab
                if let user = homePageViewModel.user {
                    HomeView(viewModel: homePageViewModel)
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("Home")
                        }
                } else {
                    Text("Loading...")
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("Home")
                        }
                }

                // Events Tab
                MyEventsView()
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
              CostSplitView()
                                 .environmentObject(costSplitViewModel) 
                                 .tabItem {
                                     Image(systemName: "creditcard")
                                     Text("Costs")
                                 }

                // Profile Tab
                ProfileView(viewModel: profileViewModel)
                    .tabItem {
                        Image(systemName: "person.circle")
                        Text("Profile")
                    }
            }
            .accentColor(.orange)
            .onAppear {
                // Fetch the user's UUID from UserDefaults
                if let userUUID = UserDefaults.standard.string(forKey: "currentUserUUID") {
                    print("📱 Using current user's UUID: \(userUUID)")
                    homePageViewModel.fetchUser() // Fetch user data using UUID
                } else {
                    print("⚠️ No UUID found in UserDefaults")
                    isLoggedIn = false
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
