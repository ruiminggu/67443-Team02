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
    @Published var loggedInUserID: String? // Firebase UID as String
    @Published var loggedInUserUUID: UUID? // Optional UUID for compatibility if needed

    private let db = Firestore.firestore()

    // MARK: Initialization
    init() {
        fetchLoggedInUserID()
    }

    // MARK: Fetch Logged-In User ID
    private func fetchLoggedInUserID() {
        if let currentUser = Auth.auth().currentUser {
            loggedInUserID = currentUser.uid // Use Firebase UID directly
            loggedInUserUUID = UUID(uuidString: currentUser.uid) // Try to convert to UUID, fallback if needed
            print("Logged-in user ID: \(loggedInUserID ?? "Unknown")")
            print("Logged-in user UUID: \(loggedInUserUUID?.uuidString ?? "Generated UUID")")
        } else {
            print("No user is currently logged in.")
        }
    }

    // MARK: Calculate "You Are Owed"
    var totalOwedToYou: Float {
        guard let loggedInUserID = loggedInUserID else {
            print("⚠️ Logged-in user ID is nil")
            return 0.0
        }
        print("🔍 Calculating total owed to you for logged-in user ID: \(loggedInUserID)")

        let owedTransactions = transactions.filter {
            $0.payer.id.uuidString == loggedInUserID // Transactions added by the user
        }

        print("Transactions where logged-in user is the payer: \(owedTransactions)")
        return owedTransactions.reduce(0) { $0 + $1.amount }
    }

    // MARK: Calculate "You Owe"
    var totalYouOwe: Float {
        guard let loggedInUserID = loggedInUserID else {
            print("⚠️ Logged-in user ID is nil")
            return 0.0
        }
        print("🔍 Calculating total you owe for logged-in user ID: \(loggedInUserID)")

        return transactions
            .filter { transaction in
                let isUserInvited = transaction.event.invitedFriends.contains { $0 == loggedInUserID } // Check if the user is part of the event
                let isOtherPayer = transaction.payer.id.uuidString != loggedInUserID // Someone else added the cost

                print("📝 Transaction ID: \(transaction.id)")
                print("   Payer ID: \(transaction.payer.id.uuidString)")
                print("   Logged-in User Invited: \(isUserInvited)")
                print("   Is Other Payer: \(isOtherPayer)")

                return isUserInvited && isOtherPayer
            }
            .reduce(0) { $0 + $1.amount }
    }

    // MARK: Calculate Total Balance
    var totalBalance: Float {
        totalOwedToYou - totalYouOwe
    }

    // MARK: Fetch Transactions
    func fetchTransactions() {
        guard let loggedInUserID = loggedInUserID else {
            print("Cannot fetch transactions. No logged-in user.")
            return
        }

        print("Fetching transactions for user ID: \(loggedInUserID)")

        db.collection("transactions").getDocuments { [weak self] snapshot, error in
            if let error = error {
                print("Error fetching transactions: \(error.localizedDescription)")
            } else {
                self?.transactions = snapshot?.documents.compactMap { self?.mapTransaction($0.data()) } ?? []
                print("Fetched transactions: \(self?.transactions.count ?? 0)")
            }
        }
    }

    // MARK: Add Transaction
    func addTransaction(_ transaction: Transaction) {
        guard let loggedInUserID = loggedInUserID else {
            print("Cannot add transaction. No logged-in user.")
            return
        }

        print("Adding transaction for user ID: \(loggedInUserID)")

        let data: [String: Any] = [
            "payer": [
                "id": loggedInUserID,
                "fullName": "Self", // Placeholder, replace with actual full name if available
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

        db.collection("transactions").addDocument(data: data) { error in
            if let error = error {
                print("Error adding transaction: \(error.localizedDescription)")
            } else {
                print("Transaction added successfully!")
                self.fetchTransactions()
            }
        }
    }

    // MARK: Map Firestore Document to Transaction Object
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
