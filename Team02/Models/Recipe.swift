//
//  Recipe.swift
//  Team02
//
//  Created by 顾芮名 on 10/28/24.
//

import Foundation

struct Recipe: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let image: String
    let instruction: String
    let ingredients: [Ingredient]
  
  init(title: String, description: String, image: String, instruction: String, ingredients: [Ingredient]) {
    self.title = title
    self.description = description
    self.image = image
    self.instruction = instruction
    self.ingredients = ingredients
  }
}
