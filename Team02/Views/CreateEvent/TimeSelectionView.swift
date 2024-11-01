import SwiftUI

struct TimeSelectionView: View {
    @ObservedObject var viewModel: EventViewModel
    @State private var selectedTimes: Set<String> = []
    
    // Define your time slots
    let timeSlots = [
        "9:00 AM - 11:00 AM",
        "11:00 AM - 1:00 PM",
        "1:00 PM - 3:00 PM",
        "3:00 PM - 5:00 PM",
        "5:00 PM - 7:00 PM"
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Find a time!")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.orange)
                .padding(.top)
            
            ForEach(timeSlots, id: \.self) { slot in
                Button(action: {
                    if selectedTimes.contains(slot) {
                        selectedTimes.remove(slot)
                    } else {
                        selectedTimes.insert(slot)
                    }
                }) {
                    HStack {
                        Image(systemName: selectedTimes.contains(slot) ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(.orange)
                            .font(.title2)
                        Text(slot)
                            .font(.headline)
                            .foregroundColor(selectedTimes.contains(slot) ? .white : .orange)
                        Spacer()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(selectedTimes.contains(slot) ? Color.orange : Color.clear)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.orange, lineWidth: 2)
                    )
                }
                .padding(.horizontal) // Add horizontal padding to each button
            }
            
            NavigationLink(destination: InviteFriendsView(viewModel: viewModel)) {
                Text("Next")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .cornerRadius(10)
            }
            .padding(.top, 20)
            .padding(.horizontal)
        }
        .padding(.horizontal) // Add horizontal padding to the entire VStack
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct TimeSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        TimeSelectionView(viewModel: EventViewModel())
    }
}
