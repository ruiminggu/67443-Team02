//
//  IngredientsSectionView.swift
//  Team02
//
//  Created by Xinyi Chen on 11/4/24.
//

import SwiftUI

struct IngredientsSectionView: View {
    @State private var showAddIngredients = false
    let event: Event
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
        Text("Ingredients")
            .font(.system(size: 28, weight: .bold))
            .foregroundColor(.orange)
            
            // Ingredients List
            if event.assignedIngredientsList.isEmpty {
//                Text("No ingredients added yet")
//                    .foregroundColor(.gray)
//                    .padding(.vertical)
            } else {
                ForEach(event.assignedIngredientsList) { ingredient in
                    IngredientRow(ingredient: ingredient)
                }
            }
        }
        .padding(.horizontal)
        .sheet(isPresented: $showAddIngredients) {
            AddIngredientsView(
                eventID: event.id.uuidString,
                userID: UUID() // Replace with actual current user ID if needed
            )
        }
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
}

struct IngredientRow: View {
    let ingredient: Ingredient
    
    var body: some View {
        HStack {
            // Ingredient name and amount
            VStack(alignment: .leading, spacing: 4) {
                Text(ingredient.name)
                    .font(.system(size: 16, weight: .medium))
                
                Text("\(String(format: "%.1f", ingredient.amount))")
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

// Preview Provider
struct IngredientsSectionView_Previews: PreviewProvider {
    static var sampleIngredients = [
        Ingredient(
            name: "Tomatoes",
            unit: 1.0,
            isChecked: false,
            userID: UUID(),
            amount: 5.0
        ),
        Ingredient(
            name: "Onions",
            unit: 1.0,
            isChecked: true,
            userID: UUID(),
            amount: 2.0
        )
    ]
    
    static var sampleEvent = Event(
        id: UUID(),
        invitedFriends: [],
        recipes: [],
        date: Date(),
        startTime: Date(),
        endTime: Date(),
        location: "Home",
        eventName: "Sample Event",
        qrCode: "",
        costs: [],
        totalCost: 0.0,
        assignedIngredientsList: sampleIngredients
    )
    
    static var previews: some View {
        Group {
            // Preview with ingredients
            IngredientsSectionView(event: sampleEvent)
                .previewDisplayName("With Ingredients")
            
            // Preview empty state
            IngredientsSectionView(
                event: Event(
                    id: UUID(),
                    invitedFriends: [],
                    recipes: [],
                    date: Date(),
                    startTime: Date(),
                    endTime: Date(),
                    location: "Home",
                    eventName: "Empty Event",
                    qrCode: "",
                    costs: [],
                    totalCost: 0.0,
                    assignedIngredientsList: []
                )
            )
            .previewDisplayName("Empty State")
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}

//struct IngredientsSectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        IngredientsSectionView()
//    }
//}
