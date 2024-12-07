//
//  IngredientsSectionView.swift
//  Team02
//
//  Created by Xinyi Chen on 11/4/24.
//

import SwiftUI

struct IngredientsSectionView: View {
    @StateObject private var viewModel = EventDetailViewModel()
    @State private var showAddIngredients = false
    @State private var assignmentsMap: [String: String] = [:]
    let event: Event
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            Text("Ingredients")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.orange)
            
            // Ingredients List with Assignments and Checkboxes
            if event.assignedIngredientsList.isEmpty {
                // Empty state handling
                Text("No ingredients added yet")
                    .foregroundColor(.gray)
                    .padding(.vertical)
            } else {
                ForEach(event.assignedIngredientsList) { ingredient in
                    IngredientAssignmentRow(
                        ingredient: ingredient,
                        attendees: viewModel.attendees,
                        eventId: event.id.uuidString,
                        selectedUserId: Binding(
                            get: { assignmentsMap[ingredient.id] ?? ingredient.userID },
                            set: { newValue in
                                assignmentsMap[ingredient.id] = newValue
                                viewModel.updateIngredientAssignment(
                                    eventId: event.id.uuidString,
                                    ingredientId: ingredient.id,
                                    assignedUserId: newValue ?? ingredient.userID
                                )
                            }
                        ),
                        viewModel: viewModel
                    )
                }
            }
            
            // Add Ingredient Button
            HStack {
                Spacer()
                Button(action: {
                    showAddIngredients = true
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.orange.opacity(0.2))
                            .frame(width: 60, height: 60)
                        
                        Image(systemName: "plus")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(.orange)
                    }
                }
                Spacer()
            }
        }
        .padding(.horizontal)
        .sheet(isPresented: $showAddIngredients) {
            AddIngredientsView(
                eventID: event.id.uuidString,
                userID: UUID() // Replace with actual current user ID if needed
            )
        }
        .onAppear {
            print("IngredientsSectionView appeared")
            print("Invited friends count: \(event.invitedFriends.count)")
            viewModel.fetchAttendees(invitedFriends: event.invitedFriends)
            event.assignedIngredientsList.forEach { ingredient in
                print("Initializing assignment for: \(ingredient.name)")
                assignmentsMap[ingredient.id] = ingredient.userID
            }
        }
    }
}

struct Checkbox: View {
    var isChecked: Bool
    
    var body: some View {
        Image(systemName: isChecked ? "checkmark.square.fill" : "square")
            .foregroundColor(isChecked ? .orange : .gray)
    }
}

struct IngredientAssignmentRow: View {
    let ingredient: Ingredient
    let attendees: [User]
    let eventId: String
    @Binding var selectedUserId: String?
    @ObservedObject var viewModel = EventDetailViewModel()
    @State private var isChecked: Bool
  
    init(ingredient: Ingredient, attendees: [User], eventId: String, selectedUserId: Binding<String?>, viewModel: EventDetailViewModel) {
          self.ingredient = ingredient
          self.attendees = attendees
          self.eventId = eventId
          self._selectedUserId = selectedUserId
          self.viewModel = viewModel
          self._isChecked = State(initialValue: ingredient.isChecked)  // Initialize with ingredient's value
      }
  
