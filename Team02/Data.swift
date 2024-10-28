//
//  Data.swift
//  Team02
//
//  Created by 顾芮名 on 10/17/24.
//

import Foundation

struct User {
  let userID: UUID
  let fullName: String
  let image: String
  let email: String
  let password: String
  var events: [Event] = []
  var assignedIngredientsList: [Ingredient] = []
}

struct Event {
  let eventID: UUID
  let users: [User]
  let recipes: [Recipe]
  let date: Date
  let time: Date
  let location: String
  let eventName: String
  let qrCode: String
  let costs: [Transaction]
  var totalCost: Float
}

struct MenuDatabase {
  var repices: [Recipe]
  var recommendedRecipes: [Recipe]
}

struct Transaction {
  let payer: User
  let payee: User
  let item: String
  let amount: Float
  let event: Event
}

struct Ingredient {
  let name: String
  let unit: Float
}

struct Recipe {
  let recipeID: UUID
  let title: String
  let description: String
  let image: String
  let instruction: String
  let ingredients: [Ingredient]
}
