//
//  Transaction.swift
//  Team02
//
//  Created by 顾芮名 on 10/28/24.
//

import Foundation

struct Transaction {
    let payer: User
    let payee: User
    let item: String
    let amount: Float
    let event: Event
  
  init(payer: User, payee: User, item: String, amount: Float, event: Event) {
    self.payer = payer
    self.payee = payee
    self.item = item
    self.amount = amount
    self.event = event
  }
}
