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
    let id: String                 // idMeal
    let name: String?              // strMeal
    let thumbnailLink: String?     // strMealThumb
    let category: String?          // strCategory
    let area: String?              // strArea
    let instructions: String?      // strInstructions
    let youTubeLink: String?       // strYoutube
    let tags: [String]?            // strTags
    let ingredients: [Ingredient]? // Ingredient(strIngredient, strMeasure)

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
        category = mealObj.category
        area = mealObj.area
        instructions = mealObj.instructions
        youTubeLink = mealObj.youTubeLink
        tags = mealObj.tags
        ingredients = mealObj.ingredients
    }
}
