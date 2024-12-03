//
//  CreateCustomRecipeView.swift
//  Team02
//
//  Created by Xinyi Chen on 12/2/24.
//

//import SwiftUI
//import PhotosUI
//
//struct CreateCustomRecipeView: View {
//    @StateObject private var viewModel = CustomRecipeViewModel()
//    @Environment(\.dismiss) private var dismiss
//    @State private var currentStep = 1
//    @State private var title = ""
//    @State private var description = ""
//    @State private var image: UIImage?
//    @State private var ingredients: [CustomIngredient] = []
//    @State private var currentIngredient = (name: "", quantity: "")
//    @State private var instructions: [String] = [""]
//    @State private var categories: Set<String> = []
//    @State private var estimatedTime = ""
//    
//    let steps = ["Basic Info", "Ingredients", "Review"]
//    let event: Event
//    init(event: Event) {
//        self.event = event
//    }
//    
//    var body: some View {
//        VStack(spacing: 0) {
//            // Progress bar
//            HStack(spacing: 20) {
//                ForEach(0..<3) { index in
//                    HStack {
//                        Circle()
//                            .fill(currentStep > index ? Color.orange : Color.gray)
//                            .frame(width: 24, height: 24)
//                            .overlay(
//                                Text("\(index + 1)")
//                                    .foregroundColor(.white)
//                                    .font(.caption)
//                            )
//                        if index < 2 {
//                            Rectangle()
//                                .fill(currentStep > index + 1 ? Color.orange : Color.gray)
//                                .frame(height: 2)
//                        }
//                    }
//                }
//            }
//            .padding()
//            
//            ScrollView {
//                switch currentStep {
//                case 1:
//                    BasicInfoView(
//                        title: $title,
//                        description: $description,
//                        image: $image
//                    )
//                case 2:
//                    IngredientsInstructionsView(
//                        ingredients: $ingredients,
//                        currentIngredient: $currentIngredient,
//                        instructions: $instructions
//                    )
//                case 3:
//                    ReviewView(
//                        title: title,
//                        image: image,
//                        ingredients: ingredients,
//                        instructions: instructions,
//                        estimatedTime: estimatedTime,
//                        categories: $categories
//                    )
//                default:
//                    EmptyView()
//                }
//            }
//            
//            Button(action: handleContinue) {
//                Text(currentStep == 3 ? "Finish" : "Continue")
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.orange)
//                    .foregroundColor(.white)
//                    .cornerRadius(25)
//                    .padding()
//            }
//        }
//        .navigationTitle(currentStep == 1 ? "Add New Recipe" : "Create New Recipe")
//        .navigationBarTitleDisplayMode(.inline)
//    }
//    
//    private func handleContinue() {
//        if currentStep < 3 {
//            currentStep += 1
//        } else {
//            saveRecipe()
//        }
//    }
//    
//    private func saveRecipe() {
//        // Save recipe implementation
//        dismiss()
//    }
//}
//
//struct BasicInfoView: View {
//    @Binding var title: String
//    @Binding var description: String
//    @Binding var image: UIImage?
//    @State private var showingImagePicker = false
//    
//    var body: some View {
//        VStack(spacing: 20) {
//            Button(action: { showingImagePicker = true }) {
//                ZStack {
//                    if let image = image {
//                        Image(uiImage: image)
//                            .resizable()
//                            .scaledToFill()
//                            .frame(height: 200)
//                            .clipped()
//                    } else {
//                        Rectangle()
//                            .fill(Color(.systemGray6))
//                            .frame(height: 200)
//                            .overlay(
//                                VStack {
//                                    Image(systemName: "arrow.up.square")
//                                        .font(.title)
//                                    Text("Upload Image")
//                                        .font(.headline)
//                                    Text("(You can upload up to 5 images)")
//                                        .font(.caption)
//                                        .foregroundColor(.gray)
//                                }
//                            )
//                    }
//                }
//            }
//            .sheet(isPresented: $showingImagePicker) {
//                ImagePicker(image: $image)
//            }
//            
//            VStack(alignment: .leading, spacing: 8) {
//                Text("Recipe Name")
//                    .font(.headline)
//                TextField("Chicken Ramen", text: $title)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                
//                Text("Description (Optional)")
//                    .font(.headline)
//                TextEditor(text: $description)
//                    .frame(height: 100)
//                    .padding(4)
//                    .background(Color(.systemGray6))
//                    .cornerRadius(8)
//            }
//            .padding()
//        }
//    }
//}
//
//struct ImagePicker: UIViewControllerRepresentable {
//    @Binding var image: UIImage?
//    @Environment(\.dismiss) private var dismiss
//
//    func makeUIViewController(context: Context) -> UIImagePickerController {
//        let picker = UIImagePickerController()
//        picker.delegate = context.coordinator
//        return picker
//    }
//
//    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//        let parent: ImagePicker
//
//        init(_ parent: ImagePicker) {
//            self.parent = parent
//        }
//
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            if let image = info[.originalImage] as? UIImage {
//                parent.image = image
//            }
//            parent.dismiss()
//        }
//    }
//}
//
//struct IngredientsInstructionsView: View {
//    @Binding var ingredients: [CustomIngredient]
//    @Binding var currentIngredient: (name: String, quantity: String)
//    @Binding var instructions: [String]
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 20) {
//            // Similar to your current implementation but styled like the screenshots
//        }
//    }
//}
//
//struct ReviewView: View {
//    let title: String
//    let image: UIImage?
//    let ingredients: [CustomIngredient]
//    let instructions: [String]
//    let estimatedTime: String
//    @Binding var categories: Set<String>
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 20) {
//            // Final review layout matching screenshot
//        }
//    }
//}
//
//
//struct CreateCustomRecipeView_Previews: PreviewProvider {
//    static let sampleEvent = Event(
//        recipes: [],
//        date: Date(),
//        startTime: Date(),
//        endTime: Date(),
//        location: "Sample Location",
//        eventName: "Sample Event",
//        qrCode: "",
//        costs: [],
//        totalCost: 0,
//        assignedIngredientsList: []
//    )
//    
//    static var previews: some View {
//        NavigationView {
//            CreateCustomRecipeView(event: sampleEvent)
//        }
//        .previewDisplayName("Empty Form")
//    }
//}
