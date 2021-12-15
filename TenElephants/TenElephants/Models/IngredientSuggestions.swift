//
//  IngredientSuggestions.swift
//  Ten Elephants
//
//  Created by Алексей Шерстнёв on 14.12.2021.
//

import Foundation

struct IngredientSuggestion {
    let name: String // this name is shown in ui
    let emoji: String?

    init(_ name: String, _ emoji: String?) {
        self.name = name
        self.emoji = emoji
    }
}

extension IngredientSuggestion {
    var fullName: String {
        guard let emoji = emoji else { return name }
        return "\(emoji) \(name)"
    }
}

func getEmoji(ingredientName: String) -> String? {
    ingredientSuggestions[ingredientName.lowercased()]?.emoji
}

let ingredientSuggestions: [String: IngredientSuggestion] = [
    "apples": .init("Apple", "🍎"), // id: 488
    "orange": .init("Orange", "🍊"), // 228
    "pears": .init("Pear", "🍐"), // 495
    "lemon": .init("Lemon", "🍋"), // 197
    "banana": .init("Banana", "🍌"), // id: 407
    "broccoli": .init("Broccoli", "🥦"), // id: 37
    "lettuce": .init("Lettuce", "🥬"), // id: 201
    "strawberries": .init("Strawberry", "🍓"), // id: 304
    "tomatoes": .init("Tomato", "🍅"), // id: 45
    "bread": .init("Bread", "🍞"), // id: 35
    "eggs": .init("Eggs", "🥚"), // id: 123
    "cheese": .init("Cheese", "🧀"), // id: 60
    "yellow pepper": .init("Bell Pepper", "🫑"), // id: 424
    "onions": .init("Onions", "🧅"), // id: 227
    "potatoes": .init("Potato", "🥔"), // id: 253
    "bacon": .init("Bacon", "🥓"), // id: 14
    "beef": .init("Beef", "🥩"), // id: 3
    "milk chocolate": .init("Chocolate", "🍫"), // id: 416
    "cucumber": .init("Cucumber", "🥒"), // id: 103
    "desiccated coconut": .init("Coconut", "🥥"), // id: 500
    "butter": .init("Butter", "🧈"), // id: 41
    "aubergine": .init("Aubergine", "🍆"), // id: 11
    "onion": .init("Onions", "🧅"), // id: 227
    "olive oil": .init("Olive oil", "🫒"), // id: 224
    "carrots": .init("Carrots", "🥕"), // id: 49
    "lamb leg": .init("Lamb leg", "🍗"), // id: 380
    "garlic": .init("Garlic", "🧄"), // id: 149
    "honey": .init("Honey", "🍯"), // id: 177
    "parsley": .init("Parsley", "🌿"), // id: 237
    "chicken breast": .init("Chicken breast", "🐔"), // id: 65
    "chicken breasts": .init("Chicken breasts", "🐔"), // id: 66
    "chicken stock": .init("Chicken Stock", "🥣"), // id: 68
    "water": .init("Water", "💦"), // id: 333
    "milk": .init("Milk", "🥛"), // id: 211
    "fruit mix": .init("Fruit mix", "🍉"), // id: 476
    "lemons": .init("Lemons", "🍋"), // id: 200
    "egg": .init("Egg", "🥚"), // id: 483
    "red wine": .init("Red wine", "🍷"), // id: 266
    "cooking wine": .init("Cooking wine", "🍷"), // id:
    "white wine": .init("White wine", "🍷"), // id: 338
    "pepper": .init("Pepper", "🌶"), // id: 244
    "oil": .init("Oil", "🌻"), // id: 223
    "sunflower oil": .init("Sunflower oil", "🌻"), // id: 307
    "dark chocolate": .init("Dark Chocolate", "🍫"), // id: 416
    "egg white": .init("Egg White", "🥚"), // id: 121
    "salt": .init("Salt", "🧂"), // id: 281
    "beef stock": .init("Beef stock", "🥣"), // id:
    "unsalted butter": .init("Unstalted butter", "🧈"), // id:
    "sea salt": .init("Sea salt", "🧂"), // id:
    "rice": .init("Rice", "🍚"), // id:
]
