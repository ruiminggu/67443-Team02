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
  
    init(name: String, unit: Float, isChecked: Bool, userID: UUID) {
        self.name = name
        self.unit = unit
        self.isChecked = isChecked
        self.userID = userID
    }
  
    static func ==(lhs: Ingredient, rhs: Ingredient) -> Bool {
        return lhs.name == rhs.name &&
               lhs.unit == rhs.unit &&
               lhs.isChecked == rhs.isChecked &&
               lhs.userID == rhs.userID
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
