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
    let sampleUserID = UUID()
    var body: some View {
        TabView {
            
            // Home Tab
            HomeView(viewModel: HomePageViewModel(
                user: User(
                    id: sampleUserID, // New unique ID for the user
                    fullName: "Cindy Doe",
                    image: "profile_pic",
                    email: "cindy.d@gmail.com",
                    password: "password",
                    events: [
                        Event(
                            invitedFriends: [],
                            recipes: [],
                            date: Date().addingTimeInterval(86400), // Tomorrow
                            time: Date(),
                            location: "Home",
                            eventName: "Grad Dinner",
                            qrCode: "",
                            costs: [],
                            totalCost: 0.0,
                            assignedIngredientsList: [
                                Ingredient(name: "Water", unit: 1.0, isChecked: false, userID: sampleUserID),
                                Ingredient(name: "Milk", unit: 2.0, isChecked: false, userID: sampleUserID),
                                Ingredient(name: "Cheese", unit: 1.0, isChecked: true, userID: sampleUserID)
                            ]
                        ),
                        Event(
                            invitedFriends: [],
                            recipes: [],
                            date: Date().addingTimeInterval(172800), // Day after tomorrow
                            time: Date(),
                            location: "Cafe",
                            eventName: "Coffee Meetup",
                            qrCode: "",
                            costs: [],
                            totalCost: 0.0,
                            assignedIngredientsList: [
                                Ingredient(name: "Coffee Beans", unit: 0.5, isChecked: false, userID: sampleUserID),
                                Ingredient(name: "Milk", unit: 1.0, isChecked: true, userID: sampleUserID)
                            ]
                        )
                    ]
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
            
            // Events Tab
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
