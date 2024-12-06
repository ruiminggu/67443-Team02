import SwiftUI
import FirebaseDatabase

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                .foregroundColor(.white)
                .onTapGesture {
                    configuration.isOn.toggle()
                }
            configuration.label
        }
    }
}

struct EventCard: View {
    @State var event: Event // Make `event` mutable to reflect changes
    var backgroundColor: Color
    let userID: UUID

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(event.eventName)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Spacer()
                Text(event.date, formatter: EventRow.dateFormatter)
                    .font(.subheadline)
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading) {
                Text("TO-DO:")
                    .font(.subheadline)
                    .foregroundColor(.white)

                let filteredIngredients = event.assignedIngredientsList.filter { $0.userID == userID.uuidString }
                let displayedIngredients = Array(filteredIngredients.prefix(4)) // Max 4 items

                if !filteredIngredients.isEmpty {
                    // Display ingredients in rows
                    ForEach(0..<displayedIngredients.count, id: \.self) { index in
                        if index % 2 == 0 {
                            HStack(spacing: 16) {
                                Toggle(isOn: Binding(
                                    get: { displayedIngredients[index].isChecked },
                                    set: { newValue in
                                        toggleIngredient(at: index, newValue: newValue, in: filteredIngredients)
                                    }
                                )) {
                                    Text(displayedIngredients[index].name)
                                        .foregroundColor(.white)
                                        .lineLimit(1)
                                }
                                .toggleStyle(CheckboxToggleStyle())

                                if index + 1 < displayedIngredients.count {
                                    Toggle(isOn: Binding(
                                        get: { displayedIngredients[index + 1].isChecked },
                                        set: { newValue in
                                            toggleIngredient(at: index + 1, newValue: newValue, in: filteredIngredients)
                                        }
                                    )) {
                                        Text(displayedIngredients[index + 1].name)
                                            .foregroundColor(.white)
                                            .lineLimit(1)
                                    }
                                    .toggleStyle(CheckboxToggleStyle())
                                }
                            }
                        }
                    }

                    if filteredIngredients.count >= 4 {
                        Text("... more")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    }
                } else {
                    // Placeholder for no ingredients
                    Text("No ingredients assigned")
                        .foregroundColor(.white.opacity(0.8))
                        .font(.caption)
                        .padding(.top, 5)
                    Text("")
                        .foregroundColor(.white.opacity(0.8))
                        .font(.caption)
                        .padding(.top, 5)
                }
            }
        }
        .padding()
        .background(backgroundColor)
        .cornerRadius(15)
        .shadow(radius: 2)
        .frame(width: 300, height: 150) // Fixed size for consistency
        .clipped() // Enforces the frame size
    }

  private func toggleIngredient(at index: Int, newValue: Bool, in ingredients: [Ingredient]) {
      if let ingredientIndex = event.assignedIngredientsList.firstIndex(of: ingredients[index]) {
          // Update local state
          event.assignedIngredientsList[ingredientIndex].isChecked = newValue

          // Update Firebase
          let ingredient = event.assignedIngredientsList[ingredientIndex]
          let databaseRef = Database.database().reference()
          let eventRef = databaseRef.child("events").child(event.id.uuidString)
          eventRef.child("assignedIngredientsList").observeSingleEvent(of: .value) { snapshot in
              if var ingredientsList = snapshot.value as? [[String: Any]] {
                  if let ingredientIndex = ingredientsList.firstIndex(where: { $0["id"] as? String == ingredient.id }) {
                      ingredientsList[ingredientIndex]["isChecked"] = newValue
                      eventRef.child("assignedIngredientsList").setValue(ingredientsList) { error, _ in
                          if let error = error {
                              print("❌ Error updating ingredient in Firebase: \(error.localizedDescription)")
                          } else {
                              print("✅ Ingredient updated successfully in Firebase")
                              
                              // Refresh local data after Firebase update
                              fetchUpdatedIngredients()
                          }
                      }
                  }
              }
          }
      }
  }

  private func fetchUpdatedIngredients() {
      let databaseRef = Database.database().reference()
      let eventRef = databaseRef.child("events").child(event.id.uuidString)
      
      eventRef.child("assignedIngredientsList").observe(.value) { snapshot in
          if let ingredientsList = snapshot.value as? [[String: Any]] {
              let updatedIngredients = ingredientsList.compactMap { ingredientDict -> Ingredient? in
                  guard
                      let id = ingredientDict["id"] as? String,
                      let name = ingredientDict["name"] as? String,
                      let amount = ingredientDict["amount"] as? String,
                      let isChecked = ingredientDict["isChecked"] as? Bool,
                      let userID = ingredientDict["userID"] as? String
                  else {
                      return nil
                  }
                  return Ingredient(id: id, name: name, isChecked: isChecked, userID: userID, amount: amount)
              }
              
              DispatchQueue.main.async {
                  self.event.assignedIngredientsList = updatedIngredients
                  print("✅ Assigned ingredients list updated in real-time")
              }
          }
      }
  }
  

}
