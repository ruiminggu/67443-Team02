import SwiftUI

struct TimeSelectionView: View {
    @ObservedObject var viewModel: EventViewModel
    @State private var selectedTimes: (start: String, end: String)? = nil

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
                    selectedTimes = (start, end)
                    viewModel.selectedStartTime = convertTimeStringToDate(start)
                    viewModel.selectedEndTime = convertTimeStringToDate(end)
                }) {
                    HStack {
                        Image(systemName: selectedTimes?.start == start ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(.orange)
                        Text("\(start) - \(end)")
                            .foregroundColor(selectedTimes?.start == start ? .white : .orange)
                        Spacer()
                    }
                    .padding()
                    .background(selectedTimes?.start == start ? Color.orange : Color.clear)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.orange, lineWidth: 2))
                }
                .padding(.horizontal)
            }

            NavigationLink(destination: InviteFriendsView(viewModel: viewModel)) {
                Text("Next")
                    .foregroundColor(.white)
                    .padding()
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
        return formatter.date(from: timeString) ?? Date()
    }
}



struct TimeSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        TimeSelectionView(viewModel: EventViewModel())
    }
}
