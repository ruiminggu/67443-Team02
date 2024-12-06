//
//  CostSplitViewModel.swift
//  Team02
//
//  Created by Leila
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class CostSplitViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    @Published var allUsers: [User] = []
    @Published var allEvents: [Event] = []
    @Published var loggedInUserID: String?

    private let db = Firestore.firestore()

    // Initialize and fetch logged-in user ID
    init() {
        fetchLoggedInUserID()
    }

    // Fetch the logged-in user's ID from Firebase Authentication
    private func fetchLoggedInUserID() {
        if let currentUser = Auth.auth().currentUser {
            loggedInUserID = currentUser.uid
            print("Logged-in user ID: \(loggedInUserID ?? "Unknown")")
        } else {
            print("No user is currently logged in.")
        }
    }

    // Calculate total owed to you
    var totalOwedToYou: Float {
        transactions.filter { $0.payee.id.uuidString == loggedInUserID }
            .reduce(0) { $0 + $1.amount }
    }

    // Calculate total you owe
    var totalYouOwe: Float {
        transactions.filter { $0.payer.id.uuidString == loggedInUserID }
            .reduce(0) { $0 + $1.amount }
    }

    // Calculate total balance
    var totalBalance: Float {
        totalOwedToYou - totalYouOwe
    }

    // Fetch transactions involving the logged-in user
  func fetchTransactions() {
      guard let loggedInUserID = loggedInUserID else {
          print("Cannot fetch transactions. No logged-in user.")
          return
      }

      db.collection("transactions")
          .whereField("payer.id", isEqualTo: loggedInUserID)
          .getDocuments { [weak self] snapshot, error in
              guard let self = self else { return }

              if let error = error {
                  print("Error fetching transactions as payer: \(error.localizedDescription)")
                  return
              }

              let payerTransactions = snapshot?.documents.compactMap { self.mapTransaction($0.data()) } ?? []

              db.collection("transactions")
                  .whereField("payee.id", isEqualTo: loggedInUserID)
                  .getDocuments { [weak self] payeeSnapshot, payeeError in
                      guard let self = self else { return }

                      if let payeeError = payeeError {
                          print("Error fetching transactions as payee: \(payeeError.localizedDescription)")
                          return
                      }

                      let payeeTransactions = payeeSnapshot?.documents.compactMap { self.mapTransaction($0.data()) } ?? []

                      DispatchQueue.main.async {
                          self.transactions = payerTransactions + payeeTransactions
                          self.objectWillChange.send()
                      }
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

    // Fetch events involving the logged-in user
    func fetchEvents() {
        guard let loggedInUserID = loggedInUserID else {
            print("Cannot fetch events. No logged-in user.")
            return
        }

        db.collection("events")
            .whereField("invitedFriends", arrayContains: loggedInUserID)
            .getDocuments { snapshot, error in
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

  func addTransaction(_ transaction: Transaction) {
      guard let loggedInUserID = loggedInUserID else {
          print("Cannot add transaction. No logged-in user.")
          return
      }

      print("Adding transaction for user ID: \(loggedInUserID)")

      let data: [String: Any] = [
          "payer": [
              "id": loggedInUserID,
              "fullName": "Self",
              "image": "",
              "email": ""
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

      // Add transaction to Firestore
      db.collection("transactions").addDocument(data: data) { [weak self] error in
          guard let self = self else { return }

          if let error = error {
              print("Error adding transaction: \(error.localizedDescription)")
          } else {
              print("Transaction added successfully!")
              
              // Immediately add the transaction locally
              DispatchQueue.main.async {
                  self.transactions.append(transaction)
                  self.objectWillChange.send()
              }

              // Fetch transactions to ensure data consistency
              self.fetchTransactions()
          }
      }
  }





    // Map a transaction document to a Transaction object
    private func mapTransaction(_ data: [String: Any]) -> Transaction? {
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
