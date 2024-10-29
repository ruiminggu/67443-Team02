//
//  HomePageViewModel.swift
//  Team02
//
//  Created by 顾芮名 on 10/28/24.
//

import Foundation

class HomePageViewModel: ObservableObject {
    @Published var user: User
    @Published var upcomingEvents: [Event] = []
    @Published var recommendedRecipes: [Recipe] = []

    init(user: User, menuDatabase: MenuDatabase) {
        self.user = user
        self.upcomingEvents = user.events.filter { $0.date > Date() }
        self.recommendedRecipes = menuDatabase.recommendedRecipes
    }
}
