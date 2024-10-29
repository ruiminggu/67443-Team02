import SwiftUI

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
    @Binding var event: Event
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
            .padding(.bottom, 5)
            
            // TO-DO List section
            VStack(alignment: .leading) {
                Text("TO-DO:")
                    .font(.subheadline)
                    .foregroundColor(.white)
                
                // Display items in two columns using a grid-like structure
                let filteredIngredients = event.assignedIngredientsList.filter { $0.userID == userID }
                ForEach(0..<filteredIngredients.count, id: \.self) { index in
                    if index % 2 == 0 { // Start new HStack every two items
                        HStack(spacing: 16) {
                            Toggle(isOn: $event.assignedIngredientsList[index].isChecked) {
                                Text(event.assignedIngredientsList[index].name)
                                    .foregroundColor(.white)
                            }
                            .toggleStyle(CheckboxToggleStyle())
                            
                            // Check if next item exists, to add it in the same row
                            if index + 1 < filteredIngredients.count {
                                Toggle(isOn: $event.assignedIngredientsList[index + 1].isChecked) {
                                    Text(event.assignedIngredientsList[index + 1].name)
                                        .foregroundColor(.white)
                                }
                                .toggleStyle(CheckboxToggleStyle())
                            }
                        }
                    }
                }
            }
            .padding(.top, 5)
        }
        .padding()
        .background(backgroundColor)
        .cornerRadius(15)
        .shadow(radius: 2)
        .frame(width: 300)
    }
}
