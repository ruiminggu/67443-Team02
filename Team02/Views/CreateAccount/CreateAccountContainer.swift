//
//  CreateAccountContainer.swift
//  Team02
//
//  Created by Leila Lei on 12/6/24.
//

import SwiftUI

struct CreateAccountContainer: View {
    @State private var isOnboardingActive = false
    @State private var isMainAppActive = false

    var body: some View {
        Group {
            if isMainAppActive {
                ContentView()
            } else if isOnboardingActive {
                OnboardingView {
                    print("🎉 Onboarding finished! Switching to main app.")
                    isOnboardingActive = false
                    isMainAppActive = true
                }
            } else {
                CreateAccountView {
                    print("✅ Account created! Switching to onboarding...")
                    isOnboardingActive = true
                }
            }
        }
        .animation(.easeInOut, value: isOnboardingActive || isMainAppActive)
    }
}
