//
//  IngredientSuggestions.swift
//  Ten Elephants
//
//  Created by Алексей Шерстнёв on 14.12.2021.
//

import Foundation

struct IngredientSuggestion {
    let name: String //this name is shown in ui
    let emoji: String?
    
    init(_ name: String, _ emoji: String?){
        self.name = name
        self.emoji = emoji
    }
}

extension IngredientSuggestion {
    var fullName: String {
        guard let emoji = emoji else {return name}
        return "\(emoji) \(name)"
    }
}

let ingredientSuggestions: [String: IngredientSuggestion] = [
    "Apples" : .init("Apple", "🍎"), //id: 488
    "Orange" : .init("Orange", "🍊"), //228
    "Pears" : .init("Pear", "🍐"), //495
    "Lemon" : .init("Lemon", "🍋"), //197
    "Banana" : .init("Banana", "🍌"), //id: 407
    "Broccoli" : .init("Broccoli", "🥦"), //id: 37
    "Lettuce" : .init("Lettuce", "🥬"), //id: 201
    "Strawberries" : .init("Strawberry", "🍓"), //id: 304
    "Tomatoes" : .init("Tomato", "🍅"), //id: 45
    "Bread" : .init("Bread", "🍞"), //id: 35
    "Eggs" : .init("Eggs", "🥚"), //id: 123
    "Cheese" : .init("Cheese", "🧀"), //id: 60
    "Yellow Pepper" : .init("Bell Pepper", "🫑"), //id: 424
    "Onions" : .init("Onions", "🧅"), //id: 227
    "Potatoes" : .init("Potato", "🥔"), //id: 253
    "Bacon" : .init("Bacon", "🥓"), //id: 14
    "Beef" : .init("Beef", "🥩"), //id: 3
    "Milk Chocolate" : .init("Chocolate", "🍫"), //id: 416
    "Cucumber" : .init("Cucumber", "🥒"), //id: 103
    "Desiccated Coconut" : .init("Coconut", "🥥"), //id: 500
    "Butter" : .init("Butter", "🧈"), //id: 41
    "Aubergine" : .init("Aubergine", "🍆") //id: 11
]
