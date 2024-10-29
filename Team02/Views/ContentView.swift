import SwiftUI

struct EventView: View {
    var body: some View {
        Text("Events Screen")
            .font(.title)
    }
}

struct CreateEventView: View {
    var body: some View {
        Text("Create Event Screen")
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
                            users: [], // Assuming no other users for now
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
                            users: [], // Assuming no other users for now
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
            EventView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Events")
                }
            
            // Create Event Tab
            CreateEventView()
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
        .accentColor(.orange) // Set the selected tab color
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
