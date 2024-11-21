import Foundation
import SwiftUI
import FirebaseFirestore
import PhotosUI

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var selfieImage: UIImage? = nil
    @Published var eventCount: Int = 0
    @Published var likedRecipes: [Recipe] = []
    @Published var isLoading: Bool = false

    private let userID = "8E23D734-2FBE-4D1E-99F7-00279E19585B" // Replace with dynamic logic
    private let db = Firestore.firestore()

    func fetchUserProfile() {
        isLoading = true
        let userRef = db.collection("users").document(userID)

        userRef.getDocument { [weak self] document, error in
            Task {
                guard let self = self else { return }
                self.isLoading = false
                if let document = document, document.exists {
                    let data = document.data() ?? [:]

                    // Count the number of events
                    if let events = data["events"] as? [String] {
                        self.eventCount = events.count
                    } else {
                        self.eventCount = 0
                    }

                    // Fetch liked recipes
//                    if let likedRecipesData = data["likedRecipes"] as? [[String: Any]] {
//                        self.likedRecipes = likedRecipesData.compactMap { Recipe(from: $0) }
//                    }
                } else {
                    print("Error fetching user profile: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
    }

    func saveSelfieToFirebase(image: UIImage) async {
        guard let compressedImageData = image.jpegData(compressionQuality: 0.8) else { return }
        
        // Implement Firebase Storage logic here
        print("Selfie upload logic goes here.")
    }

    func handlePhotoSelection(selectedItem: PhotosPickerItem?) async {
        guard let selectedItem = selectedItem else { return }

        do {
            if let data = try await selectedItem.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                self.selfieImage = image
                await saveSelfieToFirebase(image: image)
            }
        } catch {
            print("Error loading photo: \(error.localizedDescription)")
        }
    }
}
