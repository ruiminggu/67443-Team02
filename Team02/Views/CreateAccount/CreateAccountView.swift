import SwiftUI
import FirebaseAuth
import FirebaseDatabase

struct CreateAccountView: View {
    var onAccountCreated: () -> Void // Make it non-optional

      init(onAccountCreated: @escaping () -> Void) { // Remove the default value
          self.onAccountCreated = onAccountCreated
      }

    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage: String?
    @State private var isLoading = false
    @Environment(\.presentationMode) var presentationMode

    private var databaseRef: DatabaseReference = Database.database().reference()

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Create Account")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                TextField("Full Name", text: $fullName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.words)
                    .padding(.horizontal)

                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .padding(.horizontal)

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                SecureField("Confirm Password", text: $confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                Button(action: createAccount) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .tint(.white)
                    } else {
                        Text("Sign Up")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(Color.orange)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                }
                .disabled(isLoading)

                Spacer()
            }
            .padding(.top, 50)
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }

    private func createAccount() {
        guard !fullName.isEmpty, !email.isEmpty, !password.isEmpty else {
            errorMessage = "All fields are required."
            return
        }

        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return
        }

        isLoading = true
        errorMessage = nil

        let userUUID = UUID()

        // Create the user in Firebase Authentication
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = "Failed to create account: \(error.localizedDescription)"
                self.isLoading = false
                return
            }

            guard let firebaseUID = result?.user.uid else {
                self.errorMessage = "Failed to retrieve user UID."
                self.isLoading = false
                return
            }

            // Save user data to Firebase Database
            let userData: [String: Any] = [
                "id": userUUID.uuidString, // Store the UUID
                "firebaseUID": firebaseUID, // Store the Firebase UID for reference
                "fullName": self.fullName,
                "email": self.email,
                "image": "profile_pic",
                "events": [],
                "likedRecipes": []
            ]

            self.databaseRef.child("users").child(firebaseUID).setValue(userData) { error, _ in
                if let error = error {
                    self.errorMessage = "Failed to save user data: \(error.localizedDescription)"
                } else {
                    self.onAccountCreated() // Notify that the account was created
                    self.presentationMode.wrappedValue.dismiss()
                }
                self.isLoading = false
            }
        }
    }
}
