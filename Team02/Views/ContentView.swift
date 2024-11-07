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
                        homePageViewModel.fetchUser(userID: "8E23D734-2FBE-4D1E-99F7-00279E19585B") // Replace with your logic for fetching the user ID
                    }
            } else {
                Text("Loading...")
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
            }

          NavigationView {
              ScrollView {
                  VStack(alignment: .leading, spacing: 20) {
                      Text("My Events")
                          .font(.system(size: 34, weight: .bold))
                          .foregroundColor(.orange)
                          .padding(.horizontal)
                          .padding(.top)
                      
                      Text("Upcoming Events")
                          .font(.system(size: 20, weight: .semibold))
                          .foregroundColor(.orange)
                          .padding(.horizontal)
                      
                      MyEventCard(
                          eventName: "Grad Dinner",
                          date: "Friday, 25 November",
                          attendeeCount: 6,
                          isUpcoming: true
                      )
                      
                      Text("Past Events")
                          .font(.system(size: 20, weight: .semibold))
                          .foregroundColor(.orange)
                          .padding(.horizontal)
                          .padding(.top)
                      
                      MyEventCard(
                          eventName: "CNY Dinner",
                          date: "Monday, 24 October",
                          attendeeCount: 9,
                          isUpcoming: false
                      )
                      
                      MyEventCard(
                          eventName: "ABB Brunch",
                          date: "Sunday, 22 March",
                          attendeeCount: 2,
                          isUpcoming: false
                      )
                      
                      MyEventCard(
                          eventName: "Haloween Dinner",
                          date: "Tuesday, 16 January",
                          attendeeCount: 7,
                          isUpcoming: false
                      )
                  }
              }
          }
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
            homePageViewModel.fetchUser(userID: "8E23D734-2FBE-4D1E-99F7-00279E19585B") // Replace with your logic for user ID retrieval
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
