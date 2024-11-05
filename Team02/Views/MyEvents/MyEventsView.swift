//
//  MyEventsMain.swift
//  Team02
//
//  Created by Xinyi Chen on 11/4/24.
//

import SwiftUI

struct MyEventCard: View {
  let eventName: String
  let date: String
  let attendeeCount: Int
  let isUpcoming: Bool
  let lightGreen = Color(red: 164/255, green: 221/255, blue: 176/255)
  
  var body: some View {
      NavigationLink(destination: EventDetailView(
          eventName: eventName,
          date: date,
          attendeeCount: attendeeCount
      )) {
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
                  ForEach(0...(min(3, attendeeCount) - 1), id: \.self) { _ in
                      Circle()
                          .fill(Color.white.opacity(1))
                          .frame(width: 45, height: 45)
                          .overlay(
                              Image(systemName: "person.fill")
                                  .foregroundColor(.gray)
                          )
                  }
                  
                  if attendeeCount > 0 {
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
  var body: some View {
      NavigationView {
          ScrollView {
              VStack(alignment: .leading, spacing: 20) {
                  Text("My Events")
                      .font(.system(size: 34, weight: .bold))
                      .foregroundColor(.orange)
                      .padding(.horizontal)
                      .padding(.top)
                  
                  Text("Upcoming Events")
                      .font(.system(size: 20, weight: .semibold))
                      .foregroundColor(.orange)
                      .padding(.horizontal)
                  
                  MyEventCard(
                      eventName: "Grad Dinner",
                      date: "Friday, 25 November",
                      attendeeCount: 6,
                      isUpcoming: true
                  )
                  
                  Text("Past Events")
                      .font(.system(size: 20, weight: .semibold))
                      .foregroundColor(.orange)
                      .padding(.horizontal)
                      .padding(.top)
                  
                  MyEventCard(
                      eventName: "CNY Dinner",
                      date: "Monday, 24 October",
                      attendeeCount: 9,
                      isUpcoming: false
                  )
                  
                  MyEventCard(
                      eventName: "ABB Brunch",
                      date: "Sunday, 22 March",
                      attendeeCount: 2,
                      isUpcoming: false
                  )
                  
                  MyEventCard(
                      eventName: "Haloween Dinner",
                      date: "Tuesday, 16 January",
                      attendeeCount: 7,
                      isUpcoming: false
                  )
              }
          }
      }
  }
}

#Preview {
    MyEventsView()
}
