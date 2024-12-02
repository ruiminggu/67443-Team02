//
//  SummaryCard.swift
//  Team02
//
//  Created by Leila Lei on 12/1/24.
//


import SwiftUI

struct SummaryCard: View {
    let title: String
    let amount: Float
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.gray)
            Text("$\(amount, specifier: "%.2f")")
                .font(.title)
                .bold()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.orange.opacity(0.1))
        .cornerRadius(8)
    }
}
