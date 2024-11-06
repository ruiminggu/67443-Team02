//
//  EventDetailView.swift
//  Team02
//
//  Created by Xinyi Chen on 11/4/24.
//

import SwiftUI

struct EventDetailView: View {
  let lightGreen = Color(red: 164/255, green: 221/255, blue: 176/255)
  let eventName: String
  let date: String
  let attendeeCount: Int
  @State private var showAddIngredients = false
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 40) {
        EventHeaderView(
          eventName: eventName,
          date: date,
          attendeeCount: attendeeCount,
          lightGreen: lightGreen
        )
        
        MenuSectionView()
        
        IngredientsSectionView()
      }
      .padding(.top)
    }
  }
}

// Preview
struct EventDetailView_Previews: PreviewProvider {
  static var previews: some View {
    EventDetailView(
      eventName: "Grad Dinner",
      date: "Friday, 25 May",
      attendeeCount: 6
    )
  }
}
