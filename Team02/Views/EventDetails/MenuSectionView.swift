//
//  MenuSectionView.swift
//  Team02
//
//  Created by Xinyi Chen on 11/4/24.
//

import SwiftUI

struct MenuSectionView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Menu")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.orange)
            
          HStack {
            Spacer()
            Button(action: {
                // Add menu item action
            }) {
                ZStack {
                    Circle()
                        .fill(Color.orange.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: "plus")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(.orange)
                }
            }
            Spacer()
          }
        }
        .padding(.horizontal)
    }
}
