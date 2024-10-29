//
//  User.swift
//  Team02
//
//  Created by 顾芮名 on 10/28/24.
//

import Foundation

struct User: Identifiable {
    let id = UUID()
    let fullName: String
    let image: String
    let email: String
    let password: String
    var events: [Event] = []
    var assignedIngredientsList: [Ingredient] = [] 
  
  init(fullName: String, image: String, email: String, password: String, events: [Event], assignedIngredientsList: [Ingredient]) {
    self.fullName = fullName
    self.image = image
    self.email = email
    self.password = password
    self.events = events
    self.assignedIngredientsList = assignedIngredientsList
  }
}
