import SwiftUI

struct EventRow: View {
    let event: Event
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(event.eventName)
                    .font(.headline)
                    .fontWeight(.bold)
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(event.date, formatter: EventRow.dateFormatter)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    // Display start and end times
                    Text("Start: \(event.startTime, formatter: EventRow.timeFormatter)")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("End: \(event.endTime, formatter: EventRow.timeFormatter)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
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
