//
//  AddCostView.swift
//  Team02
//
//  Created by Leila Lei
//


import SwiftUI

struct AddCostView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = CostSplitViewModel()

    @State private var itemName: String = ""
    @State private var costAmount: String = ""
    @State private var selectedEvent: Event?
    @State private var selectedPayee: User?
    @State private var selectedPayer: User?

    var body: some View {
        NavigationView {
            VStack {
                // Header
                Text("Add Costs to Event")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 20)

                // Upload Receipt Placeholder
                Button(action: {
                    // Handle receipt upload logic
                }) {
                    VStack {
                        Image(systemName: "camera.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                        Text("Upload Receipt Image")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                }
                .padding()

                // Input Fields
                VStack(alignment: .leading, spacing: 10) {
                    // Item Name
                    TextField("Item Name (e.g., Dinner, Groceries)", text: $itemName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    // Cost Amount
                    TextField("Cost Amount (e.g., 20.99)", text: $costAmount)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    // Select Payer
                    Picker("Payer", selection: $selectedPayer) {
                        ForEach(viewModel.allUsers, id: \.id) { user in
                            Text(user.fullName).tag(user)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())

                    // Select Payee
                    Picker("Payee", selection: $selectedPayee) {
                        ForEach(viewModel.allUsers, id: \.id) { user in
                            Text(user.fullName).tag(user)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())

                    // Select Event
                    Picker("Event", selection: $selectedEvent) {
                        ForEach(viewModel.allEvents, id: \.id) { event in
                            Text(event.eventName).tag(event)
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
        guard let payer = selectedPayer,
              let payee = selectedPayee,
              let event = selectedEvent,
              let amount = Float(costAmount) else {
            // Handle validation errors (e.g., missing fields)
            return
        }

        // Create a new Transaction
        let transaction = Transaction(
            payer: payer,
            payee: payee,
            item: itemName,
            amount: amount,
            event: event
        )

 
        viewModel.addTransaction(transaction)

    
        presentationMode.wrappedValue.dismiss()
    }
}
