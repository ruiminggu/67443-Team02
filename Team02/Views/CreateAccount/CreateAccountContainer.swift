//
//  CreateAccountContainer.swift
//  Team02
//
//  Created by Leila Lei on 12/6/24.
//

import SwiftUI

struct CreateAccountContainer: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false

    var body: some View {
        Group {
            if isLoggedIn && hasSeenOnboarding {
                // User is logged in and has completed onboarding
                // Navigate to the main app content
                ContentView()
            } else if isLoggedIn && !hasSeenOnboarding {
                // User is logged in but has not completed onboarding
                OnboardingView {
                    print("🎉 Onboarding finished! Switching to main app.")
                    hasSeenOnboarding = true
                }
            } else {
                // User is not logged in yet
                CreateAccountView {
                    print("✅ Account created! Switching to onboarding...")
                    isLoggedIn = true
                }
            }
        }
        .animation(.easeInOut, value: isLoggedIn || hasSeenOnboarding)
    }
}
