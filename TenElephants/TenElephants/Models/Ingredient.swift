//
//  Ingredient.swift
//  Ten Elephants
//
//  Created by Дарья Домрачева on 09.12.2021.
//

import Foundation

struct Ingredient: Decodable {
    let name: String
    let measure: String?
}

struct FullIngredients: Decodable {
    enum CodingKeys: String, CodingKey {
        case meals
    }

    let meals: [FullIngredient]
}

struct FullIngredient: Decodable {
    let id: String // idIngredient
    let name: String? // strIngredient

    // can be absent in some cases
    let description: String? // strDescription
    let type: String? // strType

    private enum RequiredCodingKeys: String, CodingKey, CaseIterable {
        case idIngredient
    }

    private enum OptionalCodingKeys: String, CodingKey, CaseIterable {
        case strIngredient
        case strDescription
        case strType
    }

    init(from decoder: Decoder) throws {
        let commonContainer = try decoder.container(keyedBy: RequiredCodingKeys.self)
        self.id = try commonContainer.decode(String.self, forKey: .idIngredient)

        let customContainer = try decoder.container(keyedBy: OptionalCodingKeys.self)
        self.name = try customContainer.decode(String.self, forKey: .strIngredient)
        self.description = try customContainer.decodeIfPresent(String.self, forKey: .strDescription)
        self.type = try customContainer.decodeIfPresent(String.self, forKey: .strType)
    }
}
