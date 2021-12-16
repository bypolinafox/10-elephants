//
//  UIMeals.swift
//  Ten Elephants
//
//  Created by Kirill Denisov on 13.12.2021.
//

import Foundation

struct UIMeals {
    let meals: [UIMeal]
}

struct UIMeal {
    let dataProvider: DBDataProvider
    let id: String // idMeal
    let name: String? // strMeal
    let thumbnailLink: String? // strMealThumb
    let instructions: String? // strInstructions
    let ingredients: [Ingredient]? // Ingredient(strIngredient, strMeasure)
    let category: String? // strCategory

    var isLiked: Bool {
        get {
            dataProvider.isLiked(id)
        }
        set {
            dataProvider.setIsLiked(id)
        }
    }

    init(mealObj: Meal, dataProvider: DBDataProvider) {
        self.dataProvider = dataProvider

        id = mealObj.id
        name = mealObj.name
        thumbnailLink = mealObj.thumbnailLink
        instructions = mealObj.instructions
        ingredients = mealObj.ingredients
        category = mealObj.category
    }
}
