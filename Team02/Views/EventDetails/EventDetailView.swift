//
//  EventDetailView.swift
//  Team02
//
//  Created by Xinyi Chen on 11/4/24.
//

import SwiftUI

struct EventDetailView: View {
    let lightGreen = Color(red: 164/255, green: 221/255, blue: 176/255)
    let eventID: String
    
    @StateObject private var viewModel = EventDetailViewModel()
    @State private var showAddIngredients = false
    
    var body: some View {
        ZStack {
            if viewModel.isLoading {
                VStack(spacing: 16) {
                    ProgressView()
                    Text("Loading event details...")
                        .foregroundColor(.gray)
                }
            } else if let error = viewModel.error {
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundColor(.orange)
                    Text(error)
                        .foregroundColor(.gray)
                    Button("Retry") {
                        viewModel.fetchEventDetails(eventID: eventID)
                    }
                    .foregroundColor(.orange)
                }
            } else if let event = viewModel.event {
                ScrollView {
                    VStack(alignment: .leading, spacing: 40) {
                        EventHeaderView(
                            eventName: event.eventName,
                            date: formatDate(event.date),
                            attendeeCount: viewModel.attendees.count,
                            lightGreen: lightGreen
                        )
                        
                        MenuSectionView(event: event)
                        
                        IngredientsSectionView(event: event)
                    }
                    .padding(.top)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            print("📱 EventDetailView appeared for event ID: \(eventID)")
            viewModel.fetchEventDetails(eventID: eventID)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, dd MMMM"
        return formatter.string(from: date)
    }
}

// Preview
//struct EventDetailView_Previews: PreviewProvider {
//  static var previews: some View {
//  }
//}
