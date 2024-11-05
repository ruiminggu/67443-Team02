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
                
                // Attendee circles
                HStack(spacing: -10) {
                    ForEach(0...(min(3, attendeeCount) - 1), id: \.self) { _ in
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
                }
            }
        }
        .padding(.horizontal)
    }
}
