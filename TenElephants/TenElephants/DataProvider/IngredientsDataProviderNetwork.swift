//
//  IngredientsDataProviderNetwork.swift
//  TenElephants
//
//  Created by Полина Скалкина on 17.12.2021.
//

import Foundation

final class IngredientsDataProviderNetwork: IngredientsDataProvider {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    func fetchIngredientsList(completionHandler: @escaping (Result<
        IngredientsUIData,
        NetworkFetchingError
    >) -> Void) {
        networkService.getFullIngredientsList { result in
            switch result {
            case let .success(ingredients):
                let ingredientsData = IngredientsUIData(
                    ingredients: ingredients.meals.map {
                        IngredientUIData(ingredient: $0)
                    }
                )
                completionHandler(.success(ingredientsData))
            case let .failure(error):
                completionHandler(.failure(error))
            }
        }
    }
}

extension IngredientUIData {
    fileprivate init(ingredient: FullIngredient) {
        self.init(
            title: ingredient.name,
            type: ingredient.type,
            description: ingredient.description
        )
    }
}
