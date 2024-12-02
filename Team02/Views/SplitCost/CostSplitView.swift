import SwiftUI

struct CostSplitView: View {
    @StateObject private var viewModel = CostSplitViewModel()
    @State private var selectedTab: String = "Friends" // "Friends" or "Events"
    @State private var showAddCostView = false

    var body: some View {
        VStack(spacing: 16) {
            headerSection
            summarySection
            toggleSection
            costsListSection
        }
        .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all))
        .sheet(isPresented: $showAddCostView) {
            AddCostView() 
        }
        .onAppear {
            viewModel.fetchTransactions()
            viewModel.fetchUsers()
            viewModel.fetchEvents()
        }
    }

    // MARK: Header Section
    private var headerSection: some View {
        HStack {
            Text("Settle the costs!")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.orange)
            Spacer()
            Button(action: {
                showAddCostView = true
            }) {
                Text("Add Cost")
                    .font(.callout)
                    .fontWeight(.medium)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }

    // MARK: Summary Section
    private var summarySection: some View {
        HStack(spacing: 16) {
            SummaryCard(title: "You are owed", amount: totalOwedToYou())
            SummaryCard(title: "You owe", amount: totalYouOwe())
            SummaryCard(title: "Total Balance", amount: totalBalance())
        }
        .padding(.horizontal)
    }

    // MARK: Toggle Section
    private var toggleSection: some View {
        HStack {
            Button(action: {
                selectedTab = "Friends"
            }) {
                Text("Friends")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(selectedTab == "Friends" ? Color.orange.opacity(0.2) : Color.clear)
                    .foregroundColor(selectedTab == "Friends" ? .orange : .gray)
                    .cornerRadius(8)
            }

            Button(action: {
                selectedTab = "Events"
            }) {
                Text("Events")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(selectedTab == "Events" ? Color.orange.opacity(0.2) : Color.clear)
                    .foregroundColor(selectedTab == "Events" ? .orange : .gray)
                    .cornerRadius(8)
            }
        }
        .padding(.horizontal)
    }

    // MARK: Costs List Section
    private var costsListSection: some View {
        ScrollView {
            VStack(spacing: 16) {
                if selectedTab == "Friends" {
                    ForEach(groupedByFriends().keys.sorted(), id: \.self) { friend in
                        Section(header: friendHeaderView(for: friend)) {
                            ForEach(groupedByFriends()[friend] ?? []) { transaction in
                                TransactionRow(transaction: transaction)
                                    .padding(.horizontal)
                                    .padding(.vertical, 8)
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                            }
                        }
                    }
                } else {
                    ForEach(groupedByEvents().keys.sorted(), id: \.self) { event in
                        Section(header: eventHeaderView(for: event)) {
                            ForEach(groupedByEvents()[event] ?? []) { transaction in
                                TransactionRow(transaction: transaction)
                                    .padding(.horizontal)
                                    .padding(.vertical, 8)
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    // MARK: Helper Methods
    private func groupedByFriends() -> [String: [Transaction]] {
        Dictionary(grouping: viewModel.transactions, by: { $0.payee.fullName })
    }

    private func groupedByEvents() -> [String: [Transaction]] {
        Dictionary(grouping: viewModel.transactions, by: { $0.event.eventName })
    }

    private func totalOwedToYou() -> Float {
        viewModel.transactions
            .filter { $0.payee.fullName == "Leila" }
            .reduce(0) { $0 + $1.amount }
    }

    private func totalYouOwe() -> Float {
        viewModel.transactions
            .filter { $0.payer.fullName == "Leila" }
            .reduce(0) { $0 + $1.amount }
    }

    private func totalBalance() -> Float {
        totalOwedToYou() - totalYouOwe()
    }

    private func friendHeaderView(for friend: String) -> some View {
        HStack {
            Image(systemName: "person.circle.fill")
                .foregroundColor(.orange)
                .font(.title2)
            Text(friend)
                .font(.headline)
                .foregroundColor(.black)
            Spacer()
        }
        .padding(.vertical, 8)
        .background(Color.orange.opacity(0.1))
        .cornerRadius(8)
    }

    private func eventHeaderView(for event: String) -> some View {
        HStack {
            Image(systemName: "calendar.circle.fill")
                .foregroundColor(.orange)
                .font(.title2)
            Text(event)
                .font(.headline)
                .foregroundColor(.black)
            Spacer()
        }
        .padding(.vertical, 8)
        .background(Color.orange.opacity(0.1))
        .cornerRadius(8)
    }
}
