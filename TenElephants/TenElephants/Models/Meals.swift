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

struct Meal {
    // always present
    let id: String // idMeal

    // can be absent in some cases
    let name: String? // strMeal
    let thumbnailLink: String? // strMealThumb
    // might be present only in full model
    let category: String? // strCategory
    let area: String? // strArea
    let instructions: String? // strInstructions
    let youTubeLink: String? // strYoutube
    let tags: [String]? // strTags
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
        id = try commonContainer.decode(String.self, forKey: .idMeal)

        // try to get these values, they can be used for preview
        name = try commonContainer.decodeIfPresent(String.self, forKey: .strMeal)
        thumbnailLink = try commonContainer.decodeIfPresent(String.self, forKey: .strMealThumb)

        let customContainer = try decoder.container(keyedBy: OptionalCodingKeys.self)

        // these values can be missing in preview model
        category = try customContainer.decodeIfPresent(String.self, forKey: .strCategory)
        area = try customContainer.decodeIfPresent(String.self, forKey: .strArea)
        instructions = try customContainer.decodeIfPresent(String.self, forKey: .strInstructions)
        youTubeLink = try customContainer.decodeIfPresent(String.self, forKey: .strYoutube)

        tags = try customContainer.decodeIfPresent(String.self, forKey: .strTags).flatMap {
            $0.components(separatedBy: ",")
        }

        var localIngredients: [Ingredient] = []

        let otherContainer = try decoder.container(keyedBy: GenericCodingKeys.self)
        let decodedKeysCommon = RequiredCodingKeys.allCases.map(\.rawValue)
        let decodedKeysCustom = OptionalCodingKeys.allCases.map(\.rawValue)

        let filteredKeys = otherContainer.allKeys.filter {
            !decodedKeysCommon.contains($0.stringValue) && !decodedKeysCustom
                .contains($0.stringValue)
        }

        // assuming return when having only RequiredCodingKeys
        guard !filteredKeys.isEmpty else {
            ingredients = nil
            return
        }

        let filteredKeysNames = filteredKeys.map(\.stringValue)

        for num in 1...20 {
            let ingredientKeyName = "strIngredient\(num)"
            let measureKeyName = "strMeasure\(num)"
            guard filteredKeysNames.contains(ingredientKeyName),
                  filteredKeysNames.contains(measureKeyName) else {
                ingredients = nil
                assertionFailure("Unexpected data format")
                return
            }
            if let ingredientKey = GenericCodingKeys(stringValue: ingredientKeyName),
               let measureKey = GenericCodingKeys(stringValue: measureKeyName) {
                guard let ingredientName = try? otherContainer.decode(
                    String.self, forKey: ingredientKey
                ).trimmingCharacters(in: .whitespaces) else {
                    break // found end of ingredient list
                }
                guard let measure = try? otherContainer.decode(
                    String.self, forKey: measureKey
                ) else {
                    assertionFailure("Missing required JSON property: \(measureKeyName)")
                    break
                }

                // Measure able to be empty (or whitespace) while corresponding ingredient not. id for testing: 53000
                if ingredientName.isEmpty,
                   measure.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    break // found end of ingredient list
                }

                assert(
                    !ingredientName.isEmpty,
                    "Inconsistency in data: \(ingredientKeyName) and \(measureKeyName)"
                )
                let ingredient = Ingredient(
                    name: ingredientName,
                    measure: measure.isEmpty ? nil : measure
                )
                localIngredients.append(ingredient)
            }
        }
        ingredients = localIngredients.isEmpty ? nil : localIngredients
    }
}
