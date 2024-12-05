import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomePageViewModel
    @State private var showSearchView = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    HStack {
                        if let user = viewModel.user {
                            Image(user.image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading) {
                                Text("Hello, \(user.fullName)")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Text("Welcome back!")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        } else {
                            Text("Loading user data...")
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                  // Search Bar Button
                  Button(action: {
                      showSearchView = true
                  }) {
                      HStack {
                          Image(systemName: "magnifyingglass")
                              .foregroundColor(.gray)
                          Text("Search dishes or menu")
                              .foregroundColor(.gray)
                              .frame(maxWidth: .infinity, alignment: .leading) // Align the text to the left
                      }
                      .padding()
                      .background(Color(.systemGray6))
                      .cornerRadius(10)
                      .frame(maxWidth: .infinity) // Make the button span the full width
                      .padding(.horizontal)
                  }
                  .sheet(isPresented: $showSearchView) {
                      if let userID = viewModel.user?.id.uuidString {
                          HomeRecipeSearchView(userID: userID)
                      } else {
                          Text("User ID not available").font(.headline).foregroundColor(.red) // Fallback in case userID is not set
                      }
                  }

                  
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Upcoming Events")
                            .font(.headline)
                            .padding(.horizontal)
                      
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(viewModel.upcomingEvents, id: \.id) { event in
                                    if let userID = viewModel.user?.id {
                                        NavigationLink(destination: EventDetailView(eventID: event.id.uuidString)) {
                                            EventCard(
                                                event: event,
                                                backgroundColor: viewModel.upcomingEvents.firstIndex(of: event)?.isMultiple(of: 2) ?? false ? Color.orange : Color.orange.opacity(0.3),
                                                userID: userID
                                            )
                                            .frame(width: 300)
                                        }
                                    } else {
                                        Text("User ID not available")
                                    }
                                }
                            }
                        }
                    }.padding(.horizontal)
                    
                  // Categories Section
                  Text("Categories")
                      .font(.headline)
                      .padding(.horizontal)

                  LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 20) {
                      if let userID = viewModel.user?.id.uuidString {
                          NavigationLink(destination: RecipeListView(category: "Breakfast", userID: userID)) {
                              CategoryIcon(name: "Breakfast", systemImage: "sunrise.fill")
                          }
                          NavigationLink(destination: RecipeListView(category: "Lunch", userID: userID)) {
                              CategoryIcon(name: "Lunch", systemImage: "takeoutbag.and.cup.and.straw")
                          }
                          NavigationLink(destination: RecipeListView(category: "Dinner", userID: userID)) {
                              CategoryIcon(name: "Dinner", systemImage: "fork.knife")
                          }
                          NavigationLink(destination: RecipeListView(category: "Dessert", userID: userID)) {
                              CategoryIcon(name: "Dessert", systemImage: "birthday.cake")
                          }
                          NavigationLink(destination: RecipeListView(category: "Western", userID: userID)) {
                              CategoryIcon(name: "Western", systemImage: "globe.americas")
                          }
                          NavigationLink(destination: RecipeListView(category: "Asian", userID: userID)) {
                              CategoryIcon(name: "Asian", systemImage: "globe.asia.australia")
                          }
                          NavigationLink(destination: RecipeListView(category: "Drinks", userID: userID)) {
                              CategoryIcon(name: "Drinks", systemImage: "wineglass")
                          }
                          NavigationLink(destination: RecipeListView(category: "Meat", userID: userID)) {
                              CategoryIcon(name: "Meat", systemImage: "flame")
                          }
                      } else {
                          Text("User not available")
                      }
                  }
                  .padding(.horizontal)

                    
                    // Recommended Recipes Section
                    Text("Easy & Simple Recipes")
                        .font(.headline)
                        .padding(.horizontal)
                    
                  ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                      ForEach(viewModel.recommendedRecipes, id: \.self) { recipe in
                        NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                          RecipeCard(recipe: recipe)
                              }
                    
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .onAppear {
            // Additional onAppear code can be added here if needed
        }
    }
}
