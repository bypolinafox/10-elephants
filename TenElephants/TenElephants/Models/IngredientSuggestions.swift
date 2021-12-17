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

func getEmoji(ingredientName: String, drinks: Bool = false) -> String? {
    if drinks {
        return ingredientSuggestionsCocktail[ingredientName.lowercased()]?.emoji
    }
    return ingredientSuggestions[ingredientName.lowercased()]?.emoji
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

let ingredientSuggestionsCocktail: [String: IngredientSuggestion] = [
    "Light rum": .init("Light rum", "🥃"),
    "Applejack": .init("Applejack", "🍎"),
    "Dark rum": .init("Dark rum", "🥃"),
    "Strawberry schnapps": .init("Strawberry schnapps", "🍓"),
    "Scotch": .init("Scotch", "🥃"),
    "Apricot brandy": .init("Apricot brandy", "🥃"),
    "Southern Comfort": .init("Southern Comfort", ""),
    "Orange bitters": .init("Orange bitters", "🍊"),
    "Brandy": .init("Brandy", "🥃"),
    "Lemon vodka": .init("Lemon vodka", "🍋"),
    "Tea": .init("Tea", "☕🫖"),
    "Champagne": .init("Champagne", "🍾"),
    "Coffee liqueur": .init("Coffee liqueur", "☕️"),
    "Bourbon": .init("Bourbon", "🥃"),
    "Añejo rum": .init("Añejo rum", "🥃"),
    "Kahlua": .init("Kahlua", "☕️"),
    "Watermelon": .init("Watermelon", "🍉"),
    "Lime juice": .init("Lime juice", "🍋"),
    "Irish whiskey": .init("Irish whiskey", "☘️"),
    "Apple brandy": .init("Apple brandy", "🍎"),
    "Carbonated water": .init("Carbonated water", "💧"),
    "Cherry brandy": .init("Cherry brandy", "🍒"),
    "Coffee brandy": .init("Coffee brandy", "☕️"),
    "Red wine": .init("Red wine", "🍷"),
    "Rum": .init("Rum", "🥃"),
    "Grapefruit juice": .init("Grapefruit juice", "🍇"),
    "Sherry": .init("Sherry", ""),
    "Cognac": .init("Cognac", "🥃"),
    "Apple juice": .init("Apple juice", "🍎"),
    "Pineapple juice": .init("Pineapple juice", "🍍"),
    "Lemon juice": .init("Lemon juice", "🍋"),
    "Sugar syrup": .init("Sugar syrup", ""),
    "Milk": .init("Milk", "🥛"),
    "Strawberries": .init("Strawberries", "🍓"),
    "Chocolate syrup": .init("Chocolate syrup", "🍫"),
    "Yoghurt": .init("Yoghurt", "🍦"),
    "Mango": .init("Mango", "🥭"),
    "Ginger": .init("Ginger", ""),
    "Lime": .init("Lime", "🍋"),
    "Cantaloupe": .init("Cantaloupe", ""),
    "Berries": .init("Berries", "🫐"),
    "Grapes": .init("Grapes", "🍇"),
    "Kiwi": .init("Kiwi", "🥝"),
    "Tomato juice": .init("Tomato juice", "🍅"),
    "Cocoa powder": .init("Cocoa powder", ""),
    "Chocolate": .init("Chocolate", "🍫"),
    "Heavy cream": .init("Heavy cream", "🍦"),
    "Galliano": .init("Galliano", ""),
    "Peach Vodka": .init("Peach Vodka", "🍑"),
    "Coffee": .init("Coffee", "☕️"),
    "Spiced rum": .init("Spiced rum", "🥃"),
    "Water": .init("Water", "💧"),
    "Espresso": .init("Espresso", "☕️"),
    "Angelica root": .init("Angelica root", ""),
    "Orange": .init("Orange", "🍊"),
    "Cranberries": .init("Cranberries", ""),
    "Johnnie Walker": .init("Johnnie Walker", ""),
    "Apple cider": .init("Apple cider", "🍎"),
    "Cranberry juice": .init("Cranberry juice", ""),
    "Egg yolk": .init("Egg yolk", "🥚"),
    "Egg": .init("Egg", "🥚"),
    "Grape juice": .init("Grape juice", "🍇"),
    "Peach nectar": .init("Peach nectar", "🍑"),
    "Lemon": .init("Lemon", "🍋"),
    "Lemonade": .init("Lemonade", "🍋"),
    "Whiskey": .init("Whiskey", "🥃"),
    "Ale": .init("Ale", "🍺"),
    "Chocolate liqueur": .init("Chocolate liqueur", "🍫"),
    "Midori melon liqueur": .init("Midori melon liqueur", "🍈"),
    "Blackberry brandy": .init("Blackberry brandy", "🥃"),
]
