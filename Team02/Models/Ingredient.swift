//
//  Ingredient.swift
//  Team02
//
//  Created by 顾芮名 on 10/28/24.
//

import Foundation

struct Ingredient: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let unit: Float
    var isChecked: Bool
    let userID: UUID
    let amount: Float
  
    init(name: String, unit: Float, isChecked: Bool, userID: UUID, amount: Float) {
        self.name = name
        self.unit = unit
        self.isChecked = isChecked
        self.userID = userID
        self.amount = amount
    }
  
    static func ==(lhs: Ingredient, rhs: Ingredient) -> Bool {
        return lhs.name == rhs.name &&
               lhs.unit == rhs.unit &&
               lhs.isChecked == rhs.isChecked &&
               lhs.userID == rhs.userID &&
                lhs.amount == rhs.amount
    }
}


enum IngredientCategory: String, CaseIterable {
    case vegetablesAndGreens = "Vegetables & Greens"
    case meats = "Meats"
    case dairyAndEggs = "Dairy & Eggs"
    case ricesGrainsAndBeans = "Rices, Grains & Beans"
    
    var title: String {
        return rawValue
    }
}
