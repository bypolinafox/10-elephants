//
//  Cocktails.swift
//  Ten Elephants
//
//  Created by Дарья Домрачева on 09.12.2021.
//
import Foundation

struct Drinks: Decodable {
    enum CodingKeys: String, CodingKey {
        case drinks
    }

    let drinks: [Cocktail]
}

struct Cocktail {
    // always present
    let id: String // idDrink

    // can be absent in some cases
    let name: String? // strDrink
    let thumbnailLink: String? // strDrinkThumb
    // might be present only in full model
    let category: String? // strCategory
    let area: String? // strArea
    let instructions: String? // strInstructions
    let youTubeLink: String? // strVideo
    let tags: [String]? // strTags
    let ingredients: [Ingredient]? // Ingredient(strIngredient, strMeasure)
    let glassType: String? // strGlass
    let isAlcoholic: String? // strAlcoholic
}

extension Cocktail: Decodable {
    private enum RequiredCodingKeys: String, CodingKey, CaseIterable {
        case strDrink
        case idDrink
        case strDrinkThumb
    }

    private enum OptionalCodingKeys: String, CodingKey, CaseIterable {
        case strCategory
        case strArea
        case strInstructions
        case strVideo
        case strTags
        case strGlass
        case strAlcoholic
    }

    init(from decoder: Decoder) throws {
        let commonContainer = try decoder.container(keyedBy: RequiredCodingKeys.self)

        // this value should always be present:
        id = try commonContainer.decode(String.self, forKey: .idDrink)

        // try to get these values, they can be used for preview
        name = try commonContainer.decodeIfPresent(String.self, forKey: .strDrink)
        thumbnailLink = try commonContainer.decodeIfPresent(
            String.self,
            forKey: .strDrinkThumb
        )

        let customContainer = try decoder.container(keyedBy: OptionalCodingKeys.self)

        // these values can be missing in preview model
        category = try customContainer.decodeIfPresent(String.self, forKey: .strCategory)
        area = try customContainer.decodeIfPresent(String.self, forKey: .strArea)
        instructions = try customContainer.decodeIfPresent(String.self, forKey: .strInstructions)
        youTubeLink = try customContainer.decodeIfPresent(String.self, forKey: .strVideo)

        tags = try customContainer.decodeIfPresent(String.self, forKey: .strTags).flatMap {
            $0.components(separatedBy: ",")
        }
        glassType = try customContainer.decodeIfPresent(String.self, forKey: .strGlass)
        isAlcoholic = try customContainer.decodeIfPresent(String.self, forKey: .strAlcoholic)

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

        for num in 1...15 {
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
