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
    var event: Event
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
                let displayedIngredients = Array(filteredIngredients.prefix(6)) // Max 6 items for 3 rows

                // Display ingredients in rows
                ForEach(0..<displayedIngredients.count, id: \.self) { index in
                    if index % 2 == 0 {
                        HStack(spacing: 16) {
                            Toggle(isOn: .constant(displayedIngredients[index].isChecked)) {
                                Text(displayedIngredients[index].name)
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                            }
                            .toggleStyle(CheckboxToggleStyle())

                            if index + 1 < displayedIngredients.count {
                                Toggle(isOn: .constant(displayedIngredients[index + 1].isChecked)) {
                                    Text(displayedIngredients[index + 1].name)
                                        .foregroundColor(.white)
                                        .lineLimit(1)
                                }
                                .toggleStyle(CheckboxToggleStyle())
                            }
                        }
                    }
                }

                if filteredIngredients.count > 6 {
                    Text("... more")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
            }
        }
        .padding()
        .background(backgroundColor)
        .cornerRadius(15)
        .shadow(radius: 2)
        .frame(width: 300, height: 150) // Fixed size
        .clipped() // Enforces the frame size
    }
}
