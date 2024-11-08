//
//  EventHeaderView.swift
//  Team02
//
//  Created by Xinyi Chen on 11/4/24.
//

import SwiftUI

struct EventHeaderView: View {
    let eventName: String
    let date: String
    let attendeeCount: Int
    let lightGreen: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(eventName)
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(.orange)
            
            HStack {
                Text(date)
                    .font(.system(size: 18, weight: .medium))
                
                Spacer()
                
                // Attendee circles - Only show if there are attendees
                HStack(spacing: -10) {
                    if attendeeCount > 0 {
                        // Safe range for ForEach
                        ForEach(0..<min(3, attendeeCount), id: \.self) { _ in
                            Circle()
                                .fill(Color.white)
                                .frame(width: 32, height: 32)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .foregroundColor(.gray)
                                )
                                .shadow(color: Color.gray.opacity(0.2), radius: 2, x: 0, y: 2)
                        }
                        
                        ZStack {
                            Circle()
                                .fill(lightGreen.opacity(0.7))
                                .frame(width: 32, height: 32)
                            Text("+\(attendeeCount)")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.white)
                        }
                    } else {
                        // Show placeholder when no attendees
                        Text("No attendees yet")
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}
//
//struct EventHeaderView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            // Test with different attendee counts
//            EventHeaderView(
//                eventName: "Test Event",
//                date: "Friday, 25 November",
//                attendeeCount: 0,
//                lightGreen: Color(red: 164/255, green: 221/255, blue: 176/255)
//            )
//            
//            EventHeaderView(
//                eventName: "Test Event",
//                date: "Friday, 25 November",
//                attendeeCount: 3,
//                lightGreen: Color(red: 164/255, green: 221/255, blue: 176/255)
//            )
//            
//            EventHeaderView(
//                eventName: "Test Event",
//                date: "Friday, 25 November",
//                attendeeCount: 10,
//                lightGreen: Color(red: 164/255, green: 221/255, blue: 176/255)
//            )
//        }
//        .previewLayout(.sizeThatFits)
//        .padding()
//    }
//}
