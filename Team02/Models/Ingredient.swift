//
//  Ingredient.swift
//  Team02
//
//  Created by 顾芮名 on 10/28/24.
//

import Foundation

struct Ingredient: Identifiable {
    let id = UUID()
    let name: String
    let unit: Float
    var isChecked: Bool // Track if the item is checked
    let userID: UUID // ID of the user this ingredient is assigned to
  
    init(name: String, unit: Float, isChecked: Bool, userID: UUID) {
        self.name = name
        self.unit = unit
        self.isChecked = isChecked
        self.userID = userID
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
