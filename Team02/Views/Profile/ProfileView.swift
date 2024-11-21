import SwiftUI
import PhotosUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var selectedItem: PhotosPickerItem? = nil

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Selfie Upload Section
                VStack {
                    if let image = viewModel.selfieImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.orange, lineWidth: 2))
                            .padding(.top)
                    } else {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 150, height: 150)
                            .overlay(Text("Add Photo")
                                .foregroundColor(.gray))
                    }

                    PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                        Text("Upload Selfie")
                            .foregroundColor(.orange)
                            .font(.headline)
                    }
                    .onChange(of: selectedItem) { newItem in
                        Task {
                            await viewModel.handlePhotoSelection(selectedItem: newItem)
                        }
                    }
                }

                Divider()

                // Events Count Section
                HStack {
                    Text("Events Count:")
                        .font(.headline)
                    Spacer()
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        Text("\(viewModel.eventCount)")
                            .font(.title)
                            .bold()
                    }
                }
                .padding(.horizontal)

                Divider()

                // Liked Recipes Navigation
                VStack(alignment: .leading) {
                    Text("Liked Recipes")
                        .font(.headline)
                        .padding(.bottom, 5)

                    if viewModel.likedRecipes.isEmpty {
                        Text("No liked recipes yet.")
                            .foregroundColor(.gray)
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(viewModel.likedRecipes) { recipe in
                                    NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                                        VStack {
                                            Image(recipe.image)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 100, height: 100)
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                            Text(recipe.title)
                                                .font(.caption)
                                                .lineLimit(1)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding()
            .navigationTitle("Profile")
            .onAppear {
                viewModel.fetchUserProfile()
            }
        }
    }
}
