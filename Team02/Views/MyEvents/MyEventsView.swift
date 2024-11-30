//
//  MyEventsView.swift
//  Team02
//
//  Created by Xinyi Chen on 11/4/24.
//

import SwiftUI
import Foundation
import FirebaseDatabase


struct MyEventCard: View {
  let eventID: String
  let eventName: String
  let date: String
  let attendeeCount: Int
  let isUpcoming: Bool
  let lightGreen = Color(red: 164/255, green: 221/255, blue: 176/255)
  
  var body: some View {
      NavigationLink(destination: EventDetailView(eventID:  eventID)) {
          HStack {
              VStack(alignment: .leading, spacing: 45) {
                  Text(date)
                      .font(.system(size: 16, weight: .medium))
                      .foregroundColor(isUpcoming ? .white : Color.orange)
                  
                  Text(eventName)
                      .font(.system(size: 28, weight: .bold))
                      .foregroundColor(isUpcoming ? .white : Color.orange)
              }
              .padding(.leading, 20)
              
              Spacer()
              
              HStack(spacing: -20) {
                  // Fix: Check for valid attendee count before creating range
                  if attendeeCount > 0 {
                      ForEach(0..<min(3, attendeeCount), id: \.self) { _ in
                          Circle()
                              .fill(Color.white.opacity(1))
                              .frame(width: 45, height: 45)
                              .overlay(
                                  Image(systemName: "person.fill")
                                      .foregroundColor(.gray)
                              )
                      }
                      
                      ZStack {
                          Circle()
                              .fill(lightGreen.opacity(1))
                              .frame(width: 45, height: 45)
                          Text("+\(attendeeCount)")
                              .font(.system(size: 15, weight: .semibold))
                              .foregroundColor(.orange)
                      }
                  }
              }
              .padding(.trailing, 20)
              .padding(.bottom, -50)
          }
          .frame(maxWidth: .infinity)
          .frame(height: 140)
          .background(
              RoundedRectangle(cornerRadius: 20)
                  .fill(isUpcoming ? Color.orange : Color.orange.opacity(0.1))
          )
          .padding(.horizontal)
      }
  }
}

struct MyEventsView: View {
  let userID = UserDefaults.standard.string(forKey: "currentUserUUID") ?? ""
  @StateObject private var viewModel = EventsViewModel()
  
  var body: some View {
    // Events View Content
    NavigationView {
      ScrollView {
        VStack(alignment: .leading, spacing: 20) {
            Text("My Events")
              .font(.system(size: 34, weight: .bold))
              .foregroundColor(.orange)
              .padding(.horizontal)
              .padding(.top)
            
            // Debug Text to verify data
            if !viewModel.upcomingEvents.isEmpty {
              Text("Upcoming Events")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.orange)
                .padding(.horizontal)
              
              ForEach(viewModel.upcomingEvents) { event in
                MyEventCard(
                  eventID: event.id.uuidString,
                  eventName: event.eventName,
                  date: formatDate(event.date),
                  attendeeCount: event.invitedFriends.count,
                  isUpcoming: true
                )
              }
            } else {
              Text("No upcoming events")
                .foregroundColor(.gray)
                .padding(.horizontal)
            }
            
            if !viewModel.pastEvents.isEmpty {
              Text("Past Events")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.orange)
                .padding(.horizontal)
                .padding(.top)
              
              ForEach(viewModel.pastEvents) { event in
                MyEventCard(
                  eventID: event.id.uuidString,
                  eventName: event.eventName,
                  date: formatDate(event.date),
                  attendeeCount: event.invitedFriends.count,
                  isUpcoming: false
                )
              }
            } else {
              Text("No past events")
                .foregroundColor(.gray)
                .padding(.horizontal)
            }
          }
        }
        .onAppear {
          viewModel.fetchUser(userID: userID)
        }
        .refreshable {
          viewModel.fetchUser(userID: userID)
        }
      }
    }
    private func formatDate(_ date: Date) -> String {
      let formatter = DateFormatter()
      formatter.dateFormat = "EEEE, dd MMMM"
      return formatter.string(from: date)
    }
  }
  
  struct MyEventsView_Previews: PreviewProvider {
    static var previews: some View {
      MyEventsView()
    }
  }

