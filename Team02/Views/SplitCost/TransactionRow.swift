//
//  TransactionRow.swift
//  Team02
//
//  Created by Leila Lei on 12/1/24.
//

import SwiftUI

struct TransactionRow: View {
    let transaction: Transaction
    
    var body: some View {
        HStack {
            Text(transaction.item)
            Spacer()
            Text("$\(transaction.amount, specifier: "%.2f")")
        }
    }
}
