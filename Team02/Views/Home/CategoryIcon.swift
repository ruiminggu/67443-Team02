import SwiftUI

struct CategoryIcon: View {
    let name: String
    let systemImage: String

    var body: some View {
        VStack {
            Image(systemName: systemImage)
                .font(.title)
                .foregroundColor(.orange)
            Text(name)
                .font(.caption)
                .foregroundColor(.primary)
        }
    }
}

