//
//  CustomRecipe.swift
//  Team02
//
//  Created by Xinyi Chen on 12/1/24.
//
import Foundation

struct CustomRecipe: Identifiable {
    let id: UUID
    let title: String
    let creatorId: String
    var image: String?
    let instructions: String
    let ingredients: [CustomIngredient]
    let sharedWithEvents: [String]
    let isPrivate: Bool
    
    init(
        id: UUID = UUID(),
        title: String,
        creatorId: String,
        image: String? = nil,
        instructions: String,
        ingredients: [CustomIngredient],
        sharedWithEvents: [String],
        isPrivate: Bool
    ) {
        self.id = id
        self.title = title
        self.creatorId = creatorId
        self.image = image
        self.instructions = instructions
        self.ingredients = ingredients
        self.sharedWithEvents = sharedWithEvents
        self.isPrivate = isPrivate
    }
    
    func toDictionary() -> [String: Any] {
        [
            "id": id.uuidString,
            "title": title,
            "creatorId": creatorId,
            "image": image as Any,
            "instructions": instructions,
            "ingredients": ingredients.map { $0.toDictionary() },
            "sharedWithEvents": sharedWithEvents,
            "isPrivate": isPrivate
        ]
    }
}

struct CustomIngredient: Identifiable {
    let id: UUID
    let name: String
    let amount: String
    
    func toDictionary() -> [String: Any] {
        [
            "id": id.uuidString,
            "name": name,
            "amount": amount
        ]
    }
}
