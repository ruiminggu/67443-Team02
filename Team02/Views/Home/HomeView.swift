import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomePageViewModel

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    HStack {
                        Image(viewModel.user?.image ?? "profile_pic")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading) {
                            Text("Hello, \(viewModel.user?.fullName ?? "Guest")")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("Welcome back!")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "bell")
                            .font(.title2)
                    }
                    .padding(.horizontal)
                    
                    // Search Bar
                    HStack {
                        TextField("Search dishes or menu", text: .constant(""))
                            .padding(10)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                  
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Upcoming Events")
                            .font(.headline)
                            .padding(.horizontal)
                      
                      ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(viewModel.upcomingEvents, id: \.id) { event in
                                if let userID = viewModel.user?.id {
                                    EventCard(
                                        event: event,
                                        backgroundColor: viewModel.upcomingEvents.firstIndex(of: event)?.isMultiple(of: 2) ?? false ? Color.orange : Color.orange.opacity(0.3),
                                        userID: userID // Pass the current user's ID
                                    )
                                    .frame(width: 300)
                                } else {
                                    Text("User ID not available")
                                }
                            }
                        }
                      }
                    }
                    
                    // Categories Section
                    Text("Categories")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 20) {
                        CategoryIcon(name: "Breakfast", systemImage: "sunrise.fill")
                        CategoryIcon(name: "Lunch", systemImage: "takeoutbag.and.cup.and.straw")
                        CategoryIcon(name: "Dinner", systemImage: "fork.knife")
                        CategoryIcon(name: "Dessert", systemImage: "birthday.cake")
                        CategoryIcon(name: "Western", systemImage: "globe.americas")
                        CategoryIcon(name: "Asian", systemImage: "globe.asia.australia")
                        CategoryIcon(name: "Drinks", systemImage: "wineglass")
                        CategoryIcon(name: "Meat", systemImage: "flame")
                    }
                    .padding(.horizontal)
                    
                    // Recommended Recipes Section
                    Text("Easy & Simple Recipes")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(viewModel.recommendedRecipes) { recipe in
                                RecipeCard(recipe: recipe)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
}
