import Foundation

struct Transaction: Identifiable, Equatable {
    let id: UUID
    let payer: User
    let payee: User
    let item: String
    let amount: Float
    let event: Event
  
    init(id: UUID = UUID(), payer: User, payee: User, item: String, amount: Float, event: Event) {
        self.id = id
        self.payer = payer
        self.payee = payee
        self.item = item
        self.amount = amount
        self.event = event
    }
  
    static func ==(lhs: Transaction, rhs: Transaction) -> Bool {
        return lhs.id == rhs.id &&
               lhs.payer == rhs.payer &&
               lhs.payee == rhs.payee &&
               lhs.item == rhs.item &&
               lhs.amount == rhs.amount &&
               lhs.event == rhs.event
    }
}
