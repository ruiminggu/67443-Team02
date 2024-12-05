//
//  AddCostView.swift
//  Team02
//
//  Created by Leila Lei
//


import SwiftUI
import FirebaseAuth

struct AddCostView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var costSplitViewModel = CostSplitViewModel()
    @ObservedObject var eventViewModel: EventViewModel // Use EventViewModel

    @State private var itemName: String = ""
    @State private var costAmount: String = ""
    @State private var selectedEvent: Event?

    var body: some View {
        NavigationView {
            VStack {
                // Header
                Text("Add Costs to Event")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 20)

                // Input Fields
                VStack(alignment: .leading, spacing: 10) {
                    // Item Name
                    TextField("Item Name (e.g., Dinner, Groceries)", text: $itemName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    // Cost Amount
                    TextField("Cost Amount (e.g., 20.99)", text: $costAmount)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    // Select Event
                    Picker("Event", selection: $selectedEvent) {
                        ForEach(eventViewModel.events, id: \.id) { event in
                            Text(event.eventName).tag(event as Event?)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                .padding()

                // Finish Button
                Button(action: {
                    saveCost()
                }) {
                    Text("Finish")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.top)

                Spacer()
            }
            .padding()
            .navigationBarTitle("Add Cost", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }

    // MARK: Helper Methods
    private func saveCost() {
        print("Event: \(selectedEvent?.eventName ?? "nil")")
        print("Cost Amount: \(costAmount)")
        print("Item Name: \(itemName)")

        guard let event = selectedEvent,
              let amount = Float(costAmount),
              !itemName.isEmpty else {
            print("Validation failed: Missing event, costAmount, or itemName")
            return
        }

      
      let transaction = Transaction(
          payer: User(id: UUID(), fullName: "Self", image: "", email: "", password: "", events: []),
          payee: User(id: UUID(), fullName: "Shared", image: "", email: "", password: "", events: []),
          item: itemName,
          amount: amount,
          event: event
      )


        costSplitViewModel.addTransaction(transaction)
        presentationMode.wrappedValue.dismiss()
    }
}
