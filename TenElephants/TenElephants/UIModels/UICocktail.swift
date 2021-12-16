//
//  UICocktail.swift
//  TenElephants
//
//  Created by Дарья Домрачева on 16.12.2021.
//

import Foundation

struct UIDrinks {
    let drinks: [Cocktail]
}

struct UICocktail {
    let id: String // idMeal
    let name: String? // strMeal
    let thumbnailLink: String? // strMealThumb
    let instructions: String? // strInstructions
    let ingredients: [Ingredient]? // Ingredient(strIngredient, strMeasure)
    let category: String? // strCategory
    let glassType: String? // strGlass
    let isAlcoholic: String? // strAlcoholic

    init(cocktailObj: Cocktail) {
        id = cocktailObj.id
        name = cocktailObj.name
        thumbnailLink = cocktailObj.thumbnailLink
        instructions = cocktailObj.instructions
        ingredients = cocktailObj.ingredients
        category = cocktailObj.category
        glassType = cocktailObj.glassType
        isAlcoholic = cocktailObj.isAlcoholic
    }
}
