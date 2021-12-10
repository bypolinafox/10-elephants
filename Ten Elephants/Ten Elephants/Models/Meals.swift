//
//  Meals.swift
//  Ten Elephants
//
//  Created by Дарья Домрачева on 09.12.2021.
//

import Foundation

struct Meals: Decodable {
    enum CodingKeys: String, CodingKey {
        case meals
    }
    let meals: [Meal]
}

struct Meal{
    // always present
    let id: String                 // idMeal
    
    // can be absent in some cases
    let name: String?              // strMeal
    let thumbnailLink: String?     // strMealThumb

    // might be present only in full model
    let category: String?          // strCategory
    let area: String?              // strArea
    let instructions: String?      // strInstructions
    let youTubeLink: String?       // strYoutube
    let tags: [String]?            // strTags

    let ingredients: [Ingredient]? // Ingredient(strIngredient, strMeasure)
}

extension Meal: Decodable {
    private enum RequiredCodingKeys: String, CodingKey, CaseIterable {
        case strMeal
        case idMeal
        case strMealThumb
    }

    private enum OptionalCodingKeys: String, CodingKey, CaseIterable {
        case strCategory
        case strArea
        case strInstructions
        case strYoutube
        case strTags
    }

    init(from decoder: Decoder) throws {
        let commonContainer = try decoder.container(keyedBy: RequiredCodingKeys.self)

        // this value should always be present:
        self.id             = try commonContainer.decode(String.self, forKey: .idMeal)
        
        // try to get these values, they can be used for preview
        self.name           = try commonContainer.decodeIfPresent(String.self, forKey: .strMeal)
        self.thumbnailLink  = try commonContainer.decodeIfPresent(String.self, forKey: .strMealThumb)

        let customContainer = try decoder.container(keyedBy: OptionalCodingKeys.self)

        // these values can be missing in preview model
        self.category       = try customContainer.decodeIfPresent(String.self, forKey: .strCategory)
        self.area           = try customContainer.decodeIfPresent(String.self, forKey: .strArea)
        self.instructions   = try customContainer.decodeIfPresent(String.self, forKey: .strInstructions)
        self.youTubeLink    = try customContainer.decodeIfPresent(String.self, forKey: .strYoutube)

        self.tags = try customContainer.decodeIfPresent(String.self, forKey: .strTags).flatMap {
            $0.components(separatedBy: ",")
        }

        var localIngredients: [Ingredient] = []

        let otherContainer = try decoder.container(keyedBy: GenericCodingKeys.self)
        let decodedKeysCommon = RequiredCodingKeys.allCases.map(\.rawValue)
        let decodedKeysCustom = OptionalCodingKeys.allCases.map(\.rawValue)

        let filteredKeys = otherContainer.allKeys.filter {
            !decodedKeysCommon.contains($0.stringValue) && !decodedKeysCustom.contains($0.stringValue)
        }

        // assuming return when having only RequiredCodingKeys
        guard !filteredKeys.isEmpty else {
            self.ingredients = nil
            return
        }

        let filteredKeysNames = filteredKeys.map(\.stringValue)

        for num in 1...20 {
            let ingredientKeyName = "strIngredient\(num)"
            let measureKeyName    = "strMeasure\(num)"
            guard filteredKeysNames.contains(ingredientKeyName) &&
                  filteredKeysNames.contains(measureKeyName) else {
                self.ingredients = nil
                assertionFailure("Unexpected data format")
                return
            }
            if let ingredientKey = GenericCodingKeys(stringValue: ingredientKeyName),
               let measureKey = GenericCodingKeys(stringValue: measureKeyName) {
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
        self.ingredients = localIngredients.isEmpty ? nil : localIngredients
    }
}
