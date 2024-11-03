import SwiftUI

struct TimeSelectionView: View {
    @ObservedObject var viewModel: EventViewModel
    @State private var selectedTimes: (start: String, end: String)? = nil
    
    // Define your time slots with both start and end times
    let timeSlots = [
        ("9:00 AM", "11:00 AM"),
        ("11:00 AM", "1:00 PM"),
        ("1:00 PM", "3:00 PM"),
        ("3:00 PM", "5:00 PM"),
        ("5:00 PM", "7:00 PM")
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Find a time!")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.orange)
                .padding(.top)
            
            ForEach(timeSlots, id: \.0) { (start, end) in
                Button(action: {
                    if selectedTimes?.start == start && selectedTimes?.end == end {
                        selectedTimes = nil
                    } else {
                        selectedTimes = (start, end)
                    }
                    // Convert selected strings to actual Date objects in `viewModel`
                    viewModel.selectedStartTime = convertTimeStringToDate(start)
                    viewModel.selectedEndTime = convertTimeStringToDate(end)
                }) {
                    HStack {
                        Image(systemName: selectedTimes?.start == start && selectedTimes?.end == end ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(.orange)
                            .font(.title2)
                        Text("\(start) - \(end)")
                            .font(.headline)
                            .foregroundColor(selectedTimes?.start == start && selectedTimes?.end == end ? .white : .orange)
                        Spacer()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(selectedTimes?.start == start && selectedTimes?.end == end ? Color.orange : Color.clear)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.orange, lineWidth: 2)
                    )
                }
                .padding(.horizontal)
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
        .padding(.horizontal)
        .navigationBarTitleDisplayMode(.inline)
    }

    func convertTimeStringToDate(_ timeString: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.timeZone = TimeZone.current
        return formatter.date(from: timeString) ?? Date()
    }
}


struct TimeSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        TimeSelectionView(viewModel: EventViewModel())
    }
}
