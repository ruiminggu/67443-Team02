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

struct ContentView: View {
    @StateObject private var homePageViewModel = HomePageViewModel(menuDatabase: MenuDatabase(
        recipes: [],
        recommendedRecipes: [
            Recipe(
                title: "Grilled Cheese Sandwich",
                description: "A delicious grilled cheese.",
                image: "grilledcheese",
                instruction: "Cook on medium heat...",
                ingredients: []
            ),
            Recipe(
                title: "Sausage Fried Rice",
                description: "How to make sausgae fried rice",
                image: "sausage",
                instruction: "Cook on medium heat...",
                ingredients: []
            ),
            Recipe(
                title: "French Toast",
                description: "How to make french toast",
                image: "frenchtoast",
                instruction: "Cook on medium heat...",
                ingredients: []
            ),
            Recipe(
                title: "Mac & Cheese",
                description: "How to make Mac & Cheese",
                image: "maccheese",
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
                        homePageViewModel.fetchUser(userID: "8E23D734-2FBE-4D1E-99F7-00279E19585B") // Replace with your logic for fetching the user ID
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
            CostView()
                .tabItem {
                    Image(systemName: "creditcard")
                    Text("Costs")
                }

            // Profile Tab
            ProfileView(viewModel: homePageViewModel)
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("Profile")
                }
        }
        .accentColor(.orange)
        .onAppear {
            homePageViewModel.fetchUser(userID: "8E23D734-2FBE-4D1E-99F7-00279E19585B") // Replace with your logic for user ID retrieval
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
