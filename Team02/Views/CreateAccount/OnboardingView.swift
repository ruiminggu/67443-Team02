//
//  OnboardingView.swift
//  Team02
//
//  Created by Leila Lei on 12/6/24.
//

import SwiftUI

struct OnboardingView: View {
    var onFinish: () -> Void // Callback when onboarding is finished

    var body: some View {
        TabView {
            // Step 1
            VStack(spacing: 20) {
                Image("step1")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)

                Text("1. Organize an Event")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top)

                Text("Plan and manage events seamlessly with your friends.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding()

            // Step 2
            VStack(spacing: 20) {
                Image("step2")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)

                Text("2. Add Dishes to Menu")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top)

                Text("Curate a personalized menu for your events.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding()

            // Step 3
            VStack(spacing: 20) {
                Image("step3")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)

                Text("3. Split Cost with Friends")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top)

                Text("Easily divide expenses among participants.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding()
        }
        .tabViewStyle(PageTabViewStyle())
        .background(Color(.systemBackground))
        .ignoresSafeArea()
        .overlay(
            Button(action: onFinish) {
                Text("Get Started")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .cornerRadius(10)
                    .padding(.horizontal, 40)
            }
            .padding(.bottom, 50),
            alignment: .bottom
        )
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(onFinish: {})
    }
}
