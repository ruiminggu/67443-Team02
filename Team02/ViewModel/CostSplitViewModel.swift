//
//  CostSplitViewModel.swift
//  Team02
//
//  Created by Leila
//

import SwiftUI
import FirebaseFirestore

class CostSplitViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    @Published var allUsers: [User] = []
    @Published var allEvents: [Event] = []

    private let db = Firestore.firestore()

   
    func fetchTransactions() {
        db.collection("transactions").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching transactions: \(error.localizedDescription)")
            }else{
              self.fetchTransactions()
            }

            guard let documents = snapshot?.documents else {
                print("No transactions found")
                return
            }

            self.transactions = documents.compactMap { document -> Transaction? in
                let data = document.data()
                guard
                    let payerData = data["payer"] as? [String: Any],
                    let payeeData = data["payee"] as? [String: Any],
                    let item = data["item"] as? String,
                    let amount = data["amount"] as? Float,
                    let eventData = data["event"] as? [String: Any],
                    let eventName = eventData["eventName"] as? String
                else {
                    return nil
                }

                // Map nested payer and payee data
                let payer = User(
                    id: UUID(uuidString: payerData["id"] as? String ?? "") ?? UUID(),
                    fullName: payerData["fullName"] as? String ?? "",
                    image: payerData["image"] as? String ?? "",
                    email: payerData["email"] as? String ?? "",
                    password: "",
                    events: []
                )

                let payee = User(
                    id: UUID(uuidString: payeeData["id"] as? String ?? "") ?? UUID(),
                    fullName: payeeData["fullName"] as? String ?? "",
                    image: payeeData["image"] as? String ?? "",
                    email: payeeData["email"] as? String ?? "",
                    password: "",
                    events: []
                )

                // Map event data
                let event = Event(
                    id: UUID(uuidString: eventData["id"] as? String ?? "") ?? UUID(),
                    invitedFriends: [],
                    recipes: [],
                    date: Date(),
                    startTime: Date(),
                    endTime: Date(),
                    location: "",
                    eventName: eventName,
                    qrCode: "",
                    costs: [],
                    totalCost: 0,
                    assignedIngredientsList: []
                )

                return Transaction(payer: payer, payee: payee, item: item, amount: amount, event: event)
            }
        }
    }

    // Fetch users from Firebase
    func fetchUsers() {
        db.collection("users").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching users: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else {
                print("No users found")
                return
            }

            self.allUsers = documents.compactMap { document -> User? in
                let data = document.data()
                guard
                    let id = UUID(uuidString: data["id"] as? String ?? ""),
                    let fullName = data["fullName"] as? String,
                    let image = data["image"] as? String,
                    let email = data["email"] as? String
                else {
                    return nil
                }
                return User(id: id, fullName: fullName, image: image, email: email, password: "", events: [])
            }
        }
    }

   
    func fetchEvents() {
        db.collection("events").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching events: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else {
                print("No events found")
                return
            }

            self.allEvents = documents.compactMap { document -> Event? in
                let data = document.data()
                guard
                    let id = UUID(uuidString: data["id"] as? String ?? ""),
                    let eventName = data["eventName"] as? String,
                    let location = data["location"] as? String,
                    let totalCost = data["totalCost"] as? Float
                else {
                    return nil
                }
                return Event(
                    id: id,
                    invitedFriends: [],
                    recipes: [],
                    date: Date(),
                    startTime: Date(),
                    endTime: Date(),
                    location: location,
                    eventName: eventName,
                    qrCode: "",
                    costs: [],
                    totalCost: totalCost,
                    assignedIngredientsList: []
                )
            }
        }
    }

    // Add a new transaction
    func addTransaction(_ transaction: Transaction) {
      print("Adding transaction: \(transaction)")
        let data: [String: Any] = [
            "payer": [
                "id": transaction.payer.id.uuidString,
                "fullName": transaction.payer.fullName,
                "image": transaction.payer.image,
                "email": transaction.payer.email
            ],
            "payee": [
                "id": transaction.payee.id.uuidString,
                "fullName": transaction.payee.fullName,
                "image": transaction.payee.image,
                "email": transaction.payee.email
            ],
            "item": transaction.item,
            "amount": transaction.amount,
            "event": [
                "id": transaction.event.id.uuidString,
                "eventName": transaction.event.eventName
            ]
        ]

        db.collection("transactions").addDocument(data: data) { error in
            if let error = error {
                print("Error adding transaction: \(error.localizedDescription)")
            } else {
                print("Transaction added successfully!")
                self.fetchTransactions() // Refresh data
            }
        }
    }
}
