//
//  Event.swift
//  Team02
//
//  Created by 顾芮名 on 10/28/24.
//

import Foundation

import Foundation

struct Event: Identifiable {
    let id = UUID()
    let users: [User]
    let recipes: [Recipe]
    let date: Date
    let time: Date
    let location: String
    let eventName: String
    let qrCode: String
    let costs: [Transaction]
    var totalCost: Float
  
  init(users: [User], recipes: [Recipe], date: Date, time: Date, location: String, eventName: String, qrCode: String, costs: [Transaction], totalCost: Float) {
    self.users = users
    self.recipes = recipes
    self.date = date
    self.time = time
    self.location = location
    self.eventName = eventName
    self.qrCode = qrCode
    self.costs = costs
    self.totalCost = totalCost
  }
}
