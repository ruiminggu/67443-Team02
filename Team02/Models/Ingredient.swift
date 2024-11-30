//
//  Ingredient.swift
//  Team02
//
//  Created by 顾芮名 on 10/28/24.
//

import Foundation

struct Ingredient: Identifiable, Hashable, Equatable {
    let id = UUID()
    let name: String
    let amount: String
    var isChecked: Bool
    let userID: UUID
  
    init(name: String, isChecked: Bool, userID: UUID, amount: String) {
        self.name = name
        self.isChecked = isChecked
        self.userID = userID
        self.amount = amount
    }
  
    static func ==(lhs: Ingredient, rhs: Ingredient) -> Bool {
        return lhs.name == rhs.name &&
               lhs.isChecked == rhs.isChecked &&
               lhs.userID == rhs.userID &&
               lhs.amount == rhs.amount
    }
  
    func toDictionary() -> [String: Any] {
            return [
                "id": id.uuidString,
                "name": name,
                "isChecked": isChecked,
                "userID": userID.uuidString,
                "amount": amount
            ]
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