    var body: some View {
        HStack {
            Button(action: {
                isChecked.toggle()
                let updatedIngredient = Ingredient(
                    id: ingredient.id,
                    name: ingredient.name,
                    isChecked: isChecked,
                    userID: ingredient.userID,
                    amount: ingredient.amount
                )
                viewModel.updateIngredientCheckStatus(eventId: eventId, ingredient: updatedIngredient)
            }) {
//                Image(systemName: ingredient.isChecked ? "checkmark.square.fill" : "square")
//                    .foregroundColor(ingredient.isChecked ? .orange : .gray)
              Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                                  .foregroundColor(isChecked ? .orange : .gray)
            }
          
//            Image(systemName: ingredient.isChecked ? "checkmark.square.fill" : "square")
//                .foregroundColor(ingredient.isChecked ? .orange : .gray)
            Text(ingredient.name)
            Spacer()
            Text(ingredient.amount)
            
            Menu {
                ForEach(attendees) { user in
                    Button(action: {
                        print("Selected user: \(user.fullName)")
                        selectedUserId = user.id.uuidString
                    }) {
                        HStack {
                            Text(user.fullName)
                            if selectedUserId == user.id.uuidString {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack {
                    if let assignedUser = attendees.first(where: { $0.id.uuidString == selectedUserId }) {
                        Text(assignedUser.fullName)
                            .foregroundColor(.gray)
                        Image(assignedUser.image)
                            .resizable()
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.crop.circle.badge.plus")
                            .foregroundColor(.gray)
                            .font(.system(size: 24))
                    }
                }
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
            .onAppear {
                print("Ingredient in row:")
                print("ID: \(ingredient.id)")
                print("Name: \(ingredient.name)")
                print("Current userID: \(ingredient.userID)")
            }
        }
        .padding()
        .onAppear {
            print("IngredientAssignmentRow appeared")
            print("Attendees count: \(attendees.count)")
            print("Attendees: \(attendees.map { $0.fullName })")
        }
    }
}

struct IngredientRow: View {
    let ingredient: Ingredient
    
    var body: some View {
        HStack {
            // Ingredient name and amount
            VStack(alignment: .leading, spacing: 4) {
                Text(ingredient.name)
                    .font(.system(size: 16, weight: .medium))
                
                Text(ingredient.amount)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Checkbox (if you want to implement checking off ingredients)
            Image(systemName: ingredient.isChecked ? "checkmark.circle.fill" : "circle")
                .foregroundColor(ingredient.isChecked ? .orange : .gray)
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.5))
        .cornerRadius(10)
    }
}

//// Preview Provider
//struct IngredientsSectionView_Previews: PreviewProvider {
//    static var sampleUsers = [
//        User(
//            id: UUID(),
//            fullName: "John Doe",
//            image: "profile_pic",
//            email: "john@example.com",
//            password: "password",
//            events: [],
//            likedRecipes: []
//        ),
//        User(
//            id: UUID(),
//            fullName: "Jane Smith",
//            image: "profile_pic",
//            email: "jane@example.com",
//            password: "password",
//            events: [],
//            likedRecipes: []
//        )
//    ]
//    
//  static var sampleIngredients = [
//      Ingredient(
//          id: UUID().uuidString,
//          name: "Tomatoes",
//          amount: "5.0",
//          isChecked: false,
//          userID: sampleUsers[0].id.uuidString  // Changed to string
//      ),
//      Ingredient(
//          id: UUID().uuidString,
//          name: "Onions",
//          amount: "2.0",
//          isChecked: true,
//          userID: sampleUsers[1].id.uuidString  // Changed to string
//      )
//  ]
//    
//    static var sampleEvent = Event(
//        id: UUID(),
//        invitedFriends: sampleUsers.map { $0.id.uuidString },
//        recipes: [],
//        date: Date(),
//        startTime: Date(),
//        endTime: Date(),
//        location: "Home",
//        eventName: "Sample Event",
//        qrCode: "",
//        costs: [],
//        totalCost: 0.0,
//        assignedIngredientsList: sampleIngredients
//    )
//    
//    static var previews: some View {
//        Group {
//            // Preview with ingredients and assignments
//            IngredientsSectionView(event: sampleEvent)
//                .previewDisplayName("With Assignments")
//                .onAppear {
//                    // Simulate fetched attendees in the view model
//                    let viewModel = EventDetailViewModel()
//                    viewModel.attendees = sampleUsers
//                }
//            
//            // Empty state preview
//            IngredientsSectionView(
//                event: Event(
//                    id: UUID(),
//                    invitedFriends: [],
//                    recipes: [],
//                    date: Date(),
//                    startTime: Date(),
//                    endTime: Date(),
//                    location: "Home",
//                    eventName: "Empty Event",
//                    qrCode: "",
//                    costs: [],
//                    totalCost: 0.0,
//                    assignedIngredientsList: []
//                )
//            )
//            .previewDisplayName("Empty State")
//        }
//        .previewLayout(.sizeThatFits)
//        .padding()
//    }
//}

//struct IngredientsSectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        IngredientsSectionView()
//    }
//}
