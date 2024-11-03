import SwiftUI

struct DateSelectionView: View {
    @ObservedObject var viewModel: EventViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Pick a date!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
                    .padding(.top)

                Spacer()

                // Date Picker for Calendar Style
                DatePicker("Select Date", selection: $viewModel.selectedDate, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle()) // This gives it a calendar appearance
                    .accentColor(.orange)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(30)
                    .shadow(radius: 1)

                Spacer()

                // Button for navigation to the next screen
                NavigationLink(destination: TimeSelectionView(viewModel: viewModel)) {
                    Text("Next")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.bottom)

                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline) // Inline if you want a subtle title area
        }
    }
}

struct DateSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DateSelectionView(viewModel: EventViewModel())
        }
    }
}
