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

                DatePicker("Select Date", selection: $viewModel.selectedDate, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .accentColor(.orange)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(30)
                    .shadow(radius: 1)

                Spacer()

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
            }
            .navigationBarTitleDisplayMode(.inline)
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
