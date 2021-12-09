//
//  Meals.swift
//  Ten Elephants
//
//  Created by Дарья Домрачева on 09.12.2021.
//

import Foundation

struct  Meals: Decodable {
    enum CodingKeys: String, CodingKey {
        case meals
    }
    let meals: [MealModel]
}

struct MealModel: Decodable {
    // always present
    let name: String               // strMeal
    let id: String                 // idMeal
    let thumbnailLink: String      // strMealThumb

    // might be present in full model
    let category: String?          // strCategory
    let area: String?              // strArea
    let instructions: String?      // strInstructions
    let youTubeLink: String?       // strYoutube
    let tags: [String]?            // strTags

    let ingredients: [Ingredient]? // Ingredient(strIngredient, strMeasure)

    enum RequiredCodingKeys: String, CodingKey, CaseIterable {
        case strMeal,
             idMeal,
             strMealThumb
    }

    enum OptionalCodingKeys: String, CodingKey, CaseIterable {
        case strCategory,
             strArea,
             strInstructions,
             strYoutube,
             strTags
    }

    init(from decoder: Decoder) throws {
        let commonContainer = try decoder.container(keyedBy: RequiredCodingKeys.self)

        // these values should always be present:
        self.name           = try commonContainer.decode(String.self, forKey: .strMeal)
        self.id             = try commonContainer.decode(String.self, forKey: .idMeal)
        self.thumbnailLink  = try commonContainer.decode(String.self, forKey: .strMealThumb)

        let customContainer = try decoder.container(keyedBy: OptionalCodingKeys.self)

        // these values can be missing in preview model
        self.category       = try customContainer.decodeIfPresent(String.self, forKey: .strCategory)
        self.area           = try customContainer.decodeIfPresent(String.self, forKey: .strArea)
        self.instructions   = try customContainer.decodeIfPresent(String.self, forKey: .strInstructions)
        self.youTubeLink    = try customContainer.decodeIfPresent(String.self, forKey: .strYoutube)

        if let nonSplitTags = try customContainer.decode(String?.self, forKey: .strTags) {
            self.tags = nonSplitTags.components(separatedBy: ",")
        } else {
            self.tags = nil
        }

        var localIngredients: [Ingredient] = []

        let otherContainer = try decoder.container(keyedBy: GenericCodingKeys.self)
        let decodedKeysCommon = RequiredCodingKeys.allCases.map({ $0.rawValue })
        let decodedKeysCustom = OptionalCodingKeys.allCases.map({ $0.rawValue })

        let filteredKeys = otherContainer.allKeys.filter({
            !decodedKeysCommon.contains($0.stringValue) && !decodedKeysCustom.contains($0.stringValue)
        })

        // assuming return when having only RequiredCodingKeys
        guard !filteredKeys.isEmpty else {
            self.ingredients = nil
            return
        }

        let filteredKeysNames = filteredKeys.map({ $0.stringValue })

        for num in 1...20 {
            let ingredientKeyName = "strIndgredient\(num)"
            let measureKeyName    = "strMeasure\(num)"
            guard filteredKeysNames.contains(ingredientKeyName) &&
                  filteredKeysNames.contains(measureKeyName) else {
                self.ingredients = nil
                assertionFailure("Unexpected data format")
                return
            }
            if let ingredientKey = GenericCodingKeys(stringValue: ingredientKeyName) {
                if let measureKey = GenericCodingKeys(stringValue: measureKeyName) {
                    guard let ingrName = try? otherContainer.decode(String.self, forKey: ingredientKey) else {
                        break // found end of ingredient list
                    }
                    guard let measure = try? otherContainer.decode(String.self, forKey: measureKey) else {
                        assert(false, "Missing required JSON property: \(measureKeyName)")
                        break
                    }
                    if ingrName.isEmpty && measure.isEmpty {
                        break // found end of ingredient list
                    }
                    assert(!ingrName.isEmpty && !measure.isEmpty,
                           "Inconsistency in data: \(ingredientKeyName) and \(measureKeyName)")
                    let ingredient = Ingredient(name: ingrName, measure: measure)
                    localIngredients.append(ingredient)
                }
            }
        }
        self.ingredients = localIngredients.isEmpty ? nil : localIngredients
    }
}
