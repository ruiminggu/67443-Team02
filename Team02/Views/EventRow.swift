import SwiftUI

struct EventRow: View {
    let event: Event
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(event.eventName)
                    .font(.headline)
                    .fontWeight(.bold)
                
                Spacer()
                
                Text(event.date, formatter: EventRow.dateFormatter)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Text(event.location)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .shadow(radius: 1)
        .padding(.horizontal)
    }
}
