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
        self.id = try commonContainer.decode(String.self, forKey: .idDrink)

        // try to get these values, they can be used for preview
        self.name = try commonContainer.decodeIfPresent(String.self, forKey: .strDrink)
        self.thumbnailLink = try commonContainer.decodeIfPresent(
            String.self,
            forKey: .strDrinkThumb
        )

        let customContainer = try decoder.container(keyedBy: OptionalCodingKeys.self)

        // these values can be missing in preview model
        self.category = try customContainer.decodeIfPresent(String.self, forKey: .strCategory)
        self.area = try customContainer.decodeIfPresent(String.self, forKey: .strArea)
        self.instructions = try customContainer.decodeIfPresent(
            String.self,
            forKey: .strInstructions
        )
        self.youTubeLink = try customContainer.decodeIfPresent(String.self, forKey: .strVideo)

        self.tags = try customContainer.decodeIfPresent(String.self, forKey: .strTags).flatMap {
            $0.components(separatedBy: ",")
        }
        self.glassType = try customContainer.decodeIfPresent(String.self, forKey: .strGlass)
        self.isAlcoholic = try customContainer.decodeIfPresent(String.self, forKey: .strAlcoholic)

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
            self.ingredients = nil
            return
        }

        let filteredKeysNames = filteredKeys.map(\.stringValue)

        for num in 1...15 {
            let ingredientKeyName = "strIngredient\(num)"
            let measureKeyName = "strMeasure\(num)"
            guard filteredKeysNames.contains(ingredientKeyName),
                  filteredKeysNames.contains(measureKeyName) else {
                self.ingredients = nil
                assertionFailure("Unexpected data format")
                return
            }
            if let ingredientKey = GenericCodingKeys(stringValue: ingredientKeyName),
               let measureKey = GenericCodingKeys(stringValue: measureKeyName) {
                guard let ingrName = try? otherContainer.decode(
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
                if ingrName.isEmpty,
                   measure.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    break // found end of ingredient list
                }

                assert(
                    !ingrName.isEmpty,
                    "Inconsistency in data: \(ingredientKeyName) and \(measureKeyName)"
                )
                let ingredient = Ingredient(
                    name: ingrName,
                    measure: measure.isEmpty ? nil : measure
                )
                localIngredients.append(ingredient)
            }
        }
        self.ingredients = localIngredients.isEmpty ? nil : localIngredients
    }
}
