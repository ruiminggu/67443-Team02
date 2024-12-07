import SwiftUI
import FirebaseAuth

struct AddCostView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var costSplitViewModel: CostSplitViewModel
    @ObservedObject var eventViewModel: EventViewModel

    @State private var itemName: String = ""
    @State private var costAmount: String = ""
    @State private var selectedEvent: Event?

    var body: some View {
        NavigationView {
            VStack {
                Text("Add Costs to Event")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 20)

                VStack(alignment: .leading, spacing: 10) {
                    TextField("Item Name", text: $itemName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("Cost Amount", text: $costAmount)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Picker("Event", selection: $selectedEvent) {
                        ForEach(eventViewModel.events, id: \.id) { event in
                            Text(event.eventName).tag(event as Event?)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onAppear {
                        if selectedEvent == nil, let firstEvent = eventViewModel.events.first {
                            selectedEvent = firstEvent
                        }
                    }
                }
                .padding()

                Button(action: saveCost) {
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

    private func saveCost() {
        print("Selected Event: \(selectedEvent?.eventName ?? "None")")
        print("Cost Amount: \(costAmount)")
        print("Item Name: \(itemName)")

        guard let event = selectedEvent,
              let amount = Float(costAmount),
              !itemName.isEmpty,
              let loggedInUserID = costSplitViewModel.loggedInUserID else {
            print("Validation failed. Missing fields or user ID.")
            return
        }

        // Updated payer creation logic
        let transaction = Transaction(
            payer: User(
                id: UUID(uuidString: loggedInUserID) ?? UUID(), // Use consistent logged-in user ID
                fullName: "Self", // Placeholder, replace with actual user's name if available
                image: "", // Placeholder for user's image
                email: "", // Placeholder for user's email
                password: "", // Default or placeholder value
                events: [] // Default value for events
            ),
            payee: User( // Updated payee to represent the "Shared" placeholder user
                id: UUID(), // Unique identifier for "Shared" transactions
                fullName: "Shared", // Placeholder for shared costs
                image: "",
                email: "",
                password: "",
                events: []
            ),
            item: itemName,
            amount: amount,
            event: event
        )

        print("Saving transaction: \(transaction)")
        costSplitViewModel.addTransaction(transaction)
        presentationMode.wrappedValue.dismiss()
    }
}
