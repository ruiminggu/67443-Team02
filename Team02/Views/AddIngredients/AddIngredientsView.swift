//
//  AddIngredientsView.swift
//  Team02
//
//  Created by Xinyi Chen on 11/4/24.
//

import SwiftUI

struct AddIngredientsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = AddIngredientsViewModel()
    let eventID: String
    let userID: UUID
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header with back button
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                        .padding()
                }
                
                Text("Add Ingredients")
                    .font(.title2)
                    .foregroundColor(.orange)
                
                Spacer()
            }
            
            // Form Fields
            VStack(alignment: .leading, spacing: 16) {
                // Name Field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Name")
                        .foregroundColor(.black)
                    
                    TextField("Enter ingredient name", text: $viewModel.ingredientName)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }
                
                // Amount Field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Amount")
                        .foregroundColor(.black)
                    
                    TextField("Ex:50", text: $viewModel.amount)
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }
            }
            .padding()
            
            Spacer()
            
            // Action Buttons
            VStack(spacing: 12) {
                Button(action: {
                    viewModel.addIngredientToEvent(eventID: eventID, userID: userID)
                }) {
                    if viewModel.isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("Add")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.orange)
                .cornerRadius(25)
                .disabled(viewModel.isLoading)
                
                Button(action: {
                    dismiss()
                }) {
                    Text("Cancel")
                        .font(.headline)
                        .foregroundColor(.orange)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.orange, lineWidth: 1)
                        )
                }
            }
            .padding()
        }
        .alert("Error", isPresented: .constant(viewModel.error != nil)) {
            Button("OK") {
                viewModel.error = nil
            }
        } message: {
            if let error = viewModel.error {
                Text(error)
            }
        }
        .alert("Success", isPresented: $viewModel.showSuccessAlert) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Ingredient added successfully!")
        }
    }
}

// Helper view for flowing category buttons
struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            spacing: spacing
        )
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: bounds.width,
            subviews: subviews,
            spacing: spacing
        )
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x,
                                    y: bounds.minY + result.positions[index].y),
                         proposal: ProposedViewSize(result.sizes[index]))
        }
    }
    
    struct FlowResult {
        var positions: [CGPoint] = []
        var sizes: [CGSize] = []
        var size: CGSize = .zero
        
        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var currentX: CGFloat = 0
            var currentY: CGFloat = 0
            var lineHeight: CGFloat = 0
            
            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                
                if currentX + size.width > maxWidth && currentX > 0 {
                    currentX = 0
                    currentY += lineHeight + spacing
                    lineHeight = 0
                }
                
                positions.append(CGPoint(x: currentX, y: currentY))
                sizes.append(size)
                lineHeight = max(lineHeight, size.height)
                currentX += size.width + spacing
                
                self.size.width = max(self.size.width, currentX)
                self.size.height = currentY + lineHeight
            }
        }
    }
}

//struct AddIngredientsView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddIngredientsView()
//    }
//}
