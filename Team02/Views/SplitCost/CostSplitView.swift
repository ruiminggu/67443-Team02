//
//  CostSplitView.swift
//  Team02
//
//  Created by Leila
//

import SwiftUI

struct CostSplitView: View {
    @State private var transactions: [Transaction] = [
        Transaction(
            payer: User(
                id: UUID(),
                fullName: "Kevin",
                image: "kevin.png",
                email: "kevin@example.com",
                password: "password123",
                events: []
            ),
            payee: User(
                id: UUID(),
                fullName: "Leila",
                image: "leila.png",
                email: "leila@example.com",
                password: "password456",
                events: []
            ),
            item: "Dinner",
            amount: 500,
            event: Event(
                id: UUID(),
                invitedFriends: [
                    User(
                        id: UUID(),
                        fullName: "Kevin",
                        image: "kevin.png",
                        email: "kevin@example.com",
                        password: "password123",
                        events: []
                    )
                ],
                recipes: [],
                date: Date(),
                time: Date(),
                location: "123 Party St.",
                eventName: "CNY Dinner",
                qrCode: "qr123",
                costs: [],
                totalCost: 500,
                assignedIngredientsList: []
            )
        ),
        Transaction(
            payer: User(
                id: UUID(),
                fullName: "Leila",
                image: "leila.png",
                email: "leila@example.com",
                password: "password456",
                events: []
            ),
            payee: User(
                id: UUID(),
                fullName: "Amy",
                image: "amy.png",
                email: "amy@example.com",
                password: "password789",
                events: []
            ),
            item: "Lunch",
            amount: 500,
            event: Event(
                id: UUID(),
                invitedFriends: [
                    User(
                        id: UUID(),
                        fullName: "Amy",
                        image: "amy.png",
                        email: "amy@example.com",
                        password: "password789",
                        events: []
                    )
                ],
                recipes: [],
                date: Date(),
                time: Date(),
                location: "456 Lunch Ave.",
                eventName: "ABB Dinner",
                qrCode: "qr456",
                costs: [],
                totalCost: 500,
                assignedIngredientsList: []
            )
        ),
        Transaction(
            payer: User(
                id: UUID(),
                fullName: "Betty",
                image: "betty.png",
                email: "betty@example.com",
                password: "password321",
                events: []
            ),
            payee: User(
                id: UUID(),
                fullName: "Leila",
                image: "leila.png",
                email: "leila@example.com",
                password: "password456",
                events: []
            ),
            item: "Groceries",
            amount: 500,
            event: Event(
                id: UUID(),
                invitedFriends: [
                    User(
                        id: UUID(),
                        fullName: "Betty",
                        image: "betty.png",
                        email: "betty@example.com",
                        password: "password321",
                        events: []
                    )
                ],
                recipes: [],
                date: Date(),
                time: Date(),
                location: "789 Grocery Ln.",
                eventName: "CNY Dinner",
                qrCode: "qr789",
                costs: [],
                totalCost: 500,
                assignedIngredientsList: []
            )
        )
    ]
    
    @State private var selectedTab: String = "Friends" // "Friends" or "Events"
    
    var body: some View {
        VStack {
            // Top Summary Section
            HStack(spacing: 20) {
                SummaryCard(title: "You are owed", amount: totalOwedToYou())
                SummaryCard(title: "You owe", amount: totalYouOwe())
                SummaryCard(title: "Total Balance", amount: totalBalance())
            }
            .padding()
            
            // Tab Selector
            HStack {
                Button("Friends") {
                    selectedTab = "Friends"
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(selectedTab == "Friends" ? Color.orange.opacity(0.2) : Color.clear)
                .cornerRadius(8)
                
                Button("Events") {
                    selectedTab = "Events"
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(selectedTab == "Events" ? Color.orange.opacity(0.2) : Color.clear)
                .cornerRadius(8)
            }
            .padding()
            
            // List of Transactions
            List {
                if selectedTab == "Friends" {
                    ForEach(groupedByFriends().keys.sorted(), id: \.self) { friend in
                        Section(header: Text(friend)) {
                            ForEach(groupedByFriends()[friend] ?? []) { transaction in
                                TransactionRow(transaction: transaction)
                            }
                        }
                    }
                } else {
                    ForEach(groupedByEvents().keys.sorted(), id: \.self) { event in
                        Section(header: Text(event)) {
                            ForEach(groupedByEvents()[event] ?? []) { transaction in
                                TransactionRow(transaction: transaction)
                            }
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
        }
    }
    
    // MARK: Helper Methods
    
    private func groupedByFriends() -> [String: [Transaction]] {
        Dictionary(grouping: transactions, by: { $0.payee.fullName })
    }
    
    private func groupedByEvents() -> [String: [Transaction]] {
        Dictionary(grouping: transactions, by: { $0.event.eventName })
    }
    
    private func totalOwedToYou() -> Float {
        transactions
            .filter { $0.payee.fullName == "Leila" }
            .reduce(0) { $0 + $1.amount }
    }
    
    private func totalYouOwe() -> Float {
        transactions
            .filter { $0.payer.fullName == "Leila" }
            .reduce(0) { $0 + $1.amount }
    }
    
    private func totalBalance() -> Float {
        totalOwedToYou() - totalYouOwe()
    }
}
