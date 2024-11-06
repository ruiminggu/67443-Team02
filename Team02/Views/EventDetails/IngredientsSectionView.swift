//
//  IngredientsSectionView.swift
//  Team02
//
//  Created by Xinyi Chen on 11/4/24.
//

import SwiftUI

struct IngredientsSectionView: View {
    @State private var showAddIngredients = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Ingredients")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.orange)
            
            HStack {
                Spacer()
                Button(action: {
                    showAddIngredients = true
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
        .sheet(isPresented: $showAddIngredients) {
            AddIngredientsView()
        }
    }
}

struct IngredientsSectionView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientsSectionView()
    }
}
